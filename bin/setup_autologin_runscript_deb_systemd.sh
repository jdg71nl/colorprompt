#!/usr/bin/env bash
#= bin/setup_autologin_runscript_deb_systemd.sh

# d261102-jdg created using Claude Code on MacMiniM2-jdg71nl

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# Sets up console auto-login on a virtual terminal (default tty9) for the user running this
# script (Debian + systemd), and the chain:
#   login -> ~/.profile|~/.bash_profile -> ~/.bashrc -> ~/autostart.bat.sh &
#
# usage: setup_autologin_runscript_deb_systemd.sh [--tty N]     (N = 1..63, default 9)
#
# - tty8..tty12 are recommended: reachable via Ctrl+Alt+F8..F12 and not used by display managers
#   (GDM takes tty1 and stops getty@tty1, LightDM/older SDDM use tty7, logind spawns gettys on tty2..6),
#   so the auto-login works both on console-only and GUI boots
# - a tty above 12 has no F-key; view it with:  sudo chvt N
# - run as the normal user that should be auto-logged-in (not as root); sudo is used where needed
# - idempotent: safe to re-run; a re-run applies changes of this script and leaves unchanged files alone
# - ~/.bashrc is created if missing; its marked autostart block is (re)written only when it differs
# - ~/autostart.bat.sh is (re)generated from the template below, keeping its AUTOSTART_CMD line;
#   a differing old version is saved as ~/autostart.bat.sh.bak.<date>
# - edit AUTOSTART_CMD in ~/autostart.bat.sh to define (or clear) the foreground command
# - stop the running autostart:  kill -INT "$(cat ~/.autostart.bat.sh.pid)"
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
info() { echo "-- $*"; }
usage() { sed -n '7,/^# - - - - - - = = = .*\. $/p' "$0" | sed -e '$d' -e 's/^# \{0,1\}//'; exit "${1:-0}"; }

# --- options --------------------------------------------------------------------------------
TTY_NUM=9
while [ $# -gt 0 ]; do
  case "$1" in
    --tty)    [ $# -ge 2 ] || die "--tty needs a value"; TTY_NUM="$2"; shift 2 ;;
    --tty=*)  TTY_NUM="${1#--tty=}"; shift ;;
    -h|--help) usage 0 ;;
    *) echo "unknown argument: $1" >&2; usage 1 ;;
  esac
done
TTY_NUM="${TTY_NUM#tty}"
case "$TTY_NUM" in ''|*[!0-9]*) die "invalid tty: '$TTY_NUM' (use a number 1..63)" ;; esac
[ "$TTY_NUM" -ge 1 ] && [ "$TTY_NUM" -le 63 ] || die "tty must be 1..63, got $TTY_NUM"
TTY="tty$TTY_NUM"
case "$TTY_NUM" in
  1|7) echo "WARNING: $TTY is commonly used by display managers (GDM: tty1, LightDM: tty7); prefer 8..12" ;;
  [2-6]) echo "WARNING: systemd-logind spawns gettys on tty2..6 (and GDM sessions use tty2); prefer 8..12" ;;
esac

# --- environment checks ---------------------------------------------------------------------
[ -r /etc/os-release ] || die "/etc/os-release not found; not a Debian system?"
# shellcheck disable=SC1091
. /etc/os-release
case " ${ID:-} ${ID_LIKE:-} " in
  *" debian "*) info "OS: ${PRETTY_NAME:-$ID}" ;;
  *) die "not Debian (or Debian-based): ID='${ID:-}' ID_LIKE='${ID_LIKE:-}'" ;;
esac
[ -f /etc/debian_version ] || die "/etc/debian_version missing; not Debian?"

[ -d /run/systemd/system ] || die "systemd is not the running init system"
[ "$(ps -p 1 -o comm= 2>/dev/null)" = "systemd" ] || die "PID 1 is not systemd"
command -v systemctl >/dev/null || die "systemctl not found"

AGETTY="$(command -v agetty || true)"
[ -n "$AGETTY" ] || AGETTY=/sbin/agetty
[ -x "$AGETTY" ] || die "agetty not found"

[ "$(id -u)" -ne 0 ] || die "run this as the user to auto-login (not root / not via sudo)"
command -v sudo >/dev/null || die "sudo not found"

LOGIN_USER="$(id -un)"
[ -n "${HOME:-}" ] && [ -d "$HOME" ] || die "HOME not set or not a directory"
info "auto-login user: $LOGIN_USER  (HOME=$HOME)  on $TTY"

# --- 1. systemd getty override for the chosen tty ------------------------------------------
for other in /etc/systemd/system/getty@tty*.service.d/override.conf; do
  [ -f "$other" ] && [ "$other" != "/etc/systemd/system/getty@$TTY.service.d/override.conf" ] \
    && grep -q -- '--autologin' "$other" \
    && echo "NOTE: another auto-login override exists: $other  (remove it if no longer wanted)"
