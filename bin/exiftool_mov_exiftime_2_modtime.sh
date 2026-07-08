#!/bin/bash
#= exiftool_mov_exiftime_2_modtime.sh

# works for both IMAGES as MOVIES (see below)

# https://exiftool.org/
# https://github.com/exiftool/exiftool
# https://github.com/exiftool/exiftool/discussions
# https://exiftool.org/forum/index.php?topic=11776.0
#
# rjames86/My Exiftool Cheatsheet.md
# https://gist.github.com/rjames86/33b9af12548adf091a26

# install on MacOS:
# > brew install exiftool

FILE="$1"
[ ! -f "$FILE" ] && echo "# Error: file '$FILE' not found." && exit 1

set -x

exiftool -api QuickTimeUTC '-CreationDate>FileModifyDate' "$FILE"

#-eof

#: # d260706-jdg: Claude says: MOV has other tags than JPG (CreationDate):
#: > exiftool -time:all -G1 -a -s IMG_5531.MOV
#: [System]        FileModifyDate                  : 2026:07:06 20:44:31+02:00
#: [System]        FileAccessDate                  : 2026:07:06 20:50:47+02:00
#: [System]        FileInodeChangeDate             : 2026:07:06 20:50:53+02:00
#: [QuickTime]     CreateDate                      : 2026:07:06 18:44:05
#: [QuickTime]     ModifyDate                      : 2026:07:06 18:44:31
#: [Track1]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track1]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track1]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track1]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track2]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track2]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track2]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track2]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track3]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track3]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track3]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track3]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track4]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track4]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track4]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track4]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track5]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track5]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track5]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track5]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track6]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track6]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track6]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track6]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track7]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track7]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track7]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track7]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Keys]          CreationDate                    : 2026:07:06 13:17:00+02:00
#: 

