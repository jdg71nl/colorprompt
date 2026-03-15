#!/usr/bin/env bash
#= prepend-datetag-to-file.sh

FILE="$1"

[ ! -f "$FILE" ] && echo "# Info: file '$FILE' not found."
[ -f "$FILE" ]   && echo "# Info: file '$FILE' is found."

#:
DIR_NAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\1/g" )
[ "$DIR_NAME" == "$FILE" ] && DIR_NAME=""
FILE_NAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\2/g" )
BASE_NAME=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\1/g" )
EXTENSION=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\2/g" )
#
echo "# DIR_NAME ='$DIR_NAME' "
echo "# FILE_NAME='$FILE_NAME' "
echo "# BASE_NAME='$BASE_NAME' "
echo "# EXTENSION='$EXTENSION' "
#
FILE_exploded="[$DIR_NAME] / [$BASE_NAME] . [$EXTENSION]"
echo "# FILE_exploded [DIR_NAME] / [BASE_NAME] . [EXTENSION] => $FILE_exploded "
# - - - .

#-eof

