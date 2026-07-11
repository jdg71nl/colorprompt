#!/bin/bash
#= convert_multiline_to_line_skip_comments.sh

cat | egrep -v "^#" | perl -pe "s/\s+/ /"

