#!/bin/bash
#= jclog.sh -- John Console Logger
# - - - - - - = = = - - - - - - . 

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# emergency: 0,
# alert: 1,
# critical: 2,
# error: 3,
# warning: 4,
# notice: 5,
# informational: 6,
# debug: 7,
#
# emerg__0: 0,
# alert__1: 1,
# critic_2: 2,
# error__3: 3,
# warn___4: 4,
# notice_5: 5,
# info___6: 6,
# debug__7: 7,

BASENAME=`basename $0`
usage() {
  cat <<HERE

# usage: $BASENAME <tag_or_facility> <syslog_level> the rest of this line is the message

- where <tag_or_facility> is a required term with _underscore between words (no spaces)
- where <syslog_level> is one or part of the following (no spaces), like 'info':

emergency_____0
alert_________1
critical______2
error_________3
warning_______4
notice________5
informational_6
debug_________7

It will append a SYSLOG-like text-line to the file: \$HOME/jclog.txt
HERE
}

# https://linuxize.com/post/bash-positional-parameters/
# The "shift" built-in command removes the first positional parameter and shifts all others down by one

TAG="$1" && shift
LEVEL="$1" && shift
MESSAGE="$@"

[ -z "$MESSAGE" ] && usage && exit 0

dSTAMP=$(date +d%y%m%dt%H%M%Sz%Z)
uSTAMP=$(date +%s)

LINE=":jcl- $uSTAMP/$dSTAMP - $TAG - $LEVEL - $MESSAGE -."
# echo "# LINE = '$LINE' "

JCLOG="jclog.txt"

echo "$LINE" >> $HOME/$JCLOG

# - - - - - - = = = - - - - - - . 
#-eof
