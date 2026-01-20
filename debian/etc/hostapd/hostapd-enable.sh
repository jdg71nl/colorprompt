#!/bin/bash

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
MY_UID=$(id -u)
if [ $MY_UID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

NAME="hostapd@wlan0"

for NAME in \
  "hostapd@wlan0" \
  "hostapd@wlan1" \
  ; \
do
  echo "# processing: $NAME ..."
  set -x

  systemctl enable --now $NAME
  service $NAME start

  #service $NAME stop
  #systemctl disable --now $NAME

done

#-eof

