#!/usr/bin/env bash
#= bin/setup_autologin_runscript_deb_systemd.sh

# d261102-jdg created using Claude Code on MacMiniM2-jdg71nl

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# Sets up console auto-login on tty1 for the user running this script (Debian + systemd),
# and the chain:  login -> ~/.profile|~/.bash_profile -> ~/.bashrc -> ~/autostart.bat.sh &
#
# - run as the normal user that should be auto-logged-in (not as root); sudo is used where needed
# - ~/.bashrc and ~/autostart.bat.sh are created if missing; existing files are only appended to (once)
# - edit AUTOSTART_CMD in ~/autostart.bat.sh to define (or clear) the foreground command
# - stop the running autostart:  kill -INT "$(cat ~/.autostart.bat.sh.pid)"
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

set -euo pipefail

die() { echo "ERROR: $*" >&2; exit 1; }
info() { echo "-- $*"; }

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
info "auto-login user: $LOGIN_USER  (HOME=$HOME)"

# --- 1. systemd getty override for tty1 -----------------------------------------------------
OVERRIDE_DIR=/etc/systemd/system/getty@tty1.service.d
sudo mkdir -p "$OVERRIDE_DIR"
cat <<HERE | sudo tee "$OVERRIDE_DIR/override.conf" >/dev/null
[Service]
ExecStart=
ExecStart=-$AGETTY --autologin $LOGIN_USER --noclear %I linux
HERE
info "wrote $OVERRIDE_DIR/override.conf"
sudo systemctl daemon-reload
sudo systemctl enable getty@tty1.service >/dev/null 2>&1 || true

if [ "$(systemctl get-default)" = "graphical.target" ]; then
  echo "WARNING: default target is graphical.target; a display manager may take over tty1."
  echo "         for a console-only setup:  sudo systemctl set-default multi-user.target"
fi

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

# --- 3. ~/.bashrc starts ~/autostart.bat.sh in the background (tty1 only) -------------------
BASHRC="$HOME/.bashrc"
MARKER="# >>> autostart.bat.sh >>>"
if [ ! -f "$BASHRC" ]; then
  printf '# ~/.bashrc\n' > "$BASHRC"
  info "created $BASHRC"
fi
if ! grep -qF "$MARKER" "$BASHRC"; then
  cat <<'HERE' >> "$BASHRC"

# >>> autostart.bat.sh >>>
# start ~/autostart.bat.sh in the background on the tty1 (auto-)login; it guards itself with a pid file
if [ "$(tty 2>/dev/null)" = "/dev/tty1" ] && [ -x "$HOME/autostart.bat.sh" ]; then
  "$HOME/autostart.bat.sh" >>"$HOME/autostart.log" 2>&1 </dev/null &
  disown
fi
# <<< autostart.bat.sh <<<
HERE
  info "appended autostart block to $BASHRC"
else
  info "$BASHRC already has the autostart block"
fi

# --- 4. ~/autostart.bat.sh ------------------------------------------------------------------
AUTOSTART="$HOME/autostart.bat.sh"
if [ ! -f "$AUTOSTART" ]; then
  cat <<'HERE' > "$AUTOSTART"
#!/usr/bin/env bash
#= ~/autostart.bat.sh  (started in the background by ~/.bashrc on tty1 login)
# - - - - - - = = = - - - - - - .
# Define the command to run in the foreground of this script here (empty = just block, no CPU).
# Stop it with:  kill -INT "$(cat ~/.autostart.bat.sh.pid)"
AUTOSTART_CMD=''
# - - - - - - = = = - - - - - - .

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
    kill -INT "$child" 2>/dev/null
    sleep 2
    kill -TERM "$child" 2>/dev/null
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
  info "created $AUTOSTART"
else
  info "$AUTOSTART already exists, left unchanged"
fi
chmod +x "$AUTOSTART"

# --- done -----------------------------------------------------------------------------------
echo
info "done. reboot (or: sudo systemctl restart getty@tty1) to auto-login $LOGIN_USER on tty1"
info "define the command:  edit AUTOSTART_CMD in $AUTOSTART"
info "log:                 $HOME/autostart.log"
info "stop:                kill -INT \"\$(cat $HOME/.autostart.bat.sh.pid)\""
info "undo auto-login:     sudo rm $OVERRIDE_DIR/override.conf && sudo systemctl daemon-reload"

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - .
#-eof
