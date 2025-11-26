#!/usr/bin/env bash
#= prepend-datetag-to-file.sh

#TAG=$(date +d%y%m%dt%H%M%Sz%Z%z)
#echo "# TAG = $TAG "

FILE="$1"

[ ! -f "$FILE" ] && echo "# Error: file '$FILE' not found." && exit 1

# - - - .
# from: Drop_File_Modtime_to_Name.sh
DIR_NAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\1/g" )
FILE_NAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\2/g" )
BASE_NAME=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\1/g" )
EXTENSION=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\2/g" )
#
#FILE_exploded="[$DIR_NAME] / [$BASE_NAME] . [$EXTENSION]"
#echo "# FILE_exploded [DIR_NAME] / [BASE_NAME] . [EXTENSION] => $FILE_exploded "
# echo "# DIR_NAME ='$DIR_NAME' "
# echo "# FILE_NAME='$FILE_NAME' "
# echo "# BASE_NAME='$BASE_NAME' "
# echo "# EXTENSION='$EXTENSION' "
# - - - .

#MOD_TIME=$(date -r "$FILE" +d%y%m%dt%H%M%S)
MOD_TIME=$(date -r "$FILE" +d%y%m%dt%H%M%Sz%Z)
NEW_NAME="$MOD_TIME-$BASE_NAME"
#
FILE_NEW="$DIR_NAME/$NEW_NAME.$EXTENSION"

if [ -f "$FILE_NEW" ]; then
  FILE_NEW="$DIR_NAME/${NEW_NAME}__now.$EXTENSION"
fi

mv "$FILE" "$FILE_NEW"

#-eof

