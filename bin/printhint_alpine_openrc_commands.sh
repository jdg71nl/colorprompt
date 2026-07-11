#!/bin/bash
#= printhint_sed-print-regex-range.sh

cat <<EOF

# https://wiki.alpinelinux.org/wiki/OpenRC

# we have 3 commands:
rc-service
rc-update
rc-status

# typical usage:
rc-service ServiceName start
rc-service ServiceName stop
rc-service ServiceName restart
rc-update add ServiceName runlevel
rc-update del ServiceName runlevel
rc-service ServiceName status
rc-update show runlevel
rc-status
rc-status -l

# 
apk search cmd:lsb_release      # who provides it
apk add    cmd:lsb_release      # install whatever provides it
apk info --who-owns /usr/bin/lsb_release 

EOF

#-eof

