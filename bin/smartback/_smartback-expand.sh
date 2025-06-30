#!/bin/bash
#= _smartback-expand.sh

CONF_FILE="/etc/smartback/config.sh"
[ ! -f "$CONF_FILE" ] && echo "# smartback:config.sh does not yet exist, please run smartback.sh first to create it." && exit 1
source $CONF_FILE
#
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

# source client settings (this system)
. $CLIENT_CONF
#
#CLIENT_NAME="my_hostname"

# print msg to screen@stderr and to syslog:
echo_msg_log() { 
	MSG="script $0 (PID:$$): $1"
	echo $MSG > /dev/stderr
	$LOGGER_BIN "$MSG"
}

# trap "{ rm -f "$FULLFILE"; exit 255; }" EXIT

#echo -n "$0: expanding file/source list ... " >/dev/stderr

# update rsync-includes file
echo "# rsync includes file: $INCL_FILE" > $INCL_FILE
echo "+ /$TOUCH_FILE" >> $INCL_FILE
echo "+ /etc/" >> $INCL_FILE
echo "+ /etc/smartback/" >> $INCL_FILE
#echo "+ /etc/smartback2/smartbackup.*.sysinfo.txt" >> $INCL_FILE
echo "+ /etc/smartback/**" >> $INCL_FILE
echo "- /dev/***" >> $INCL_FILE
echo "- /sys/***" >> $INCL_FILE
echo "- /proc/***" >> $INCL_FILE
echo "- /tmp/***" >> $INCL_FILE
echo "- /lost+found/***" >> $INCL_FILE
echo "- *.exe" >> $INCL_FILE
echo "- */files/*.tgz" >> $INCL_FILE
echo "- */node_modules/***" >> $INCL_FILE
#echo "+ *.sh" >> $INCL_FILE
echo "+ **/*.sh" >> $INCL_FILE
#echo "- **/chroot/***" >> $INCL_FILE

cat $FILELIST | $EXPAND_PL | sort | uniq >> $INCL_FILE
echo "- **" >> $INCL_FILE

# manual: cd /etc/smartback/; cat $FILELIST | _smartback-expand-filelist.pl | sort | uniq > rsync.includes.txt

echo "done!" >/dev/stderr

#-eof

