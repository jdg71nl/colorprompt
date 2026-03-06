#!/bin/bash
#= pic_exif_time_2_modtime_this_dir.sh

# install on MacOS:
# > brew install exiftool

set -x
exiftool '-DateTimeOriginal>FileModifyDate' .

#-eof

