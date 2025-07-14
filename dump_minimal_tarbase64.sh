#!/bin/bash
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
#SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' :
SCRIPT=`realpath $0`  
SCRIPT_PATH=`dirname $SCRIPT`
#echo "# now cd'ing (change dir) to:"
cd $SCRIPT_PATH
cd ..
#pwd
#

echo "# > tar czf - colorprompt/*.sh colorprompt/bin/ | openssl base64  ..."
echo
tar czf - colorprompt/*.sh colorprompt/bin/ | openssl base64
echo
echo "# extract using: "
echo "# > cat | openssl base64 -d | tar xvzf - "

#
#-eof
