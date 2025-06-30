#!/bin/bash
#= /etc/smartback/config.sh
#
# Server-specific: [overwritten during first run of smartback.sh]
RSYNC_PORT="22"
RSYNC_TARGET="0.1.2.3"
RSYNC_USER="smartback"
#
# Client-specific: [overwritten during first run of smartback.sh]
SCRIPT_DIR="$HOME/opensyssetup/bin/smartback"
#
# Server-generic:
RSYNC_SSH="ssh -p $RSYNC_PORT"
RSYNC_DIR="smartback"
#
# Client-config:
CONF_DIR="/etc/smartback"
CLIENT_CONF="$CONF_DIR/client.sh"
SYNC_BACK="$CONF_DIR/sync_back.sh"
FILELIST="$CONF_DIR/sources.txt"
INCL_FILE="$CONF_DIR/rsync.includes.txt"
#
# Client-scripts:
CREATETOUCH_SH="$SCRIPT_DIR/_smartback-touchfile.sh"
EXPAND_PL="$SCRIPT_DIR/_smartback-expand.pl"
EXPAND_SH="$SCRIPT_DIR/_smartback-expand.sh"
LISTER_SH="$SCRIPT_DIR/_smartback-filelist.sh"
CONF_TEMPL_DIR="$SCRIPT_DIR/_smartback"
#
TOUCH_FILE="smartback.lastsync.touchfile"
LOGGER_BIN="/usr/bin/logger"
#

