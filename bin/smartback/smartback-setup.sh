#!/bin/bash
#= smartback-setup.sh

if [ `id -u` != 0 ]; then 
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi

#RSYNC_PORT="22"
#RSYNC_TARGET="0.1.2.3"
#RSYNC_SSH="ssh -p $RSYNC_PORT"
#RSYNC_USER="smartback"
#RSYNC_DIR="smartback"
#CONF_DIR="/etc/smartback"
#CLIENT_CONF="$CONF_DIR/client.sh"
#SYNC_BACK="$CONF_DIR/sync_back.sh"
#FILELIST="$CONF_DIR/sources.txt"
#INCL_FILE="$CONF_DIR/rsync.includes.txt"
#SCRIPT_DIR="$HOME/opensyssetup/bin/smartback"
#CREATETOUCH_SH="$SCRIPT_DIR/_smartback-touchfile.sh"
#EXPAND_PL="$SCRIPT_DIR/_smartback-expand.pl"
#EXPAND_SH="$SCRIPT_DIR/_smartback-expand.sh"
#LISTER_SH="$SCRIPT_DIR/_smartback-filelist.sh"
#TOUCH_FILE="smartback.lastsync.touchfile"
#LOGGER_BIN="/usr/bin/logger"
#
# source client settings (this system)
#CLIENT_NAME="my_hostname"

CONF_FILE="/etc/smartback/config.sh"
[ -f "$CONF_FILE" ] && echo "# Error: 'smartback' has already been setup (do 'rm -rf /etc/smartback/' to redo) !" && exit 1

#
BASENAME=`basename $0`
usage() {
  echo "# Usage: $BASENAME -h <ssh-hostname|ip-address> -p <ssh-port-number> -u <ssh-username> -d <local-smartback-script-dir> -c <client-hostname> " 1>&2 
  exit 1
}
#
RSYNC_TARGET=""
RSYNC_PORT="22"
RSYNC_USER="smartback"
#SCRIPT_DIR="$HOME/opensyssetup/bin/smartback"
SCRIPT_DIR="$HOME/colorprompt/bin/smartback"
CLIENT_NAME=$(hostname -s)
#
while getopts ":h:p:u:d:c:" options; do
  case "${options}" in
    h) RSYNC_TARGET=${OPTARG} ;;
    p) RSYNC_PORT=${OPTARG} ;;
    u) RSYNC_USER=${OPTARG} ;;
    d) SCRIPT_DIR=${OPTARG} ;;
    c) CLIENT_NAME=${OPTARG} ;;
    :) echo "Error: -${OPTARG} requires an argument." ; usage ;;
    *) usage ;;
  esac
done
#
re_isa_num='^[0-9]+$'
if ! [[ $RSYNC_PORT =~ $re_isa_num ]] ; then
  echo "Error: -p (ssh-port)  must be a number."
  usage
fi

# test:
[ -z "$RSYNC_TARGET" ] && echo "# Error: must provide minimum a -h <SSH-Server-Hostname> !" && exit 1

cat <<HERE
# Ok, we are working with these parameters:
RSYNC_TARGET = $RSYNC_TARGET
RSYNC_PORT   = $RSYNC_PORT
RSYNC_USER   = $RSYNC_USER
SCRIPT_DIR   = $SCRIPT_DIR
CLIENT_NAME  = $CLIENT_NAME
# ...
HERE

# test:
echo "# test ping:"
echo "# > ping -c1 -W1 $RSYNC_TARGET  ... "
ping -c1 -W1 $RSYNC_TARGET &>/dev/null 
CAN_PING=$? # <== Return_Code '0' means 'True'
[ "$CAN_PING" -ne 0 ] && echo "# Error: remote host RSYNC_TARGET not reachable!" && exit 1
echo "# PING Ok !"

