#!/usr/bin/env bash
# - - - - - - = = = - - - - - - . 
echo "# > mkdir -pv ~/.log/ ; dpkg -l > ~/.log/dpkg_l.\$(date +d%y%m%dt%H%M%Sz%Z).log.txt "
          mkdir -pv ~/.log/ ; dpkg -l > ~/.log/dpkg_l.$(date +d%y%m%dt%H%M%Sz%Z).log.txt 
# - - - - - - = = = - - - - - - . 
#-eof

