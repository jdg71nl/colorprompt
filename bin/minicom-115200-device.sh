#!/bin/bash
#
MYID=$( id -u )
if [ $MYID != 0 ]; then
  #echo "# provide your password for 'sudo':" ; sudo "$0" "$*" ; exit 0 ;  # DONT USE $* !!
  echo "## provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi

DEV=$1

[ ! -r $DEV ] && echo "# Error: cannot open/read port '$DEV' !" && exit 1

echo "# to exit minicom (and leave serial console as it is), use: CRTL-A X "
read -p "# Press any key to continue .."

echo "# minicom --baudrate 115200 --noinit --ansi --wrap --statline --device ${DEV}  ... "
        minicom --baudrate 115200 --noinit --ansi --wrap --statline --device ${DEV}
#

