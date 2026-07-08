#!/bin/bash
#= printhint_ffmpeg-concat-mp4-no-reencode.sh 

cat <<EOF

> for x in Untitled*mp4 ; do echo "file '\$x'"; done > ./ffmpeg_concat_filelist.txt

> cat ./ffmpeg_concat_filelist.txt
file 'Untitled1.mp4'
file 'Untitled2.mp4'
file 'Untitled3.mp4'

ffmpeg -f concat -safe 0 -i ./ffmpeg_concat_filelist.txt -c copy output.mp4

EOF

#-eof

