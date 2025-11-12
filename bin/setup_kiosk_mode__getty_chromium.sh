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

check_apt_update_needed() {
  MAX_AGE_SECONDS=$((24 * 60 * 60))
  LISTS_DIR="/var/lib/apt/lists"
  if [ ! -d "$LISTS_DIR" ]; then
    #echo "# APT lists directory not found. Running apt update."
    return 0 # Update is needed (exit code 0 means TRUE/Success)
  fi

  LAST_UPDATE_TIME=$(stat -c %Y "$LISTS_DIR")

  CURRENT_TIME=$(date +%s)

  AGE_SECONDS=$((CURRENT_TIME - LAST_UPDATE_TIME))

#echo "Last apt update was $AGE_SECONDS seconds ago."

  if [ "$AGE_SECONDS" -ge "$MAX_AGE_SECONDS" ]; then
    #echo "Update is older than $MAX_AGE_SECONDS seconds (24 hours). Running apt update."
    return 0 # Update is needed
  else
    #echo "Update is recent enough. Skipping apt update."
    return 1 # Update is NOT needed (exit code 1 means FALSE/Failure)
  fi
}

#
if check_apt_update_needed; then
  sudo apt update
fi

#
sudo apt install -y xserver-xorg x11-xserver-utils xinit matchbox-window-manager chromium unclutter

#
sudo mkdir -pv /etc/systemd/system/getty@tty1.service.d/
#sudo cp -av /home/dcs/prod/dcs-mcs-client/fsroot/etc/systemd/system/getty@tty1.service.d/override.conf /etc/systemd/system/getty@tty1.service.d/
USER=$(whoami)
#cat >/etc/systemd/system/getty@tty1.service.d/override.conf <<HERE
cat <<HERE | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null
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
sudo rm -f $HOME/.xinitrc
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



