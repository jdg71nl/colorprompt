#!/usr/bin/env bash
# svg2png.sh — convert an SVG to PNG, sized 10x the SVG viewBox, opaque white background.

# d260725 inspri from: https://claude.ai/chat/c50edabd-0dc0-4d66-84a2-eb7bac2164eb

# Usage: ./svg2png.sh input.svg [output.png]
set -euo pipefail

# magic_number
SCALE=10

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <square|circle> input.svg [output.png]" >&2
    exit 1
fi

format="${1:-"none"}"
case "$format" in
    square|circle) shift ;;
    *) format="ori" ;;
esac
# same (above is idiomatic bash) ==> [[ "$format" == "square" || "$format" == "circle" ]] && shift
#
in="$1"
out="${2:-"${in%.svg}-${format}.png"}"

[[ -f "$in" ]] || { echo "Error: file not found: $in" >&2; exit 1; }

# Extract the viewBox attribute (e.g. viewBox="0 0 240 100")
viewbox=$(grep -oE 'viewBox="[^"]+"' "$in" | head -n1 | sed -E 's/viewBox="([^"]+)"/\1/')
[[ -n "$viewbox" ]] || { echo "Error: no viewBox found in $in" >&2; exit 1; }

# viewBox = min-x min-y width height  (values may be fractional)
read -r _ _ vb_w vb_h <<< "$viewbox"
px_w=$(awk -v w="$vb_w" -v s="$SCALE" 'BEGIN { printf "%d", w * s }')
px_h=$(awk -v h="$vb_h" -v s="$SCALE" 'BEGIN { printf "%d", h * s }')

echo "# we found: viewBox ${vb_w}x${vb_h} -> so x10 is: ${px_w}x${px_h} px"

box_w=$(awk -v w="$px_w" -v h="$px_h" 'BEGIN { printf "%d", (w > h ? w : h) }')
box_h=$box_w
if [ "$format" == "square" ]; then 
    echo "# we found option 'square -> box: ${box_w}x${box_h} px"
fi
if [ "$format" == "circle" ]; then 
    box_w=$(awk -v w="$box_w" -v h="$box_h" 'BEGIN { printf "%d", w * 1.5 }')
    box_h=$box_w
    echo "# we found option 'circle -> box: ${box_w}x${box_h} px"
fi
# exit 1

if command -v rsvg-convert >/dev/null 2>&1; then
    echo "# we found available on this system: rsvg-convert "
    rsvg-convert -w "$px_w" -h "$px_h" --background-color=white -o "$out" "$in"
elif command -v inkscape >/dev/null 2>&1; then
    echo "# we found NOT available on this system: rsvg-convert (to install: apt install librsvg2-bin or brew install librsvg) -- moving on ..."
    echo "# we found available on this system: inkscape "
    inkscape "$in" --export-type=png --export-filename="$out" \
        -w "$px_w" -h "$px_h" --export-background=white --export-background-opacity=1
elif command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1; then
    echo "# we found NOT available on this system: rsvg-convert (to install: apt install librsvg2-bin or brew install librsvg) -- moving on ..."
    echo "# we found NOT available on this system: magick -- moving on ..."
    echo "# we found available on this system: inkscape "
    cmd=$(command -v magick || command -v convert)
    "$cmd" -background white -size "${px_w}x${px_h}" "$in" \
        -resize "${px_w}x${px_h}!" -flatten "$out"
else
    echo "Error: need rsvg-convert, inkscape, or ImageMagick installed. (of which is best: rsvg-convert) " >&2
    echo "  Debian: apt install librsvg2-bin " >&2
    echo "  MacOS:  brew install librsvg     " >&2
    exit 1
fi

echo "Wrote $out"

if [[ "$format" == "square" || "$format" == "circle" ]]; then
    if command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1; then
        cmd2=$(command -v magick || command -v convert)
        echo "# compositing ${px_w}x${px_h} PNG onto ${box_w}x${box_h} white canvas, centered, unresized"
        "$cmd2" "$out" -background white -gravity center -extent "${box_w}x${box_h}" "$out"
    else
        echo "Error: need ImageMagick (magick or convert) installed to composite onto a '$format' canvas." >&2
        echo "  Debian: apt install imagemagick" >&2
        echo "  MacOS:  brew install imagemagick" >&2
        exit 1
    fi
    echo "Wrote $out (${box_w}x${box_h}, centered)"
fi

# - - - 

#: 
# # Q:
# in this script svg2png.sh what does each of these tools actually do, and why can't it be done in 1 tool:
# - rsvg-convert
# - inkscape
# - magick
#
# # A:
# This script isn't using all three tools together — it's a fallback chain: it tries rsvg-convert first, then inkscape, then magick/convert, using whichever one is actually installed on the machine. Only one of them runs on any given invocation.
# 
# Here's what each one does and why it's in the list:
# 
# rsvg-convert — a tiny, fast SVG-only rasterizer from the librsvg project (GNOME's SVG renderer). It reads SVG and writes PNG (or PDF), full stop. It's lightweight, scriptable, and usually the first choice for headless/CI use because it's a single small binary with few dependencies — but you have to apt install librsvg2-bin or brew install librsvg to get it; it's not preinstalled on macOS.
# 
# inkscape — a full vector-graphics application (like an open-source Illustrator) that happens to expose a CLI/headless export mode. It has its own, more complete SVG rendering engine (better filter/text/gradient support in some edge cases than librsvg), but it's a much heavier install — a whole GUI app with its own dependency stack — and slower to spin up because it boots the app internals even in headless mode.
# 
# magick (ImageMagick, or the older convert) — a general-purpose raster image toolkit. It does not have its own real SVG renderer; under the hood it delegates SVG parsing to a "delegate" library (usually librsvg itself, or sometimes Ghostscript), then does raster operations (resize, flatten alpha onto white, format conversion) on the result. That's why the script still passes -resize and -flatten — ImageMagick's SVG-to-raster fidelity is generally the weakest of the three, but it's extremely commonly preinstalled, so it's the last-resort fallback.
# 
# Why not just pick one tool?
# 
# Portability across machines/OSes. The three have non-overlapping availability: rsvg-convert is common on Linux/Homebrew but absent by default on macOS; inkscape is a large opt-in install; ImageMagick is very often already present (many devs have it for unrelated tasks). Checking command -v for each lets the script "just work" wherever it's run without forcing a specific dependency.
# They're not interchangeable in quality, so the script prefers the best available renderer rather than defaulting to the worst-but-most-common one (ImageMagick).
# No single tool is guaranteed both present and best. rsvg-convert is fast/precise but not preinstalled; Inkscape is thorough but heavy; ImageMagick is ubiquitous but a weaker SVG renderer. The if/elif chain picks whichever best option exists rather than requiring the user to install a specific one.
# So it's not "3 tools doing 3 different jobs in concert" — it's "1 job (SVG→PNG at 10x scale, white background), 3 possible tools to do it, pick the best one that's installed."
#. 

