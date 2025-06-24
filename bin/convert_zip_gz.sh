#!/bin/bash
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`
#echo "# now cd'ing (change dir) to:"
#cd $SCRIPT_PATH
#pwd
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
#
# > sudo apt install unzip bzip2
#
FILE="$1"
[ ! -f "$FILE" ] && echo "# Error: cannot read file '$FILE' !" && exit 1
#
unzip -p $FILE | bzip2 > ${FILE}.gz
#
exit 0
#
#-eof
