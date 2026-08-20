#!/usr/bin/env bash

[ -z "$1" ] && cat <<'EOF'

# svg2path — SVG text -> path outlines using ONLY the TTF files you pass.
# Everything runs inside Docker; no Python, pip, or fonts touch your machine.
#
# Usage:
#   ./svg2path input.svg output.svg \
#       --font "Ethnocentric:italic=./ethnocentric_it.ttf" \
#       --font "Ethnocentric=./ethnocentric_bk.ttf" \
#       [--baseline-metrics hhea|typo|win] [--offset DX,DY]
#
# All file paths (SVG + TTFs) must be inside the current directory tree,
# since only $PWD is mounted into the container.

EOF
[ -z "$1" ] && exit 1
#.

set -euo pipefail

IMAGE="svg-text-to-path:3"

command -v docker >/dev/null || { echo "error: docker not found" >&2; exit 1; }

build_image() {
    ctx="$(mktemp -d)"
    trap 'rm -rf "$ctx"' EXIT

    cat > "$ctx/Dockerfile" <<'DOCKEREOF'
FROM python:3.12-slim
RUN pip install --no-cache-dir "fonttools>=4.50" "uharfbuzz>=0.39"
COPY svg_text_to_path.py /opt/svg_text_to_path.py
WORKDIR /work
ENTRYPOINT ["python3", "/opt/svg_text_to_path.py"]
DOCKEREOF

    cat > "$ctx/svg_text_to_path.py" <<'PYEOF'
#!/usr/bin/env python3
"""
svg_text_to_path.py — convert <text>/<tspan> in an SVG to <path> outlines,
resolving fonts ONLY from TTF/OTF files given on the command line.
No fontconfig, no Font Book, no CoreText. Unmapped families are a hard error.

Usage:
  python3 svg_text_to_path.py input.svg output.svg \
      --font "Ethnocentric:italic=./fonts/ethnocentric_it.ttf" \
      --font "Ethnocentric=./fonts/ethnocentric_bk.ttf"

Font spec keys (case-insensitive):
  "Family"              -> regular
  "Family:italic"       -> italic/oblique
  "Family:bold"         -> weight >= 600
  "Family:bold-italic"  -> both

Supported now:
  - inline style="", presentation attributes, AND <style> blocks with
    simple selectors (tag, .class, #id, tag.class, comma lists)
  - font-size in px, pt, or unitless
  - dominant-baseline / alignment-baseline:
    alphabetic, central, middle, text-top, hanging, text-bottom, ideographic
  - x/y, text-anchor, letter-spacing, tspan with x/y and style overrides

Still unsupported: textPath, dx/dy/rotate, em/%/rem units, descendant CSS
selectors ("g text"), pseudo-classes.
"""

import argparse
import re
import sys
import xml.etree.ElementTree as ET

import uharfbuzz as hb
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.misc.transform import Transform

SVG_NS = "http://www.w3.org/2000/svg"
XLINK_NS = "http://www.w3.org/1999/xlink"
ET.register_namespace("", SVG_NS)
ET.register_namespace("xlink", XLINK_NS)

FONT_PROPS = {
    "font-family", "font-size", "font-style", "font-weight",
    "font-variant", "font-stretch", "font", "letter-spacing",
    "word-spacing", "text-anchor", "dominant-baseline",
    "alignment-baseline",
}

COPY_PROPS = {
    "fill", "fill-opacity", "fill-rule", "stroke", "stroke-width",
    "stroke-opacity", "stroke-linejoin", "stroke-linecap",
    "stroke-dasharray", "opacity", "transform", "class",
    "clip-path", "mask", "filter",
}

CSS_RULES = []  # (selector, source_order, {prop: value})
OFFSET = (0.0, 0.0)  # global nudge from --offset


class LoadedFont:
    def __init__(self, path, metrics_mode="hhea"):
        self.path = path
        with open(path, "rb") as fh:
            data = fh.read()
        blob = hb.Blob(data)
        face = hb.Face(blob)
        self.hb_font = hb.Font(face)
        self.upem = face.upem
        # be explicit so shaped advances are always in font units
        self.hb_font.scale = (self.upem, self.upem)
        self.tt = TTFont(path, fontNumber=0)
        self.glyph_set = self.tt.getGlyphSet()
        self.glyph_order = self.tt.getGlyphOrder()
        # vertical metrics for dominant-baseline; browsers mostly use hhea
        os2 = self.tt["OS/2"] if "OS/2" in self.tt else None
        hhea = self.tt["hhea"] if "hhea" in self.tt else None
        metrics = {}
        if hhea is not None:
            metrics["hhea"] = (hhea.ascent, hhea.descent)
        if os2 is not None:
            if getattr(os2, "sTypoAscender", 0):
                metrics["typo"] = (os2.sTypoAscender, os2.sTypoDescender)
            metrics["win"] = (os2.usWinAscent, -os2.usWinDescent)
        for mode in (metrics_mode, "hhea", "typo", "win"):
            if mode in metrics:
                self.ascender, self.descender = metrics[mode]
                break
        else:
            self.ascender = int(self.upem * 0.8)
            self.descender = -int(self.upem * 0.2)
        self.x_height = getattr(os2, "sxHeight", 0) if os2 is not None else 0

    def glyph_name(self, gid):
        return self.glyph_order[gid] if gid < len(self.glyph_order) else ".notdef"


def parse_font_args(specs, metrics_mode):
    mapping = {}
    for spec in specs:
        if "=" not in spec:
            sys.exit(f"error: bad --font spec {spec!r}, expected 'Family[:variant]=/path/font.ttf'")
        key, path = spec.split("=", 1)
        mapping[key.strip().lower()] = LoadedFont(path.strip(), metrics_mode)
    return mapping


# ---------------------------------------------------------------- CSS

def load_stylesheets(root):
    order = 0
    for style_el in root.iter(f"{{{SVG_NS}}}style"):
        css = re.sub(r"/\*.*?\*/", "", style_el.text or "", flags=re.S)
        for sel_group, body in re.findall(r"([^{}]+)\{([^}]*)\}", css):
            decls = {}
            for d in body.split(";"):
                if ":" in d:
                    k, v = d.split(":", 1)
                    decls[k.strip().lower()] = v.replace("!important", "").strip()
            if not decls:
                continue
            for sel in sel_group.split(","):
                sel = sel.strip()
                if not sel:
                    continue
                if re.search(r"[\s>+~:\[]", sel):
                    print(f"warning: CSS selector {sel!r} too complex, ignored", file=sys.stderr)
                    continue
                CSS_RULES.append((sel, order, decls))
                order += 1


def css_specificity(sel, tag, classes, el_id):
    """None if no match, else specificity score."""
    m = re.match(r"^([A-Za-z*][\w-]*)?((?:[.#][\w-]+)*)$", sel)
    if not m:
        return None
    t, rest = m.group(1), m.group(2) or ""
    spec = 0
    if t and t != "*":
        if t != tag:
            return None
        spec += 1
    for piece in re.findall(r"[.#][\w-]+", rest):
        if piece[0] == ".":
            if piece[1:] not in classes:
                return None
            spec += 10
        else:
            if piece[1:] != el_id:
                return None
            spec += 100
    return spec


def parse_style(el):
    """Cascade: presentation attributes < <style> CSS rules < inline style=."""
    tag = el.tag.split("}")[-1]
    classes = (el.get("class") or "").split()
    el_id = el.get("id") or ""
    props = {}
    for k, v in el.attrib.items():
        k = k.split("}")[-1]
        if k in FONT_PROPS or k in COPY_PROPS:
            props[k] = v.strip()
    matched = []
    for sel, order, decls in CSS_RULES:
        spec = css_specificity(sel, tag, classes, el_id)
        if spec is not None:
            matched.append((spec, order, decls))
    for _, _, decls in sorted(matched, key=lambda t: (t[0], t[1])):
        props.update(decls)
    for decl in el.get("style", "").split(";"):
        if ":" in decl:
            k, v = decl.split(":", 1)
            props[k.strip().lower()] = v.replace("!important", "").strip()
    return props


def merge(parent, child):
    out = dict(parent)
    out.update(child)
    return out


# ---------------------------------------------------------------- fonts

def variant_key(props):
    italic = props.get("font-style", "").lower() in ("italic", "oblique")
    weight = props.get("font-weight", "400").lower()
    bold = weight in ("bold", "bolder") or (weight.isdigit() and int(weight) >= 600)
    if bold and italic:
        return "bold-italic"
    if bold:
        return "bold"
    if italic:
        return "italic"
    return None


def resolve_font(props, fonts):
    families = [f.strip().strip("'\"") for f in props.get("font-family", "").split(",") if f.strip()]
    if not families:
        sys.exit("error: text has no font-family (inline, attribute, or CSS)")
    var = variant_key(props)
    tried = []
    for fam in families:
        fam_l = fam.lower()
        for key in ([f"{fam_l}:{var}"] if var else []) + [fam_l]:
            tried.append(key)
            if key in fonts:
                return fonts[key]
    sys.exit(
        "error: no TTF supplied for font-family "
        f"{props.get('font-family')!r} (variant: {var or 'regular'}).\n"
        f"       looked for keys: {', '.join(tried)}\n"
        "       add e.g. --font \"" + families[0] + (f":{var}" if var else "") + "=/path/to/font.ttf\""
    )


# ---------------------------------------------------------------- geometry

def parse_length(value, default=0.0):
    if value is None:
        return default
    m = re.match(r"^\s*(-?[\d.]+)\s*(px|pt)?\s*$", value)
    if not m:
        sys.exit(f"error: unsupported length {value!r} (only unitless, px, pt supported)")
    n = float(m.group(1))
    if m.group(2) == "pt":
        n *= 96.0 / 72.0
    return n


def baseline_shift(props, font, size):
    """Vertical offset (SVG y-down) from the given y to the alphabetic baseline."""
    db = (props.get("dominant-baseline") or props.get("alignment-baseline") or "alphabetic")
    db = db.strip().lower()
    if db in ("alphabetic", "auto", "baseline", "text-bottom-legacy"):
        return 0.0
    s = size / font.upem
    asc, desc = font.ascender, font.descender  # desc is negative
    if db == "central":
        return (asc + desc) / 2.0 * s
    if db == "middle":
        xh = font.x_height or 0
        return (xh / 2.0 if xh else (asc + desc) / 2.0) * s
    if db in ("text-top", "hanging", "text-before-edge"):
        return asc * s
    if db in ("text-bottom", "ideographic", "text-after-edge"):
        return desc * s
    print(f"warning: dominant-baseline {db!r} unsupported, using alphabetic", file=sys.stderr)
    return 0.0


def shape_run(text, font, size, letter_spacing):
    buf = hb.Buffer()
    buf.add_str(text)
    buf.guess_segment_properties()
    hb.shape(font.hb_font, buf)
    s = size / font.upem
    parts = []
    pen_x = 0.0
    n = len(buf.glyph_infos)
    for i, (info, pos) in enumerate(zip(buf.glyph_infos, buf.glyph_positions)):
        gid = info.codepoint
        if gid == 0:
            ch = text[info.cluster] if info.cluster < len(text) else "?"
            print(f"warning: glyph for {ch!r} missing in {font.path}", file=sys.stderr)
        name = font.glyph_name(gid)
        gx = pen_x + pos.x_offset * s
        gy = -pos.y_offset * s
        spen = SVGPathPen(font.glyph_set)
        tpen = TransformPen(spen, Transform(s, 0, 0, -s, gx, gy))
        font.glyph_set[name].draw(tpen)
        d = spen.getCommands()
        if d:
            parts.append(d)
        pen_x += pos.x_advance * s + letter_spacing
    return " ".join(parts), pen_x


def anchor_offset(props, advance):
    a = props.get("text-anchor", "start")
    if a == "middle":
        return -advance / 2
    if a == "end":
        return -advance
    return 0.0


# ---------------------------------------------------------------- conversion

def convert_text_element(text_el, inherited, fonts, out_parent):
    props = merge(inherited, parse_style(text_el))
    g = ET.SubElement(out_parent, f"{{{SVG_NS}}}g")
    for k in COPY_PROPS:
        if k in props and k != "transform":
            g.set(k, props[k])
    if "transform" in text_el.attrib:
        g.set("transform", text_el.get("transform"))
    if "id" in text_el.attrib:
        g.set("id", text_el.get("id"))

    cur_x = parse_length(text_el.get("x"), 0.0)
    cur_y = parse_length(text_el.get("y"), 0.0)

    def emit(txt, run_props, x, y):
        if not txt:
            return 0.0
        font = resolve_font(run_props, fonts)
        size = parse_length(run_props.get("font-size", "16"), 16.0)
        lsp = parse_length(run_props.get("letter-spacing", "0"), 0.0)
        d, adv = shape_run(txt, font, size, lsp)
        ox = x + anchor_offset(run_props, adv) + OFFSET[0]
        oy = y + baseline_shift(run_props, font, size) + OFFSET[1]
        if d:
            p = ET.SubElement(g, f"{{{SVG_NS}}}path")
            p.set("d", d)
            p.set("transform", f"translate({ox:g},{oy:g})")
        return adv

    # Collect runs first so whitespace can be handled like browsers do:
    # collapse internal runs of whitespace, strip it at the very start/end.
    segs = []
    if text_el.text is not None:
        segs.append({"raw": text_el.text, "props": props, "x": None, "y": None})
    for child in list(text_el):
        tag = child.tag.split("}")[-1]
        if tag != "tspan":
            print(f"warning: <{tag}> inside <text> not supported, skipped", file=sys.stderr)
            continue
        cprops = merge(props, parse_style(child))
        segs.append({"raw": child.text or "", "props": cprops,
                     "x": child.get("x"), "y": child.get("y")})
        if child.tail is not None:
            segs.append({"raw": child.tail, "props": props, "x": None, "y": None})

    for seg in segs:
        seg["txt"] = re.sub(r"\s+", " ", seg["raw"])
    for seg in segs:                       # trim leading whitespace of the block
        seg["txt"] = seg["txt"].lstrip()
        if seg["txt"]:
            break
    for seg in reversed(segs):             # trim trailing whitespace of the block
        seg["txt"] = seg["txt"].rstrip()
        if seg["txt"]:
            break

    for seg in segs:
        if seg["x"] is not None:
            cur_x = parse_length(seg["x"])
        if seg["y"] is not None:
            cur_y = parse_length(seg["y"])
        cur_x += emit(seg["txt"], seg["props"], cur_x, cur_y)


def walk(el, inherited, fonts):
    props = merge(inherited, parse_style(el))
    for child in list(el):
        tag = child.tag.split("}")[-1]
        if tag == "text":
            idx = list(el).index(child)
            el.remove(child)
            placeholder = ET.Element(f"{{{SVG_NS}}}g")
            el.insert(idx, placeholder)
            convert_text_element(child, props, fonts, placeholder)
            inner = list(placeholder)
            if len(inner) == 1:
                el.remove(placeholder)
                el.insert(idx, inner[0])
        else:
            walk(child, props, fonts)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input")
    ap.add_argument("output")
    ap.add_argument("--font", action="append", default=[], metavar="SPEC",
                    help="'Family[:italic|:bold|:bold-italic]=/path/font.ttf' (repeatable)")
    ap.add_argument("--baseline-metrics", choices=["hhea", "typo", "win"], default="hhea",
                    help="vertical metrics for dominant-baseline (default hhea, matches Chrome)")
    ap.add_argument("--offset", default="0,0", metavar="DX,DY",
                    help="global nudge in px applied to all generated paths")
    args = ap.parse_args()
    if not args.font:
        sys.exit("error: at least one --font is required")

    global OFFSET
    try:
        OFFSET = tuple(float(v) for v in args.offset.split(","))
        assert len(OFFSET) == 2
    except (ValueError, AssertionError):
        sys.exit(f"error: bad --offset {args.offset!r}, expected DX,DY")

    fonts = parse_font_args(args.font, args.baseline_metrics)
    tree = ET.parse(args.input)
    root = tree.getroot()
    load_stylesheets(root)
    walk(root, {}, fonts)
    tree.write(args.output, xml_declaration=True, encoding="UTF-8")
    print(f"wrote {args.output}")


if __name__ == "__main__":
    main()
PYEOF

    echo "building $IMAGE (first run only)..." >&2
    docker build -q -t "$IMAGE" "$ctx" >/dev/null
}

if [ "${SVG2PATH_REBUILD:-0}" = "1" ] || ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    build_image
fi

exec docker run --rm -v "$PWD":/work "$IMAGE" "$@"
