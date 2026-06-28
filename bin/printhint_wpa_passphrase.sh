#!/usr/bin/env bash
#= printhint_wpa_passphrase.sh

cat <<HERE

wpa_passphrase "Your_Wi-Fi_SSID" "Your_Cleartext_Password" 
wpa_passphrase "Your_Wi-Fi_SSID" "Your_Cleartext_Password" > /etc/wpa_supplicant/wpa_supplicant.conf

HERE

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

