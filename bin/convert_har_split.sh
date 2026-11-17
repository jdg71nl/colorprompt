#!/usr/bin/env python3

# d261117 jdg https://gemini.google.com/app/294b1347f251e2a8#bb1438e42085f592

import json, base64

import argparse
from pathlib import Path

# ORI:
# har_file = 'd261116t224900zCET-embed_rtl_nl_Archive_26-11-16_22-48-56.har'

#: copy from <convert_video_har_mp4.py>
def existing_file(value: str) -> Path:
    path = Path(value)
    if not path.is_file():
        raise argparse.ArgumentTypeError(f"{value!r} is not an existing file")
    return path
# 
parser = argparse.ArgumentParser(description="Process a file.")
parser.add_argument("filename", type=existing_file, help="path to an existing file")
args = parser.parse_args()
# 
# args.filename is a validated Path object
print(f"Reading {args.filename}")
# 
# har_file = 'video.har'
# output_file = 'extracted_video.mp4'
#
har_file = args.filename
#.

with open(har_file, 'r', encoding='utf-8') as f:
    data = json.load(f)

seen_urls = set()
vid_out = open('video_only.mp4', 'wb')
aud_out = open('audio_only.m4a', 'wb')

for entry in data['log']['entries']:
    url = entry['request']['url']
    if url in seen_urls:
        continue
    seen_urls.add(url)
    
    content = entry['response']['content']
    mime = content.get('mimeType', '')
    text = content.get('text')
    
    if not text:
        continue
        
    raw = base64.b64decode(text) if content.get('encoding') == 'base64' else text.encode('utf-8')
    
    if 'video/' in mime:
        vid_out.write(raw)
    elif 'audio/' in mime:
        aud_out.write(raw)

vid_out.close()
aud_out.close()
print("Done. Created video_only.mp4 and audio_only.m4a")

#-eof

# jdg: this specific HAR file shows to be ENCRYPTED:
#
# --[CWD=~/Downloads]--[1794908907 10:48:27 Tue 17-Nov-2026 CET]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7.1,isa:arm64]------
# > ffprobe -hide_banner video_only.mp4
# [h264 @ 0x7fe850380] non-existing PPS 2 referenced
# [h264 @ 0x7fe850380] slice type 32 too large at 0
# [h264 @ 0x7fe850380] no frame!
# [h264 @ 0x7fe850380] slice type 14 too large at 0
# [h264 @ 0x7fe850380] no frame!
# [h264 @ 0x7fe850380] non-existing PPS 62 referenced
#     Last message repeated 1 times
# [h264 @ 0x7fe850380] no frame!
# [h264 @ 0x7fe850380] deblocking_filter_idc 5 out of range
# [h264 @ 0x7fe850380] no frame!
# [h264 @ 0x7fe850380] left block unavailable for requested intra mode
# [h264 @ 0x7fe850380] error while decoding MB 3 0, bytestream 6403
# [h264 @ 0x7fe850380] concealing 8160 DC, 8160 AC, 8160 MV errors in P frame
# [h264 @ 0x7fe850380] reference count 1 overflow
# [h264 @ 0x7fe850380] non-existing PPS 4 referenced
# [h264 @ 0x7fe850380] non-existing PPS 1 referenced
# [h264 @ 0x7fe850380] non-existing PPS 2 referenced
# [h264 @ 0x7fe850380] non-existing PPS 16 referenced
# [h264 @ 0x7fe850380] non-existing PPS 2 referenced
#     Last message repeated 1 times
# [h264 @ 0x7fe850380] reference count 1 overflow
# [h264 @ 0x7fe850380] non-existing PPS 53 referenced
# [h264 @ 0x7fe850380] non-existing PPS 2 referenced
#     Last message repeated 1 times
# [h264 @ 0x7fe850380] non-existing PPS 52 referenced
# Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'video_only.mp4':
#   Metadata:
#     major_brand     : isom
#     minor_version   : 1
#     compatible_brands: isomavc1dash
#     creation_time   : 2026-11-16T21:37:44.000000Z
#   Duration: 00:00:04.04, start: 0.082660, bitrate: 83433 kb/s
#   Stream #0:0[0x1](und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p(progressive), 1920x1080 [SAR 1:1 DAR 16:9], 6800 kb/s, 50 fps, 50 tbr, 50k tbn, start 0.082660 (default)
#     Metadata:
#       creation_time   : 2026-11-16T21:37:44.000000Z
#       handler_name    : ETI ISO Video Media Handler
#       encoder         : Elemental H.264
#     Side data:
#       Encryption initialization data: (54 bytes)
# --[CWD=~/Downloads]--[1794908908 10:48:28 Tue 17-Nov-2026 CET]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7.1,isa:arm64]------
