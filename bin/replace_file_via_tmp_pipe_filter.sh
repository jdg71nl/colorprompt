#!/usr/bin/env bash
#= replace_file_via_tmp_pipe_filter.sh
# John@de-Graaff.net

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# function f_realpath() {
#   [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
#   # note: the ${parameter#word} pattern is explained in man page: https://man7.org/linux/man-pages/man1/bash.1.html
# }
# SCRIPT="$(f_realpath $0)"
#
# ARG_0="$0"
# echo "# \$0 = $0 "
BASENAME=$(basename $0)
echo "# running: $BASENAME ... "
# SCRIPT=$(realpath -s $0)  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' ...
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)
# echo "# now changing-dir to:"
# cd $SCRIPT_PATH
# pwd

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# MY_UID=$(id -u)
# if [ $MY_UID != 0 ]; then
#   # $* is a single string, whereas $@ is an actual array.
#   echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
# fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
usage() {
  #echo "# usage: $BASENAME < req.flag > [ -opt.flag string ] "
  echo "# usage: $BASENAME <file> { <filter_commands> ... } " 
  exit 1
}
if [[ $# < 2 ]]; then
  usage
fi

# FILE="${1#./}" # trim any prefix './'
FILE="$1"
shift
FILTER="$@"

[ ! -f "$FILE" ] && echo "# Error: file '$FILE' does not exist!" && exit 1
[ ! -w "$FILE" ] && echo "# Error: file '$FILE' is not writable (by you) !" && exit 1

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
TMP_DIR="$(mktemp -d)"
# echo "# Using temp_dir: $TMP_DIR"

function f_cleanup() {
  #echo "# Cleaning up"
  rm -rf $TMP_DIR
  #echo "# Done"
}
trap f_cleanup INT TERM EXIT
# > help set
# says:
# set -e   "Exit immediately if a command exits with a non-zero status."
set -e

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

TMP_FILE=$(basename $FILE)
TMP_PATH="$TMP_DIR/$TMP_FILE"

echo "# > cat $FILE | $FILTER > $TMP_PATH"
cat $FILE | $FILTER > $TMP_PATH

echo "# > cat $TMP_PATH > $FILE"
cat $TMP_PATH > $FILE

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