# test:
#SSH_OPTS="-o PreferredAuthentications=publickey -o StrictHostKeyChecking=accept-new -o ConnectTimeout=1 -o ConnectionAttempts=1"
SSH_OPTS="-o StrictHostKeyChecking=accept-new -o ConnectTimeout=1 -o ConnectionAttempts=1"
echo "# > /usr/bin/ssh -p $RSYNC_PORT $SSH_OPTS $RSYNC_USER@$RSYNC_TARGET 'exit 0'  ... "
echo "# <start> "
/usr/bin/ssh -p $RSYNC_PORT $SSH_OPTS $RSYNC_USER@$RSYNC_TARGET 'exit 0'
CAN_SSH=$? # <== Return_Code '0' means 'True'
[ "$CAN_SSH" -ne 0 ] && echo "# Error: cannot login using SSH" && exit 1
echo "# </stop> "
echo "# SSH Ok !"

# test:
CONF_TEMPL_DIR="$SCRIPT_DIR/_smartback"
CONF_TEMPL_SH="$CONF_TEMPL_DIR/config.sh"
[ ! -f "$CONF_TEMPL_SH" ] && echo "# Error: bad -d <local-smartback-script-dir> (we are expecting to exist: '$CONF_TEMPL_SH') !" && exit 1

# confirm:
read -p "# All seems to be fine. Are you happy with the CLIENT_NAME='$CLIENT_NAME' ? Type (Y/n) or ^C control-C to quit" ANSWER
#echo "# ANSWER=$ANSWER" ; exit 1
[ "$ANSWER" == "n" ] && exit 0


# general settings:
CONF_DIR="/etc/smartback"
CLIENT_CONF="$CONF_DIR/client.sh"





f_check_install_packages() {
  for PKG in $@ ; do
    if ! dpkg-query -l $PKG >/dev/null ; then
      echo "# auto installing package '$PKG' ==> sudo apt install -y $PKG "
      sudo apt install -y $PKG
    fi
  done
}
#
f_check_install_packages sudo rsync apt-show-versions lshw raspinfo neofetch

# DONT ===>   [ -f "$CONF_TEMPL_SH" ] && source "$CONF_TEMPL_SH"

echo "# - - - "
echo "# setup defaults in '$CONF_DIR' ..."
echo 
mkdir -pv $CONF_DIR/
echo "# > cp -av $CONF_TEMPL_DIR/* $CONF_DIR/   ... "
cp -av $CONF_TEMPL_DIR/* $CONF_DIR/

## Server-specific: [overwritten during first run of smartback.sh]
#RSYNC_PORT="22"
#RSYNC_TARGET="0.1.2.3"
#RSYNC_USER="smartback"
## Client-specific: [overwritten during first run of smartback.sh]
#SCRIPT_DIR="$HOME/opensyssetup/bin/smartback"

#sed -i "" 's/^.*colorprompt.sh.*$//' ${BASHRC}
#sed -i "" 's/^.*bashrc.*$/# &/'    ${CONF_FILE}

echo "# now updating Parameters in CONF_FILE=$CONF_FILE  ..."
#
sed -i "" 's/^RSYNC_TARGET.*$/RSYNC_TARGET="'$RSYNC_TARGET'"/' ${CONF_FILE}
sed -i "" 's/^RSYNC_PORT.*$/RSYNC_PORT="'$RSYNC_PORT'"/' ${CONF_FILE}
sed -i "" 's/^RSYNC_USER.*$/RSYNC_USER="'$RSYNC_USER'"/' ${CONF_FILE}
sed -i "" 's/^SCRIPT_DIR.*$/SCRIPT_DIR="'$SCRIPT_DIR'"/' ${CONF_FILE}

cat <<HERE > $CLIENT_CONF
#!/bin/bash
#= /etc/smartback/client.sh
CLIENT_NAME="$CLIENT_NAME"
HERE

#
echo "# - - - "
echo "# run this command to copy the root:SSH-key to the remote rsync-server: "
echo "> sudo ssh-create-client-id_rsa.sh "
echo "> sudo ssh-copy-id_rsa-pub.sh -p $RSYNC_PORT $RSYNC_USER@$RSYNC_TARGET "

#-eof

