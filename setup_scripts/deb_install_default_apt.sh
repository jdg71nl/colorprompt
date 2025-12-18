#!/bin/bash
#= debian_install_default_apt.sh
# (c)2025 John@de-Graaff.net
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# display every line executed in this bash script:
#set -o xtrace
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# SCRIPT_PATH=`dirname $SCRIPT`
#
f_echo_exit1() { echo $1 ; exit 1 ; }
if [ ! -e /etc/debian_version ]; then f_echo_exit1 "# Error: found non-Debain OS .." ; fi
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> > su - ; apt update && apt install sudo " ; fi
#if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
#
#: f_check_install_packages() { 
#:   for PKG in $@ ; do 
#:     if ! dpkg-query -l $PKG >/dev/null ; then 
#:       echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG " 
#:       sudo apt install -y $PKG 
#:     fi
#:   done
#: }
#: # f_check_install_packages curl git sudo
#

JINFO_OS=$(lsb_release -is)
JINFO_VERSION=$(lsb_release -rs)

if test ! -f /etc/debian_version ; then
  echo "# Error: detected non-Debian, so exit ..."
  exit 1
else
  echo "# found Debian-like OS, so proceeding ..."
  echo "# JINFO_OS=\"$JINFO_OS\" "
  echo "# JINFO_VERSION=\"$JINFO_VERSION\" "
fi

ADD_PKG_LINES=""

#JINFO_OS="Debian"
#JINFO_VERSION="12"
#
if [ "$JINFO_OS" = "Ubuntu" ]; then
  echo "# adding specific package for: Ubuntu ..."
  ADD_PKG_LINES="netcat-openbsd"
elif [ "$JINFO_OS" = "Debian" -a "$JINFO_VERSION" = "12" ]; then
  echo "# adding specific package for: Debian 12 ..."
  ADD_PKG_LINES="netcat-openbsd"
else
  echo "# adding specific package for: \"other\" distro's ..."
  ADD_PKG_LINES="netcat"
fi
# d241001 disabled:
ADD_PKG_LINES=""


FILE="deb_install_default_apt.list.txt"
#
PKG_STRING="$(echo -e $ADD_PKG_LINES | cat $FILE - | sort | tr '\n' ' ')"
#echo "# PKG_STRING=\"$PKG_STRING\""
#
echo "# apt install -y $PKG_STRING "
apt install -y $PKG_STRING 
#

# for: xeyes
# apt install -y x11-apps x11-utils 
#
# apt install -y build-essential 
# apt install -y build-essential dkms bc raspberrypi-kernel-headers
#
# apt install -y lshw hwinfo inxi
#
# apt install -y hostapd isc-dhcp-server dnsproxy
# apt install -y hostapd isc-dhcp-server dnsmasq-base

exit 0

#-eof

