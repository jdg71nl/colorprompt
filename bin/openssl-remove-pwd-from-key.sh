#!/bin/bash
#= openssl-remove-pwd-from-key.sh

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
usage() {
  echo "# usage: $BASENAME <key-file-with-pwd> <new-key-file-without-pwd> "
  #echo "# usage: $BASENAME " 
  exit 1
}
if [[ $# < 2 ]]; then
  usage
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# inspri: https://www.atlantic.net/vps-hosting/how-to-remove-password-ssl-key/
# 
# -----BEGIN ENCRYPTED PRIVATE KEY-----
# ...
# -----END ENCRYPTED PRIVATE KEY-----
# 
# -----BEGIN PRIVATE KEY-----
# ...
# -----END PRIVATE KEY-----

IN="$1"
OUT="$2"

[ ! -r "$IN" ] && echo "# Error: file '$IN' is not readable!" && exit 1
[ -f "$OUT" ] && echo "# Error: file '$OUT' already exists!" && exit 1

echo "# > openssl rsa -in \"$IN\" -out \"$OUT\" "
openssl rsa -in "$IN" -out "$OUT"


# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

