#!/bin/bash
#= smartback-show-remote.sh 

CONF_FILE="/etc/smartback/config.sh"
[ ! -f "$CONF_FILE" ] && echo "# smartback:config.sh does not yet exist, please run smartback.sh first to create it." && exit 1

#RSYNC_PORT="22"
#RSYNC_TARGET="0.1.2.3"
#RSYNC_SSH="ssh -p $RSYNC_PORT"
#RSYNC_USER="smartback"
#RSYNC_DIR="smartback"

ssh -p $RSYNC_PORT $RSYNC_USER@$RSYNC_TARGET "ls -1 $RSYNC_DIR"

#-eof

