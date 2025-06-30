#!/bin/bash
#= smartback.sh

if [ `id -u` != 0 ]; then 
  # https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
  # $* is a single string, whereas $@ is an actual array.
  echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
fi


CONF_FILE="/etc/smartback/config.sh"
[ ! -f "$CONF_FILE" ] && echo "# Error: 'smartback' has not yet been setup, first run: smartback-setup.sh !" && exit 1
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

# - - - 

# print msg to screen@stderr and to syslog:
echo_msg_log() { 
	MSG="script $0 (PID:$$): $1"
	echo $MSG > /dev/stderr
	logger "$MSG"
}

# ------+++------
# create status backups

echo "# - - - "
# create file listing:
. $LISTER_SH

# do: lvmdump

echo "# - - - "
# expand:
. $EXPAND_SH

f_exec_cmd_log() {
  cmd="$1"
  log="$2"
  V_L_log="/var/log/$log"
  REFFILE="/tmp/$log"
	touch -d "-1 day" $REFFILE
	if [ $log -ot $REFFILE  ]; then
    echo "# - - - "
		echo -n "# $0: (running)>  $cmd > $V_L_log  ... "
		$cmd > $V_L_log
		echo "# $0: done!"
	fi
}

if [ -f "/etc/debian_version" ] ; then
  echo "# - - - "
  echo "# updating logs: "

	# INSTALL: aptitude install apt-show-versions 
  #
#   apt_show_versions__log="apt_show_versions__log.txt"
#   V_L_apt_show_versions__log="/var/log/$apt_show_versions__log"
#   REFFILE="/tmp/$apt_show_versions__log"
# 	touch -d "-1 day" $REFFILE
# 	if [ $V_L_apt_show_versions__log -ot $REFFILE  ]; then
# 		echo -n "# $0: updating 'apt-show-versions' ... " >/dev/stderr
# 		apt-show-versions > $V_L_apt_show_versions__log
# 		echo "# $0: done!" >/dev/stderr
# 	fi
#   #
#   dpkg_l__log="dpkg_l__log.txt"
#   V_L_dpkg_l__log="/var/log/$dpkg_l__log"
#   REFFILE="/tmp/$dpkg_l__log"
# 	touch -d "-1 day" $REFFILE
# 	if [ $V_L_dpkg_l__log -ot $REFFILE  ]; then
# 		echo -n "# $0: updating 'dpk -l' ... " >/dev/stderr
# 		dpkg -l > $V_L_dpkg_l__log
# 		echo "# $0: done!" >/dev/stderr
# 	fi
  #
  f_exec_cmd_log "dpkg -l" dpkg_l__log.txt
  f_exec_cmd_log "apt-show-versions" apt_show_versions__log.txt
  f_exec_cmd_log "lshw" lshw__log.txt
  f_exec_cmd_log "dmesg" dmesg__log.txt
  f_exec_cmd_log "raspinfo" raspinfo__log.txt
  #
  # neofetch --stdout > ~/hw_info_neofetch.txt
  f_exec_cmd_log "neofetch --stdout" hw_info_neofetch.txt
  #
fi

# SYNC_BACK="$CONF_DIR/sync_back.sh"
cat <<HERE > $SYNC_BACK
#!/bin/bash
#= $SYNC_BACK
mkdir -pv $HOME/smartback/$CLIENT_NAME/
rsync -v -rtlz -e \"$RSYNC_SSH\" $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ $HOME/smartback/$CLIENT_NAME/
#-eof
HERE
chmod +x $SYNC_BACK

# ------+++------
# create touchfile:
cd $CONF_DIR/
. $CREATETOUCH_SH
# move file to root for rsync to server:
mv touchfile "/$TOUCH_FILE"

# ------+++------
# setup rsync-command and log:

echo "# - - - "
echo "# $0: rsyncing ... " >/dev/stderr

echo "rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e \"$RSYNC_SSH\"  /  $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/ "
      rsync -v -rtlz --delete --delete-excluded --include-from=$INCL_FILE -e  "$RSYNC_SSH"   /  $RSYNC_USER@$RSYNC_TARGET:$RSYNC_DIR/$CLIENT_NAME/

echo "# $0: done!" >/dev/stderr

# move file back (after rsync to server):
mv "/$TOUCH_FILE" $CONF_DIR/

echo "# - - - "
echo "# $0: sync back using: > cat $SYNC_BACK " >/dev/stderr
cat $SYNC_BACK >/dev/stderr

echo "# - - - "

#-eof

