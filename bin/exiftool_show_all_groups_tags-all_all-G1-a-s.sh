#!/bin/bash
#= exiftool_show_all_groups_tags-all_all-G1-a-s.sh 

# works for both IMAGES as MOVIES (see below)

# https://exiftool.org/
# https://github.com/exiftool/exiftool
# https://github.com/exiftool/exiftool/discussions
# https://exiftool.org/forum/index.php?topic=11776.0
#
# rjames86/My Exiftool Cheatsheet.md
# https://gist.github.com/rjames86/33b9af12548adf091a26

# install on MacOS:
# > brew install exiftool

FILE="$1"
[ ! -f "$FILE" ] && echo "# Error: file '$FILE' not found." && exit 1

set -x

exiftool '-all:all' -G1 -a -s "$FILE"

#-eof

