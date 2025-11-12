#!/bin/bash
#= setup_kiosk_mode__getty_chromium.sh 

BASENAME=$(basename $0)
echo "# running: $BASENAME ... "
# SCRIPT=$(realpath -s $0)  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' ...
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)
# echo "# now changing-dir to:"
# cd $SCRIPT_PATH

#set -x
#set -e

#
sudo apt update
sudo apt install -y xserver-xorg x11-xserver-utils xinit matchbox-window-manager chromium unclutter

#
sudo mkdir -pv /etc/systemd/system/getty@tty1.service.d/
#sudo cp -av /home/dcs/prod/dcs-mcs-client/fsroot/etc/systemd/system/getty@tty1.service.d/override.conf /etc/systemd/system/getty@tty1.service.d/
USER=$(whoami)
cat >/etc/systemd/system/getty@tty1.service.d/override.conf <<HERE
#= /etc/systemd/system/getty@tty1.service.d/override.conf
# d251005-jdg inspri: https://tech-couch.com/post/configure-linux-debian-to-boot-into-a-fullscreen-application
# NOTE: this first "empty-line" "ExecStart=" needs to stay there to redefine it.
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER --noclear %I linux
#-eof
HERE

#
cat >$HOME/.kiosk-url.txt <<HERE
http://127.0.0.1:1080/web/#/display
HERE
echo "# NOTE: we have written a default URL in file '$HOME/.kiosk-url.txt' -- You may want to write your own !! "

#
#cp -av /home/dcs/prod/dcs-mcs-client/fsroot/home/dcs/.xinitrc /home/dcs/
cat >$HOME/.xinitrc <<HERE
#= \$HOME/.xinitrc
# d251005-jdg inspri: https://tech-couch.com/post/configure-linux-debian-to-boot-into-a-fullscreen-application

xset s off
xset -dpms
xset s noblank

# matchbox-window-manager &
matchbox-window-manager -use_titlebar no -use_cursor no &

# https://www.scalzotto.nl/posts/raspberry-pi-kiosk/
# Hide the mouse cursor.
unclutter -idle 1 -root &

# chromium --kiosk https://tech-couch.com
# chromium-browser --kiosk --noerrdialogs --disable-infobars http://127.0.0.1:1080/web/#/display
# chromium --kiosk --no-first-run --incognito --noerrdialogs --disable-infobars http://127.0.0.1:1080/web/#/display
KIOSK_URL=\$(cat \$HOME/.kiosk-url.txt)
chromium --kiosk --no-first-run --incognito --noerrdialogs --disable-infobars \$KIOSK_URL

#-eof
HERE

#
#cp -av /home/dcs/prod/dcs-mcs-client/fsroot/home/dcs/.bashrc.startx /home/dcs/
cat >$HOME/.bashrc.startx  <<HERE
#= \$HOME/.bashrc.startx
# d251005-jdg inspir: https://tech-couch.com/post/configure-linux-debian-to-boot-into-a-fullscreen-application
if [ -z "\$DISPLAY" ] && [ "\$(tty)" = "/dev/tty1" ]; then
  startx
fi
#-eof
HERE

#
grep -q bashrc.startx ~/.bashrc || echo -e "\n# inserted by setup_kiosk_mode__getty_chromium.sh: \n[ -f ~/.bashrc.startx ] && source ~/.bashrc.startx \n" >> ~/.bashrc

#
grep startx /etc/rc.local >/dev/null 2>&1 && echo "# WARNING: we detected a reference to 'startx' in '/etc/rc.local' -- please REMOVE this !! "

#-eof

