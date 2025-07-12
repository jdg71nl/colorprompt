#!/bin/bash
#
echo
#
cat <<HERE
Defaults editor=/usr/bin/vim
# username ALL=(ALL) NOPASSWD:ALL
%sudo ALL=(ALL) NOPASSWD:ALL
HERE
#
echo
#
read -p "press enter to start 'visudo' (but first copy above text) ... "
#
sudo visudo
#
#-eof

