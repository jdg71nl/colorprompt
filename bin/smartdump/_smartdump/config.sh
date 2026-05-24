#!/bin/bash
#= $HOME/.config/smartdump/config.sh
#
RSYNC_PORT=""
RSYNC_SSH="ssh -p $RSYNC_PORT"
RSYNC_TARGET="jbase2.j71.nl"
#
RSYNC_USER=""
#
# Note: $RSYNC_DIR is the server-side dir, which could be a symlink to some destination-directory:
#
RSYNC_DIR="smartdump"
#
HOME_DIR="$HOME"
CONF_DIR="$HOME_DIR/.config/smartdump"
CLIENT_CONF="$CONF_DIR/client.sh"
SYNC_BACK="$CONF_DIR/sync_back.sh"
FILELIST="$CONF_DIR/sources.txt"
INCL_FILE="$CONF_DIR/rsync.includes.txt"
#
BIN_DIR="$HOME_DIR/colorprompt/bin/smartdump"
CREATETOUCH_SH="$BIN_DIR/_smartdump-touchfile.sh"
EXPAND_PL="$BIN_DIR/_smartdump-expand.pl"
EXPAND_SH="$BIN_DIR/_smartdump-expand.sh"
#
TOUCH_FILE="smartdump.lastsync.touchfile"
#

