#!/usr/bin/env bash
#= colorprompt/bin/heater.sh

# d261030 JDG https://claude.ai/chat/b78aec0e-1ffe-4879-b9b3-a401b9ffb701

# heater.sh — adjustable CPU load generator (macOS + Linux)
#
# Usage:   ./heater.sh [percent] [cores]
#   percent  load per core, 0-100   (default: 30)
#   cores    number of cores to use (default: all)
#
# Change the load while it runs (no restart needed):
#   echo 50 > /tmp/heater.level
#
# Stop with Ctrl-C.

set -u

LEVEL_FILE=/tmp/heater.level
PERIOD_MS=100            # duty-cycle period; 100 ms keeps it smooth

ncpu() { command -v nproc >/dev/null && nproc || sysctl -n hw.ncpu; }

PCT=${1:-30}
CORES=${2:-$(ncpu)}
echo "$PCT" > "$LEVEL_FILE"

# One busy worker per core
pids=()
for ((i = 0; i < CORES; i++)); do
  yes > /dev/null &
  pids+=($!)
done

cleanup() {
  trap - INT TERM EXIT
  kill -CONT "${pids[@]}" 2>/dev/null
  kill "${pids[@]}" 2>/dev/null
  rm -f "$LEVEL_FILE"
  echo; echo "Heater stopped."
  exit 0
}
trap cleanup INT TERM EXIT

ms_to_sec() { printf '%d.%03d' $(($1 / 1000)) $(($1 % 1000)); }

last=""
while :; do
  # Re-read the level each cycle so it can be adjusted live
  read -r pct < "$LEVEL_FILE" 2>/dev/null || pct=$PCT
  [[ $pct =~ ^[0-9]+$ ]] || pct=$PCT
  ((pct > 100)) && pct=100

  if [[ $pct != "$last" ]]; then
    echo "Load: ${pct}% on ${CORES} core(s)"
    last=$pct
  fi

  on=$((PERIOD_MS * pct / 100))
  off=$((PERIOD_MS - on))

  if ((on > 0));  then kill -CONT "${pids[@]}"; sleep "$(ms_to_sec $on)";  fi
  if ((off > 0)); then kill -STOP "${pids[@]}"; sleep "$(ms_to_sec $off)"; fi
done

#-eof