done
OVERRIDE_DIR=/etc/systemd/system/getty@$TTY.service.d
OVERRIDE_CONF="[Service]
ExecStart=
ExecStart=-$AGETTY --autologin $LOGIN_USER --noclear %I linux"
OVERRIDE_CHANGED=0
if [ "$(cat "$OVERRIDE_DIR/override.conf" 2>/dev/null)" = "$OVERRIDE_CONF" ]; then
  info "$OVERRIDE_DIR/override.conf unchanged"
else
  sudo mkdir -p "$OVERRIDE_DIR"
  printf '%s\n' "$OVERRIDE_CONF" | sudo tee "$OVERRIDE_DIR/override.conf" >/dev/null
  sudo systemctl daemon-reload
  OVERRIDE_CHANGED=1
  info "wrote $OVERRIDE_DIR/override.conf"
fi
# getty@$TTY is enabled + (re)started at the end, once ~/.bashrc and ~/autostart.bat.sh exist

# --- 2. make sure the login shell reads ~/.bashrc -------------------------------------------
# bash login shells read the first of ~/.bash_profile, ~/.bash_login, ~/.profile (not ~/.bashrc)
SOURCE_BASHRC='[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"'
PROFILE=""
for f in "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile"; do
  [ -f "$f" ] && { PROFILE="$f"; break; }
done
if [ -z "$PROFILE" ]; then
  PROFILE="$HOME/.profile"
  printf '# ~/.profile\n%s\n' "$SOURCE_BASHRC" > "$PROFILE"
  info "created $PROFILE (sources ~/.bashrc)"
elif ! grep -qE '(\.|source)[[:space:]]+.*\.bashrc' "$PROFILE"; then
  printf '\n# added by setup_autologin_runscript_deb_systemd.sh\n%s\n' "$SOURCE_BASHRC" >> "$PROFILE"
  info "appended ~/.bashrc sourcing to $PROFILE"
else
  info "$PROFILE already sources ~/.bashrc"
fi

# --- 3. ~/.bashrc starts ~/autostart.bat.sh in the background (on the auto-login tty only) --
BASHRC="$HOME/.bashrc"
MARKER_BEGIN="# >>> autostart.bat.sh >>>"
MARKER_END="# <<< autostart.bat.sh <<<"
if [ ! -f "$BASHRC" ]; then
  printf '# ~/.bashrc\n' > "$BASHRC"
  info "created $BASHRC"
