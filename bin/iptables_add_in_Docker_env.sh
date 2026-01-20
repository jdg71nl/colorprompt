#!/usr/bin/env bash
# ^^^ better than: #!/bin/bash
#= template.sh | updated: d250719
# John@de-Graaff.net

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
MY_UID=$(id -u)
if [ $MY_UID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

IF_IN="eth0"
IF_OUT="eth1"

iptables -t nat -A POSTROUTING -o $IF_OUT -j MASQUERADE
iptables -A FORWARD -i $IF_IN  -o $IF_OUT -j ACCEPT
iptables -A FORWARD -i $IF_OUT -o $IF_IN  -m state --state RELATED,ESTABLISHED -j ACCEPT

#
netfilter-persistent save

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

