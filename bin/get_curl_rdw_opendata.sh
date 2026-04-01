#!/bin/bash

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
BASENAME=$(basename $0)
echo "# running: $BASENAME ... "
# SCRIPT=$(realpath -s $0)  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' ...
#SCRIPT=$(realpath $0)
#SCRIPT_PATH=$(dirname $SCRIPT)
# echo "# now changing-dir to:"
# cd $SCRIPT_PATH
# pwd

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
usage() {
  #echo "# usage: $BASENAME < req.flag > [ -opt.flag string ] "
  echo "# usage: $BASENAME <kenteken-zonder-spaties-in-HOOFDLETTERS> " 
  exit 1
}
if [[ $# < 1 ]]; then
  usage
fi

echo_stderr() { echo "$@" 1>&2; }

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
which curl >/dev/null || (echo "# Error: 'curl' is not installed. exit(1) " && exit 1)
which jq >/dev/null || (echo "# Error: 'jq' is not installed. exit(1) " && exit 1)

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
ARG1=$1
UPPER=$(echo $ARG1 | awk '{ print toupper($0) }')
KENTEKEN=$UPPER

[ -z "$KENTEKEN" ] && usage && exit
[ "$ARG1" != "$UPPER" ] && usage && exit

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

echo "# curl --silent https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=${KENTEKEN} | jq "

curl --silent https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=${KENTEKEN} | jq

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
#-eof

