#!/bin/bash
#= 
#
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
#usage() {
#  #echo "# usage: $BASENAME { req.flag | [ -opt.flag string ] } " 1>&2 
#  echo "# usage: $BASENAME " 1>&2 
#  exit 1
#}
echo_exit1() { echo $1 ; exit 1 ; }
#
#
#MYUID=$( id -u )
#if [ $MYUID != 0 ]; then
#  # $* is a single string, whereas $@ is an actual array.
#  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
#fi
#

#: > hostnamectl status
#:  Static hostname: juju-0733e6-production-0
#:        Icon name: computer-vm
#:          Chassis: vm
#:       Machine ID: 9f9cebc8e5e6488dae0d1163cdfda0b9
#:          Boot ID: c7117b0726d649d38cc0f107d089861d
#:   Virtualization: kvm
#: Operating System: Ubuntu 22.04.5 LTS
#:           Kernel: Linux 5.15.0-141-generic
#:     Architecture: x86-64
#:  Hardware Vendor: OpenStack Foundation
#:   Hardware Model: OpenStack Nova

hostnamectl status

#
exit 0
#
#-eof
