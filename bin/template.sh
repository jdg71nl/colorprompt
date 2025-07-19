#!/usr/bin/env bash
# ^^^ better than: #!/bin/bash
#= template.sh | updated: d250719
# John@de-Graaff.net

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# display every line executed in this bash script:
#set -o xtrace
#set -x

# guide:      https://tldp.org/LDP/abs/html/  --  "Advanced Bash-Scripting Guide"
# ideas from: https://gist.github.com/natemcmaster/5e36e3953c586e4b407a7bb9316b8772

# > help test 
# says: 
# -z STRING   True if string is empty.
# -n STRING   True if string is not empty.

# VERBOSE="yes"  # non-empty-string is 'True'  ## usage: [ -n "$VERBOSE" ] && command
# VERBOSE=""     # empty-string is     'False'
VERBOSE="yes"
#
#[ -n "$VERBOSE" ] && echo "# Verbose enabled."
#[ -z "$VERBOSE" ] && echo "# Verbose disabled."

# VERBOSE=1  # integer 1 (not 0) is 'True'  ## usage: [ $VERBOSE -ne 0 ] && command
# VERBOSE=0  # integer 0         is 'False'
VERBOSE=1
#
#[ $VERBOSE -ne 0 ] && echo "# Verbose enabled."
#[ $VERBOSE -eq 0 ] && echo "# Verbose disabled."

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
  echo "# usage: $BASENAME " 
  exit 1
}
if [[ $# < 2 ]]; then
  usage
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
tmp_dir="$(mktemp -d)"
# echo "# Using temp_dir: $tmp_dir"

function f_cleanup() {
  #echo "# Cleaning up"
  rm -rf $tmp_dir
  #echo "# Done"
}
trap f_cleanup INT TERM EXIT
# > help set
# says:
# set -e   "Exit immediately if a command exits with a non-zero status."
set -e

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# my script statements here ...

# run_some_command
# LAST_RC=$?  #  <== Return_Code '0' means 'True'
# if [ $LAST_RC -eq 0 ]; then ... fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

