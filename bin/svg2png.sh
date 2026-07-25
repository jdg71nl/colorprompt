#!/usr/bin/env bash
# svg2png.sh — convert an SVG to PNG, sized 10x the SVG viewBox, opaque white background.

# d260725 inspri from: https://claude.ai/chat/c50edabd-0dc0-4d66-84a2-eb7bac2164eb

# Usage: ./svg2png.sh input.svg [output.png]
set -euo pipefail

SCALE=10

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 input.svg [output.png]" >&2
    exit 1
fi

in="$1"
out="${2:-${in%.svg}.png}"

[[ -f "$in" ]] || { echo "Error: file not found: $in" >&2; exit 1; }

# Extract the viewBox attribute (e.g. viewBox="0 0 240 100")
viewbox=$(grep -oE 'viewBox="[^"]+"' "$in" | head -n1 | sed -E 's/viewBox="([^"]+)"/\1/')
[[ -n "$viewbox" ]] || { echo "Error: no viewBox found in $in" >&2; exit 1; }

# viewBox = min-x min-y width height  (values may be fractional)
read -r _ _ vb_w vb_h <<< "$viewbox"
px_w=$(awk -v w="$vb_w" -v s="$SCALE" 'BEGIN { printf "%d", w * s }')
px_h=$(awk -v h="$vb_h" -v s="$SCALE" 'BEGIN { printf "%d", h * s }')

echo "viewBox ${vb_w}x${vb_h} -> ${px_w}x${px_h} px"

if command -v rsvg-convert >/dev/null 2>&1; then
    rsvg-convert -w "$px_w" -h "$px_h" --background-color=white -o "$out" "$in"
elif command -v inkscape >/dev/null 2>&1; then
    inkscape "$in" --export-type=png --export-filename="$out" \
        -w "$px_w" -h "$px_h" --export-background=white --export-background-opacity=1
elif command -v magick >/dev/null 2>&1 || command -v convert >/dev/null 2>&1; then
    cmd=$(command -v magick || command -v convert)
    "$cmd" -background white -size "${px_w}x${px_h}" "$in" \
        -resize "${px_w}x${px_h}!" -flatten "$out"
else
    echo "Error: need rsvg-convert, inkscape, or ImageMagick installed." >&2
    echo "  Debian: apt install librsvg2-bin" >&2
    exit 1
fi

echo "Wrote $out"
