#!/usr/bin/env bash

HOST="$1"
COREDNS="192.168.114.182"

echo "# > host $HOST $COREDNS "
host $HOST $COREDNS 

# - - - - - - = = = - - - - - - . 
#-eof

