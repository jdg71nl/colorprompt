#!/usr/bin/env bash
# - - - - - - = = = - - - - - - . 
echo "# > mkdir -pv ~/.logs/ ; apk info -v > ~/.log/apk_info_v.\$(date +d%y%m%dt%H%M%Sz%Z).log.txt "
          mkdir -pv ~/.logs/ ; apk info -v > ~/.log/apk_info_v.$(date +d%y%m%dt%H%M%Sz%Z).log.txt 
# - - - - - - = = = - - - - - - . 
#-eof

