#!/bin/sh
# LBU = Local Backup Utility -- https://wiki.alpinelinux.org/wiki/Alpine_local_backup
# "lbu commit -d" saves all changes to the (sd/flash) disk
set -x
sudo lbu commit -d -v "$*"
#-eof