fi
BASHRC_BLOCK="$MARKER_BEGIN
# start ~/autostart.bat.sh in the background on the $TTY (auto-)login; it guards itself with a pid file
if [ \"\$(tty 2>/dev/null)\" = \"/dev/$TTY\" ] && [ -x \"\$HOME/autostart.bat.sh\" ]; then
  \"\$HOME/autostart.bat.sh\" >>\"\$HOME/autostart.log\" 2>&1 </dev/null &
  disown
fi
$MARKER_END"
if [ "$(sed -n "/^$MARKER_BEGIN\$/,/^$MARKER_END\$/p" "$BASHRC")" = "$BASHRC_BLOCK" ]; then
  info "$BASHRC autostart block ($TTY) unchanged"
else
  # remove an outdated block (e.g. from an older version of this script or another --tty)
  sed -i "/^$MARKER_BEGIN\$/,/^$MARKER_END\$/d" "$BASHRC"
  [ -s "$BASHRC" ] && [ -n "$(tail -c1 "$BASHRC")" ] && echo >> "$BASHRC"   # missing final newline
  printf '%s\n' "$BASHRC_BLOCK" >> "$BASHRC"
  info "wrote autostart block ($TTY) to $BASHRC"
fi

# --- 4. ~/autostart.bat.sh ------------------------------------------------------------------
AUTOSTART="$HOME/autostart.bat.sh"
IFS= read -r -d '' AUTOSTART_TEMPLATE <<'HERE' || true
#!/usr/bin/env bash
#= ~/autostart.bat.sh  (started in the background by ~/.bashrc on the auto-login tty)
# - - - - - - = = = - - - - - - .
# Define the command to run in the foreground of this script here (empty = just block, no CPU).
# Stop it with:  kill -INT "$(cat ~/.autostart.bat.sh.pid)"
AUTOSTART_CMD=''
# - - - - - - = = = - - - - - - .

# a background job of a non-interactive shell starts with SIGINT ignored, which bash cannot trap;
# re-exec once with SIGINT reset to default so the INT trap below works however we were started
if [ -z "${_AUTOSTART_SIGRESET:-}" ] && trap -p INT | grep -q "^trap -- '' "; then
  export _AUTOSTART_SIGRESET=1
  exec env --default-signal=INT bash "$0" "$@"
fi

PIDFILE="$HOME/.autostart.bat.sh.pid"
SELF="$(basename "$0")"

# --- run-once guard: atomically create the pid file; replace it only if stale ---
for _ in 1 2; do
  if ( set -o noclobber; echo "$$" > "$PIDFILE" ) 2>/dev/null; then
    break
  fi
  oldpid="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [ -n "$oldpid" ] && kill -0 "$oldpid" 2>/dev/null \
     && tr '\0' ' ' < "/proc/$oldpid/cmdline" 2>/dev/null | grep -qF "$SELF"; then
    echo "$(date '+%F %T') $SELF already running (pid $oldpid), exiting"
    exit 0
  fi
  rm -f "$PIDFILE"   # stale pid file
done
[ "$(cat "$PIDFILE" 2>/dev/null)" = "$$" ] || { echo "could not acquire $PIDFILE"; exit 1; }

child=""
cleanup() { [ "$(cat "$PIDFILE" 2>/dev/null)" = "$$" ] && rm -f "$PIDFILE"; }
on_signal() {
  echo "$(date '+%F %T') $SELF got SIG$1, stopping"
  if [ -n "$child" ]; then
    # the child is a process group leader (set -m): signal the whole group, TERM after 2s if needed
    kill -INT -- "-$child" 2>/dev/null
    for _ in 1 2 3 4 5 6 7 8 9 10; do kill -0 -- "-$child" 2>/dev/null || break; sleep 0.2; done
    kill -TERM -- "-$child" 2>/dev/null
  fi
  exit 130
}
trap cleanup EXIT
trap 'on_signal INT' INT
trap 'on_signal TERM' TERM
trap 'on_signal HUP' HUP

# job control: the child keeps default SIGINT handling (non-interactive '&' would ignore it)
set -m

echo "$(date '+%F %T') $SELF started (pid $$)"
if [ -n "$AUTOSTART_CMD" ]; then
  echo "running: $AUTOSTART_CMD"
  bash -c "$AUTOSTART_CMD" &
else
  echo "no AUTOSTART_CMD defined, blocking until SIGINT"
  sleep infinity &
fi
child=$!
wait "$child"   # 'wait' is interruptible, so the traps fire immediately
rc=$?
echo "$(date '+%F %T') $SELF command exited (rc=$rc)"
exit "$rc"
#-eof
HERE
# keep the admin-defined AUTOSTART_CMD line of an existing ~/autostart.bat.sh
CMD_LINE="$(grep -m1 '^AUTOSTART_CMD=' "$AUTOSTART" 2>/dev/null || true)"
[ -n "$CMD_LINE" ] || CMD_LINE="AUTOSTART_CMD=''"
AUTOSTART_NEW="$(CMD_LINE="$CMD_LINE" awk '
  !done && index($0, "AUTOSTART_CMD=") == 1 { print ENVIRON["CMD_LINE"]; done = 1; next }
  { print }' <<<"$AUTOSTART_TEMPLATE")"
AUTOSTART_UPDATED=0
if [ -f "$AUTOSTART" ] && [ "$(cat "$AUTOSTART")" = "$AUTOSTART_NEW" ]; then
  info "$AUTOSTART unchanged ($CMD_LINE)"
else
  if [ -f "$AUTOSTART" ]; then
    cp -p "$AUTOSTART" "$AUTOSTART.bak.$(date +%Y%m%d-%H%M%S)"
    AUTOSTART_UPDATED=1
  fi
  # write a new file + mv: a running instance keeps reading its old (unlinked) file safely
  printf '%s\n' "$AUTOSTART_NEW" > "$AUTOSTART.new"
  chmod +x "$AUTOSTART.new"
  mv -f "$AUTOSTART.new" "$AUTOSTART"
  info "wrote $AUTOSTART ($CMD_LINE)"
  if [ "$AUTOSTART_UPDATED" = 1 ]; then
    info "  old version saved as $AUTOSTART.bak.*"
    info "  a running instance still runs the old version; stop it with kill -INT and re-login on $TTY"
  fi
fi
chmod +x "$AUTOSTART"

# --- 5. enable + (re)start the getty on the chosen tty --------------------------------------
# only tty1 is enabled by default; getty@.service is WantedBy=getty.target (console and GUI boots)
sudo systemctl enable "getty@$TTY.service" >/dev/null
if [ "$OVERRIDE_CHANGED" = 0 ] && systemctl is-active --quiet "getty@$TTY.service"; then
  info "getty@$TTY already active with this config, not restarted"
elif [ "$(tty 2>/dev/null)" = "/dev/$TTY" ]; then
  info "running on $TTY itself: not restarting getty@$TTY now, reboot to activate"
else
  sudo systemctl restart "getty@$TTY.service"
  info "getty@$TTY (re)started: $LOGIN_USER is now auto-logged-in on $TTY"
fi

# --- done -----------------------------------------------------------------------------------
echo
if [ "$TTY_NUM" -le 12 ]; then
  info "done. view the session: Ctrl+Alt+F$TTY_NUM (from a GUI) or Alt+F$TTY_NUM (from a console)"
else
  info "done. view the session: sudo chvt $TTY_NUM"
fi
info "define the command:  edit AUTOSTART_CMD in $AUTOSTART"
info "log:                 $HOME/autostart.log"
info "stop:                kill -INT \"\$(cat $HOME/.autostart.bat.sh.pid)\""
info "undo auto-login:     sudo systemctl disable --now getty@$TTY && sudo rm -r $OVERRIDE_DIR && sudo systemctl daemon-reload"

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - .
#-eof
