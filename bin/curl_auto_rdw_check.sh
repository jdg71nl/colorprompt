#!/usr/bin/env bash
#= curl_auto_rdw_check.sh

# d261009 https://claude.ai/chat/cbc78cab-ce13-4923-a73a-186d0a606627

# curl_auto_rdw_check.sh
# Hourly check of the RDW open-data record for one license plate.
# Logs and e-mails a per-key diff whenever anything in the record changes.

[ "$(id -u)" -eq 0 ] || { echo "Run as root." >&2; exit 1; }

set -uo pipefail

APP_NAME="curl_auto_rdw_check"
BASE_DIR="/opt/$APP_NAME"
ETC_DIR="$BASE_DIR/etc"
VAR_DIR="$BASE_DIR/var"
CONF_FILE="$ETC_DIR/$APP_NAME.conf.sh"
LOG_FILE="$VAR_DIR/$APP_NAME.log"
LOCK_FILE="$VAR_DIR/$APP_NAME.lock"
API_URL="https://opendata.rdw.nl/resource/m9d7-ebf2.json"

# Defaults - may be overridden in the conf file
LICENSE=""
ADMIN_EMAIL_ADDRESS="john@de-graaff.net"
SUBJECT="Update/Alert script $APP_NAME"

log() { printf '%s %s\n' "$(date -Iseconds)" "$*" >> "$LOG_FILE"; }
die() { log "ERROR: $*"; echo "$APP_NAME: $*" >&2; exit 1; }

mkdir -p "$VAR_DIR"

# Only one instance at a time (protects against a hanging curl overlapping the next run)
exec 9>"$LOCK_FILE"
flock -n 9 || { log "previous run still active, skipping"; exit 0; }

# --- config ------------------------------------------------------------------
[ -r "$CONF_FILE" ] || die "config not readable: $CONF_FILE"
# shellcheck source=/dev/null
. "$CONF_FILE"

# Normalise: uppercase, strip dashes/spaces ("53-rd-bl" -> "53RDBL")
LICENSE=$(printf '%s' "$LICENSE" | tr '[:lower:]' '[:upper:]' | tr -d ' -')
[[ "$LICENSE" =~ ^[A-Z0-9]{1,8}$ ]] || die "invalid LICENSE in $CONF_FILE: '$LICENSE'"

NEW_FILE="$VAR_DIR/$LICENSE.new.json"
PREV_FILE="$VAR_DIR/$LICENSE.prev.json"

# --- [1] fetch -----------------------------------------------------------------
TMP_FILE=$(mktemp "$VAR_DIR/.$LICENSE.XXXXXX")
trap 'rm -f "$TMP_FILE"' EXIT

if ! curl --silent --show-error --fail --max-time 30 --retry 2 \
        -o "$TMP_FILE" "$API_URL?kenteken=$LICENSE" 2>>"$LOG_FILE"; then
    die "fetch failed for $LICENSE (prev snapshot kept)"
fi

# Must be a JSON array. An empty array [] is valid: plate not (or no longer) in open data.
jq -e 'type == "array"' "$TMP_FILE" >/dev/null 2>&1 \
    || die "unexpected API response for $LICENSE (not a JSON array, prev snapshot kept)"

jq . "$TMP_FILE" > "$NEW_FILE" || die "jq formatting failed"

# --- [2] diff ------------------------------------------------------------------
# Compares the first record of prev vs new, key by key:
#   ~ key: old -> new    changed
#   + key: value         added
#   - key: value         removed (e.g. all keys when the record disappears)
#
json_diff() {
    jq -rn --slurpfile p "$1" --slurpfile n "$2" '
        ($p[0][0] // {}) as $a
        | ($n[0][0] // {}) as $b
        | ([$a, $b] | map(keys) | add | unique)[] as $k
        | select($a[$k] != $b[$k])
        | if   ($a | has($k) | not) then "+ \($k): \($b[$k])"
          elif ($b | has($k) | not) then "- \($k): \($a[$k])"
          else "~ \($k): \($a[$k]) -> \($b[$k])"
          end'
}

diff=""
prev_time=""
new_time=$(date -Iseconds -r "$NEW_FILE")

if [ -f "$PREV_FILE" ]; then
    prev_time=$(date -Iseconds -r "$PREV_FILE")
    diff=$(json_diff "$PREV_FILE" "$NEW_FILE") || die "diff failed"

    # --- [3] log ---------------------------------------------------------------
    if [ -n "$diff" ]; then
        {
            echo "--"
            echo "license: $LICENSE"
            echo "prev: $prev_time"
            echo "new: $new_time"
            echo "diff:"
            echo "$diff"
        } >> "$LOG_FILE"
    else
        log "$LICENSE: no changes"
    fi
else
    log "$LICENSE: no previous snapshot, stored initial one"
fi

# --- alert ---------------------------------------------------------------------
if [ -n "$diff" ]; then
    BODY=$(cat <<EOF
--
license: $LICENSE
prev: $prev_time
new: $new_time
diff:
$diff
--
EOF
)
    if ! printf '%s\n' "$BODY" | mail -s "$SUBJECT ($LICENSE)" "$ADMIN_EMAIL_ADDRESS" 2>>"$LOG_FILE"; then
        log "ERROR: sending mail to $ADMIN_EMAIL_ADDRESS failed"
    fi
fi

# --- rotate new -> prev (cp keeps a fresh mtime = time of this check) ----------
cp "$NEW_FILE" "$PREV_FILE"

#-eof

TEST_EMAIL=$(<<'HERE'

--
license: 53RDBL
prev: 2026-10-10T11:58:23+02:00
new: 2026-10-10T12:17:01+02:00
diff:
~ merk: test_merk -> PEUGEOT
--

HERE
)



