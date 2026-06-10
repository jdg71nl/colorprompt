#!/bin/bash
#= smartdump.sh

#usage() {
#  echo "Usage: $0 [ -n NAME ] [ -t TIMES ]" 1>&2 
#}
#exit_abnormal() {
#  usage
#  exit 1
#}

# general settings:
CONF_DIR="$HOME/.config/smartdump"
CONF_SH="$CONF_DIR/config.sh"
CLIENT_CONF="$CONF_DIR/client.sh"
FILELIST="$CONF_DIR/sources.txt"
CONF_TEMPL_DIR="$HOME/colorprompt/bin/smartdump/_smartdump"

[ -f "$CONF_SH" ] && source "$CONF_SH"

if [ ! -f "$CLIENT_CONF" ] ; then
  echo "# - - - "
	echo "# NOTICE: smartdump not yet setup on this system (file does not exist: \$CLIENT_CONF=$CLIENT_CONF)"
	echo 

  echo "# - - - "
  echo "# setup defaults in '$CONF_DIR' ..."
	echo 
	mkdir -pv $CONF_DIR/
	cp -av $CONF_TEMPL_DIR/* $CONF_DIR/
	echo -e '#!/bin/bash\n#= $HOME/.config/smartdump/client.sh\nCLIENT_NAME="'$(hostname -s)'"' > $CLIENT_CONF
	echo
  #echo -e "\n$HOME/.config/smartdump/" >> $FILELIST
  echo -e "\n$CONF_DIR/" >> $FILELIST

	exit
fi

# source client settings (this system)
. $CLIENT_CONF

# ------+++------
# create status backups

echo "# - - - "
# expand:
. $EXPAND_SH

# ------+++------
# create touchfile:
cd $CONF_DIR/
. $CREATETOUCH_SH
## move file to root for rsync to server:
#mv touchfile "/$TOUCH_FILE"

# ------+++------
# user provided:

RSYNC_PORT=""
RSYNC_USER=""
RSYNC_SSH=""

read -p "# type RSYNC_PORT: " RSYNC_PORT
read -p "# type RSYNC_USER: " RSYNC_USER

#echo "# RSYNC_PORT = '$RSYNC_PORT' "
#echo "# RSYNC_USER = '$RSYNC_USER' "

RSYNC_SSH="ssh -p $RSYNC_PORT"
#exit 1

# ------+++------
# setup rsync-command and log:

echo "# - - - "
echo "$0: rsyncing ... " 

#echo "rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e \"$RSYNC_SSH\" / $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ "

echo "sudo rsync -v -rtlz --include-from=$INCL_FILE -e \"$RSYNC_SSH\" / $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ "
      sudo rsync -v -rtlz --include-from=$INCL_FILE -e  "$RSYNC_SSH"  / $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/

echo "$0: done!"

echo "# - - - "

cat <<HERE

# consider saving the installed-packages state:

# first:
mkdir -pv ~/.log/

# Alpine:
apk info -v > ~/.log/apk_info_v.\$(date +d%y%m%dt%H%M%Sz%Z).log.txt

# Debian:
dpkg -l > ~/.log/dpkg_l.\$(date +d%y%m%dt%H%M%Sz%Z).log.txt

# then:
smartdump-checkin.pl ~/.log/

HERE

# ------+++------
#-eof

