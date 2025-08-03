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
  echo "# usage: $BASENAME <dir_name_of_mount> "
  exit 1
}
if [[ $# < 1 ]]; then
  usage
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# my script statements here ...

# run_some_command
# LAST_RC=$?  #  <== Return_Code '0' means 'True'
# if [ $LAST_RC -eq 0 ]; then ... fi

#: --[CWD=~/sshfs]--[1754248381 21:13:01 Sun 03-Aug-2025 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS--15.5,isa:arm64]------
#: > ps aux | grep sshfs | awk '/@.*jwww2.i.j71.nl/ {print}'
#: jdg              26245   0.0  0.0 411018080    544   ??  Ss    8:48PM   0:00.01 sshfs -p 22 -o ServerAliveInterval=30 -o follow_symlinks jdg@jwww2.i.j71.nl:. /Users/jdg/sshfs/jwww2.i.j71.nl
#: 
#: --[CWD=~/sshfs]--[1754248400 21:13:20 Sun 03-Aug-2025 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS--15.5,isa:arm64]------
#: > ps aux | grep sshfs | awk '/@.*jwww2.i.j71.nl/ {print $2}'
#: 26245

DIR="$1"

# inspir: https://stackoverflow.com/questions/18765298/how-to-get-pid-given-the-process-name

echo "# "
echo "# > ps aux | grep sshfs | awk '/@.*$DIR/ {print}' "
ps aux | grep sshfs | awk '/@.*'$DIR'/ {print}'

echo "# "
PID=$(ps aux | grep sshfs | awk '/@.*'$DIR'/ {print $2}')
echo "# we are about to kill this process:"
echo "# > kill $PID "
echo "# "

read -p "Press any key to continue, and ctrl-C to abort ..."
echo "# "

kill $PID

echo "# "
echo "# done."

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

