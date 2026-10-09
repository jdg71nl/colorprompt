#!/usr/bin/env bash
#= install_curl_auto_rdw_check.sh

# d261009 https://claude.ai/chat/cbc78cab-ce13-4923-a73a-186d0a606627

# install_curl_auto_rdw_check.sh
# Installs curl_auto_rdw_check under /opt and registers an hourly cron job.
#
# Usage (as root, from the dir containing curl_auto_rdw_check.sh):
#   ./install_curl_auto_rdw_check.sh [LICENSE]
#
set -euo pipefail

APP_NAME="curl_auto_rdw_check"
HOME_DIR="/opt/$APP_NAME"
ETC_DIR="$HOME_DIR/etc"
VAR_DIR="$HOME_DIR/var"
BIN_DIR="$HOME_DIR/bin"
CONF_FILE="$ETC_DIR/$APP_NAME.conf.sh"
SCRIPT_SRC="$(dirname "$(readlink -f "$0")")/$APP_NAME.sh"
SCRIPT_DST="$BIN_DIR/$APP_NAME.sh"
CRON_FILE="/etc/cron.d/$APP_NAME"     # no dots allowed in cron.d file names
LICENSE="${1:-53RDBL}"

[ "$(id -u)" -eq 0 ] || { echo "Run as root." >&2; exit 1; }
[ -f "$SCRIPT_SRC" ] || { echo "Missing $SCRIPT_SRC" >&2; exit 1; }

# Dependencies
apt-get update -qq
apt-get install -y -qq curl jq util-linux >/dev/null   # util-linux provides flock
if ! command -v mail >/dev/null 2>&1; then
    echo "WARNING: no 'mail' command found. Install one, e.g.:"
    echo "         apt-get install bsd-mailx   (needs a working MTA: exim4/postfix/msmtp-mta)"
fi

# Directories
mkdir -pv "$ETC_DIR" "$VAR_DIR" "$BIN_DIR"

# Script
install -v -m 0755 "$SCRIPT_SRC" "$SCRIPT_DST"

# Config - never overwrite an operator-edited one
if [ ! -f "$CONF_FILE" ]; then
    cat > "$CONF_FILE" <<EOF
# $APP_NAME config - sourced by $SCRIPT_DST every run.
LICENSE="$LICENSE"
# Optional overrides:
#ADMIN_EMAIL_ADDRESS="john@de-graaff.net"
#SUBJECT="Update/Alert script $APP_NAME"
EOF
    chmod 0644 "$CONF_FILE"
    echo "Created $CONF_FILE (LICENSE=$LICENSE)"
else
    echo "Kept existing $CONF_FILE"
fi

# Cron job: hourly at minute 17 (avoids the busy :00 slot)
cat > "$CRON_FILE" <<EOF
# $APP_NAME - hourly RDW status check
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
17 * * * * root $SCRIPT_DST >/dev/null 2>>$VAR_DIR/cron.err
EOF
chmod 0644 "$CRON_FILE"
echo "Installed cron job: $CRON_FILE"

# First run now, to store the initial snapshot
"$SCRIPT_DST" && echo "Initial run OK - see $VAR_DIR/$APP_NAME.log"

#-eof

