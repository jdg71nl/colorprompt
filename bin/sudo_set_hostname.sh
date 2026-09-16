#!/usr/bin/env bash
# ^^^ better than: #!/bin/bash
#= 

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
MY_UID=$(id -u)
if [ $MY_UID != 0 ]; then
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
usage() {
  #echo "# usage: $BASENAME < req.flag > [ -opt.flag string ] "
  echo "# usage: $BASENAME <new-hostname.domain.top> " 
  exit 1
}
if [[ $# < 1 ]]; then
  usage
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# d260916 https://claude.ai/chat/3eaa9739-2655-487f-9943-655487b8c078
# The reason is in how the two operators match:
# % removes the shortest suffix matching the pattern. Pattern .* matches from the last dot, so it strips .nl, leaving host.j71.
# %% removes the longest suffix matching the pattern. That same .* now matches from the first dot, stripping .j71.nl, leaving host.

#FQDN="host.j71.nl"
FQDN="$1"
HOST="${FQDN%%.*}"  # remove suffix starting with '.'

#echo "# FQDN = $FQDN "
#echo "# HOST = $HOST "

echo "$FQDN" > /etc/hostname          # persistent (harmless on Debian; hostnamectl rewrites it)
#
if command -v hostnamectl >/dev/null 2>&1; then
    hostnamectl set-hostname "$FQDN"  # Debian/systemd — file + live in one
else
    hostname -F /etc/hostname         # Alpine/busybox — apply live from file
fi

# echo "127.0.1.1 $FQDN $HOST " # > /etc/hosts
# better replace:
#sed -i "s|^127\.0\.1\.1\b.*|127.0.1.1 $FQDN $HOST|" /etc/hosts
# or still better:

if grep -qE '^127\.0\.1\.1\b' /etc/hosts; then
    sed -i "s|^127\.0\.1\.1\b.*|127.0.1.1 $FQDN $HOST|" /etc/hosts
else
    echo "127.0.1.1 $FQDN $HOST" >> /etc/hosts
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

get_ipv4_for_iface() {
  local iface="$1"
  # `ip -4 -o addr show dev <iface>`: one line per address, address in
  # CIDR form (e.g. "192.168.1.5/24") as the 4th field — silently empty
  # (not an error) if the interface doesn't exist.
  ip -4 -o addr show dev "$iface" 2>/dev/null | awk '{ print $4; exit }' | cut -d/ -f1
}
#
#ip_eth0=$(get_ipv4_for_iface eth0)
#ip_eth1=$(get_ipv4_for_iface eth1)
#ip_wlan0=$(get_ipv4_for_iface wlan0)
#ip_wlan1=$(get_ipv4_for_iface wlan1)
#ip_en0=$(get_ipv4_for_iface en0)
#ip_en1=$(get_ipv4_for_iface en1)
ip_tun1099=$(get_ipv4_for_iface tun1099)

if [ ! -z "$ip_tun1099" ]; then
  echo "# add/update this line to the DNS-server: "
  echo "$FQDN  10M IN A $ip_tun1099"
  echo
fi

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof




