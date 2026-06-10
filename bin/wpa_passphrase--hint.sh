#!/usr/bin/env bash

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
#: MY_UID=$(id -u)
#: if [ $MY_UID != 0 ]; then
#:   # $* is a single string, whereas $@ is an actual array.
#:   echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
#: fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

cat <<HERE

wpa_passphrase "Your_Wi-Fi_SSID" "Your_Cleartext_Password" 
wpa_passphrase "Your_Wi-Fi_SSID" "Your_Cleartext_Password" > /etc/wpa_supplicant/wpa_supplicant.conf

HERE

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

