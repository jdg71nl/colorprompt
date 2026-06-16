#!/bin/bash
#= rpi_rotate_touch_screen.sh
# (c)2023 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
#usage() {
#  #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
# my statements here ...

cat <<HERE

# see: https://www.raspberrypi.com/documentation/accessories/display.html
# see: https://www.raspberrypi.com/documentation/accessories/display.html#with-the-kernel-command-line
# "The rotate= setting only rotates the text-mode console. For applications that write directly to DRM, such as cvlc or the libcamera apps, ..."
# https://en.wikipedia.org/wiki/Direct_Rendering_Manager

# on Debian (v12+ ?):
# Add the following to the end of the file, replacing <rotation-value> with the number of degrees clockwise to rotate by (0, 90, 180, or 270):
> sudo vi /boot/firmware/cmdline.txt
video=DSI-1:800x480@60,rotate=180

# on Alpine (v3.24+ ?):
# create this file (config.txt says to write customizations here):
> sudo vi /boot/usercfg.txt
display_lcd_rotate=2

HERE
#
exit 0
#
#-eof

# https://www.raspberrypi.com/documentation/accessories/display.html
#
#: add this 'word' to: /boot/firmware/cmdline.txt 
# video=DSI-1:800x480@60,rotate=180
# 
# "Rotation of the touchscreen area is independent of the orientation of the display itself."
#: add this line in: /boot/firmware/config.txt
# dtoverlay=vc4-kms-dsi-7inch,invx,invy
#: and COMMENT-OUT this line:
# #display_auto_detect=1

#-eof

