#!/bin/bash
#= file-splice-into-at-marker-some-file-output-file.sh

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# function f_realpath() {
#   [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
# }
# SCRIPT="$(f_realpath $0)"
#
# ARG_0="$0"
# echo "# \$0 = $0 "
BASENAME=$(basename $0)
echo "# running: $BASENAME ... "
# SCRIPT=$(realpath -s $0)  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' ...
#SCRIPT=$(realpath $0)
#SCRIPT_PATH=$(dirname $SCRIPT)
# echo "# now changing-dir to:"
# cd $SCRIPT_PATH
# pwd

echo 

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
usage() {
  echo "# usage: $BASENAME <base_file> <marker> <insert_file> <output_file> "
  #echo "# usage: $BASENAME " 
  exit 1
}
if [[ $# < 4 ]]; then
  usage
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

BASE_FILE="$1"
MARKER="$2"
INSERT_FILE="$3"
OUTPUT_FILE="$4"

[ ! -r "$BASE_FILE" ] && echo "# Error: file '$BASE_FILE' not readable!" && exit 1
[ ! -r "$INSERT_FILE" ] && echo "# Error: file '$INSERT_FILE' not readable!" && exit 1
[ -f "$OUTPUT_FILE" ] && echo "# Warning: file '$OUTPUT_FILE' already exists. Press <enter> to overwrite, ctrl-c to cancel." && read
echo "# let's go ..."

# awk 'NR==FNR {if ($1 == "insertkey") while((getline a<ARGV[2]) > 0) print a; else print}' john.de.graaff-ububook.ovpn.base john.de.graaff-ububook.bare-key > john.de.graaff-ububook.ovpn

echo -n '# > '
echo awk 'NR==FNR {if ($1 == "'$MARKER'") while((getline a<ARGV[2]) > 0) print a; else print}' $BASE_FILE $INSERT_FILE \> $OUTPUT_FILE

awk 'NR==FNR {if ($1 == "'$MARKER'") while((getline a<ARGV[2]) > 0) print a; else print}' $BASE_FILE $INSERT_FILE > $OUTPUT_FILE

#-eof

