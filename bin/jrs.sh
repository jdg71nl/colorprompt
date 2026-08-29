#!/bin/bash
#= jrs.sh
# John's Remote Shell -- a I/O file logging wrapper for interactive SSH sessions

# d260830 https://claude.ai/chat/b4911525-dac7-4971-8a58-eb3395f996c5
# ssh() {
#   local logdir="$HOME/sshlogs"
#   mkdir -p "$logdir"
#   # last argument is usually the host (or user@host)
#   local host="${@: -1}"
#   host="${host//[^A-Za-z0-9@._-]/_}"   # sanitize for filename
#   local logfile="$logdir/$(date +%Y-%m-%d_%H%M%S)_${host}.log"
#   script -q -f -c "command ssh $(printf '%q ' "$@")" "$logfile"
# }
# nope:
# --[CWD=~/dev]--[1788001317 13:01:57 Sat 29-Aug-2026 CEST]--[jdg@j-rpi5-workstation]--[hw:RPI5b-1.0/8G,os:Ubuntu-26.04/resolute,isa:aarch64]------
# > dpkg -S 'script' | egrep '/script$' | grep util
# bsdutils: /usr/share/bash-completion/completions/script
# bsdutils: /usr/bin/script
# xdg-utils: /usr/share/bug/xdg-utils/script
# --[CWD=~/dev]--[1788001348 13:02:28 Sat 29-Aug-2026 CEST]--[jdg@j-rpi5-workstation]--[hw:RPI5b-1.0/8G,os:Ubuntu-26.04/resolute,isa:aarch64]------
# > which script
# /usr/bin/script

BASENAME=$(basename $0)
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)

# multiple faults: echo "$@" | grep -q '.+@.+' || ( echo "# usage: $BASENAME <user@host> " && exit )
# better:
[[ "$*" =~ .+@.+ ]] || { echo "# usage: $BASENAME <user@host>" >&2; exit 1; }

arg="$1"
if [[ "$arg" == *@* ]]; then
  user="${arg%@*}"
else
  user=""
fi
host="${arg##*@}"

[[ "$user" =~ @ ]] && { echo "# Invalid 'user' -- usage: $BASENAME <user@host>" >&2; exit 1; }
[[ "$host" =~ @ ]] && { echo "# Invalid 'host' -- usage: $BASENAME <user@host>" >&2; exit 1; }

host="${host//[^A-Za-z0-9@._-]/_}"   # sanitize for filename

logdir="$HOME/sshlogs"
mkdir -p "$logdir"

DATE_TAG=$(date +d%y%m%dt%H%M%S)
echo $DATE_TAG

logfile="$logdir/$DATE_TAG-jrs--${host}.log"

if [ "test" == "true" ]; then
echo "# arg     = $arg  "
echo "# user    = $user "
echo "# host    = $host "
echo "# logfile = $logfile "
exit 1
fi

echo "# > script -q -f -c \"command ssh $user@$host\" \"$logfile\" ... "
script -q -f -c "command ssh $user@$host" "$logfile"

cat <<EOF

# Note: that the logfiles in $logdir contain "raw" control/ANSI-color characters, to prune use:
less -R ~/sshlogs/2026-08-01_*.log      # renders colors
col -b < session.log > session.txt      # strips control chars

EOF

#-eof

