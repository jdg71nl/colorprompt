#!/bin/bash

BASENAME=$(basename $0)
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)
cd $SCRIPT_PATH

FILE="apk_list_base.txt"

#cat $FILE | perl -pe "s/\s+/ /" | xargs sudo apk add
PKG=$(cat $FILE | perl -pe "s/\s+/ /")

echo "# > sudo apk add $PKG  "
sudo apk add $PKG

#-eof

