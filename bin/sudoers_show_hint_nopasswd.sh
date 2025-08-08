#!/usr/bin/env bash
# ^^^ better than: #!/bin/bash
#= sudoers_show_hint_nopasswd.sh 

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
MY_UID=$(id -u)
if [ $MY_UID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

cat <<HERE
#: These are 2 typical configs:

# --- 1a: add config to /etc/sudoers:
visudo

Defaults editor=/usr/bin/vim
jdg    ALL=(ALL) NOPASSWD:ALL
ubuntu ALL=(ALL) NOPASSWD:ALL
%sudo  ALL=(ALL) NOPASSWD:ALL

# --- 1b: add user to group:
adduser jdg sudo

# --- 2: add file:

echo "jdg ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jdg-sudoers-nopasswd-chmod440
chown 0:0  /etc/sudoers.d/jdg-sudoers-nopasswd-chmod440
chmod 0440 /etc/sudoers.d/jdg-sudoers-nopasswd-chmod440

echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu-sudoers-nopasswd-chmod440
chown 0:0  /etc/sudoers.d/ubuntu-sudoers-nopasswd-chmod440
chmod 0440 /etc/sudoers.d/ubuntu-sudoers-nopasswd-chmod440

#.
HERE

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

