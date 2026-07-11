#!/bin/bash
#= ffmpeg_remove_audio_mp4.sh 

# d260710 Claude says: about how to remove audio track in MP4 file:
#
# > ffmpeg -i input.mp4 -c:v copy -an output.mp4
# What the flags do: -c:v copy copies the video stream as-is (no re-encoding, so it's fast and lossless), and -an drops all audio streams.
#
# > ffmpeg -i input.mp4 -map 0 -map -0:a -c copy output.mp4
# If the file also has subtitle or data tracks you want to keep, use this instead:
# Here -map 0 selects all streams, -map -0:a removes the audio ones, and -c copy avoids re-encoding anything.

FILE="$1"

#: - - - - - - = = = - - - - - - . 
DIR_NAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\1/g" )
[ "$DIR_NAME" == "$FILE" ] && DIR_NAME=""
FILE_NAME=$( echo "$FILE" | /usr/bin/perl -pe "s/^(.*)\/([^\/]+)$/\2/g" )
BASE_NAME=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\1/g" )
EXTENSION=$( echo "$FILE_NAME" | /usr/bin/perl -pe "s/^(.*)\.([^\.]+)$/\2/g" )
#
#echo "# DIR_NAME ='$DIR_NAME' "
#echo "# FILE_NAME='$FILE_NAME' "
#echo "# BASE_NAME='$BASE_NAME' "
#echo "# EXTENSION='$EXTENSION' "
#
#FILE_exploded="[$DIR_NAME] / [$BASE_NAME] . [$EXTENSION]"
#echo "# FILE_exploded [DIR_NAME] / [BASE_NAME] . [EXTENSION] => $FILE_exploded "
#
EXT_LOWER="$(printf '%s' "$EXTENSION" | tr '[:upper:]' '[:lower:]')"
#echo "# EXT_LOWER='$EXT_LOWER' "
#. - - - - - - = = = - - - - - - . 

# d260710 Claude says: about comparing stringd case-insensitive:
# [[ "${EXTENSION,,}" == "mp4" ]]       # 1. (bash 4+) ${EXTENSION,,} expands the variable in all-lowercase
# case "$EXTENSION" in                  # 2. (POSIX)   
#     [Mm][Pp]4) echo "it's mp4" ;;
# esac
# shopt -s nocasematch                  # 3. bash common way
# if [[ "$EXTENSION" == "mp4" ]]; then
#     echo "it's mp4"
# fi
# shopt -u nocasematch
# [ "$(printf '%s' "$EXTENSION" | tr '[:upper:]' '[:lower:]')" = "mp4" ]   # 4. best for ash (Alpine Linux)

OUT_FILE="$FILE.no-audio.mp4"

[ ! -f "$FILE" ]          && echo "# Error: file '$FILE' not found."          && exit 1
[ "$EXT_LOWER" != "mp4" ] && echo "# Error: file '$FILE' is not a MP4 file."  && exit 1
[ -f "$OUT_FILE" ]        && echo "# Error: file '$OUT_FILE' already exists." && exit 1

#exit 1

set -x

ffmpeg -i "$FILE" -map 0 -map -0:a -c copy "$OUT_FILE"

#-eof


