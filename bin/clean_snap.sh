#!/bin/bash
#= clean_snap.sh 

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
MY_UID=$(id -u)
if [ $MY_UID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# guide: https://snapcraft.io/docs/snapshots

# https://askubuntu.com/questions/1075050/how-to-remove-uninstalled-snaps-from-cache
# "You can remove the files in /var/lib/snapd/cache without issue. Also there is no need to stop snapd before."
rm -rf /var/lib/snapd/cache/*

# d250918:
# https://www.debugpoint.com/clean-up-snap/
# > sudo snap set system refresh.retain=2
snap set system refresh.retain=2

# before:
# https://www.debugpoint.com/2021/03/clean-up-snap/
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
if false; then
  set -eu
  LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
    snap remove "$snapname" --revision="$revision"
  done
fi

#-eof

