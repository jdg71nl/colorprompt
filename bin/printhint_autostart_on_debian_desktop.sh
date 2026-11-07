#!/bin/bash
#= printhint_autostart_on_debian_desktop.sh 

cat <<EOF

--[CWD=~]--[1794053855 13:17:35 Sat 07-Nov-2026 CET]--[jdg@debpi-j33rtr]--[hw:RPI5b-1.0/4G,os:Debian-13/trixie,isa:aarch64]------
> cat .config/labwc/autostart 
#= /home/jdg/.config/labwc/autostart
# -- info:
# jdg: https://claude.ai/chat/7b5f0ee6-8b49-4b06-a177-521201d64f04
# -- research:
# first check which Desktop Manager is used on this host:
# > ps -e | grep -E "wayfire|labwc|lxsession|openbox"
#    1074 ?        00:00:00 labwc
# below file is for: labwc (d260625 deb13 on rpi5b)
# -- prep:
# > sudo apt install firefox unclutter
# > mkdir -p ~/.config/labwc
# > touch    ~/.config/labwc/autostart
# > chmod +x ~/.config/labwc/autostart
# -- run:
sleep 2
unclutter -idle 0.5 &
firefox --kiosk http://127.0.0.1:8084 &
#-eof

EOF

#-EOF

