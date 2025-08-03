#!/usr/bin/env bash
# ^^^ better than: #!/bin/bash

BASENAME=$(basename $0)
echo "# running: $BASENAME ... "
# SCRIPT=$(realpath -s $0)  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' ...
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
usage() {
  echo "# usage: $BASENAME <cert-file> <privkey-file>"
  exit 1
}
if [[ $# < 2 ]]; then
  usage
fi


CERT="$1"
PRIV="$2"

# https://nuxx.net/blog/2023/10/19/using-openssl-to-match-certificates-and-private-keys/

echo
echo "# manually check that the Modulus matches: ... "

echo "# > openssl x509 -in "$CERT" -noout -text"
openssl x509 -in "$CERT" -noout -text

echo

echo "# > openssl rsa -in "$PRIV" -noout -text"
openssl rsa -in "$PRIV" -noout -text


# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

