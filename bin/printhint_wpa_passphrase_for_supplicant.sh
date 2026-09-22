#!/bin/bash
#= printhint_wpa_passphrase_for_supplicant.sh 

cat <<EOF

> wpa_passphrase jdg-liry-2g my_secret_pwd
network={
        ssid="jdg-liry-2g"
        #psk="my_secret_pwd"
        psk=9be09d712761a7b351889b77b51220e4fac85fe09355e0e3cf732c0608351ad3
}

> cat /etc/wpa_supplicant/wpa_supplicant.conf

#= /etc/wpa_supplicant/wpa_supplicant.conf
country=FR
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
network={
        ssid="my-ssid"
        psk=d0c99...more..hex
}

EOF

#-eof
