#!/usr/bin/env bash
# ^^ better than: #!/bin/bash
#= bash-echo-args.sh

# - - - - - - = = = - - - - - - . 

BASENAME=$(basename $0)
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

DATE_TAG=$(date +d%y%m%dt%H%M%S)

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

#FILE="$BASENAME"
FILE="$SCRIPT"

DIR_NAME=$(  echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\1/g" )
[ "$DIR_NAME" == "$FILE" ] && DIR_NAME="."
FILE_NAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\2/g" )
BASE_NAME=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\1/g" )
EXTENSION=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\2/g" )

FILE_exploded="[$DIR_NAME] / [$BASE_NAME] . [$EXTENSION]"

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

#echo "# $DATE_TAG [DIR_NAME]/[BASE_NAME].[EXTENSION] => $FILE_exploded -- args: $@ "

echo "# $DATE_TAG $SCRIPT => $FILE_exploded -- Args: $@ "

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

