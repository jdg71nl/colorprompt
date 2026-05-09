#!/usr/bin/env bash
# ^^^ better than: #!/bin/bash
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
MY_UID=$(id -u)
if [ $MY_UID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

SDIR="smartback4"
TDIR="/var/local/backup/smartback4"

#BASE="10.25.221.4"
BASE="100.99.25.4"

#HOST="j33rtr"
HOST="j33rtr___d260120"

#mkdir -pv /var/local/backup/smartback4/j33rtr/ 
#rsync -v -rtlz -e "ssh -p 22" smartback4@10.25.221.4:smartback4/j33rtr/ /var/local/backup/smartback4/j33rtr/ 

mkdir -pv $TDIR/$HOST
rsync -v -rtlz -e "ssh -p 22" smartback4@$BASE:$SDIR/$HOST/ $TDIR/$HOST/

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

