#!/bin/bash
#= debian_install_node-js_v24.sh
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
if ! which sudo >/dev/null ; then f_echo_exit1 "# please install first (as root) ==> apt install sudo " ; fi
if ! which dpkg-query >/dev/null ; then f_echo_exit1 "# please install first: using ==> sudo apt install dpkg-query " ; fi
#
MYUID=$( id -u )
if [ $MYUID != 0 ]; then
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

#
f_check_install_packages() { 
  for PKG in $@ ; do 
    if ! dpkg-query -l $PKG >/dev/null ; then 
      echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG " 
      sudo apt install -y $PKG 
    fi
  done
}
f_check_install_packages ca-certificates curl gnupg

#
if dpkg-query -l nodejs >/dev/null ; then
  echo "# removing old package 'nodejs' ..."
  sudo apt purge nodejs
  sudo rm -rf /usr/lib/node_modules
fi

#
mkdir -pv ~/tmp/
cd ~/tmp/
curl -fsSL https://deb.nodesource.com/setup_24.x -o nodesource_setup.sh
bash nodesource_setup.sh
cd -

#
sudo apt update

#
sudo apt install -y nodejs 

# Note: if npm gives problems you may need to just reinstall:
# 1.
# > sudo apt install --reinstall nodejs
# 2. 
# > sudo apt purge nodejs
# > sudo rm -rf /usr/lib/node_modules
# > sudo apt install nodejs
# > sudo npm install -g npm
# > sudo npm i nodemon -g
# > sudo npm i pm2 -g

#
if [ ! -f /usr/local/bin/node ]; then
  ln -s /usr/bin/node /usr/local/bin/node
fi

#
sudo npm i -g npm

#
sudo npm i -g nodemon

#
sudo npm i -g pm2

exit 0
#
#-eof

