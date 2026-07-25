#!/usr/bin/env bash
#= 
# - - - - - - = = = - - - - - - . 
GLOB="$1"
[ -z "$GLOB" ] && GLOB="*"

#for x in *.git; do echo "# ORI: $x " ; LOW=$(echo $x | tr '[:upper:]' '[:lower:]') ; [ ! "$x" == "$LOW" ] && echo "# ----------- LOW: $LOW" ; done

echo "#: now listing (echo) all files that are not strict-lower-case: "
for FILE in $GLOB; do LOW=$(echo $FILE | tr '[:upper:]' '[:lower:]') ; [ ! "$FILE" == "$LOW" ] && echo "$FILE" ; done
echo "#. done"

# - - - - - - = = = - - - - - - . 
#-eof

