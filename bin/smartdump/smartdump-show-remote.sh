#!/bin/bash
#= smartdump-show-remote.sh

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
	echo "# run this command first: > smartdump.sh "

	exit
fi

# source client settings (this system)
. $CLIENT_CONF

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

#echo "sudo rsync -v -rtlz --include-from=$INCL_FILE -e \"$RSYNC_SSH\" / $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ "
#      sudo rsync -v -rtlz --include-from=$INCL_FILE -e  "$RSYNC_SSH"  / $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/

echo "# > ssh -p $RSYNC_PORT $RSYNC_USER@$RSYNC_TARGET \"ls -altr ./smartdump/\" "
          ssh -p $RSYNC_PORT $RSYNC_USER@$RSYNC_TARGET "ls -altr ./smartdump/"

echo "# $0: done!"

echo "# - - - "

cat <<HERE 

# hint for sync-back:

cd  # create new folder here
rsync -v -rtlz -e "$RSYNC_SSH" $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/folder_name .

HERE

# ------+++------
#-eof

