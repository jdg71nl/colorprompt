#!/usr/bin/env bash
#= claude-copy-logs.sh

# - - - - - - = = = - - - - - - . 
# d261005 jdg

# - - - - - - = = = - - - - - - . 
mkdir -p ~/claude-logs

for f in ~/.claude/projects/-Users-jdg-dev-tmc-server/*.jsonl; do
  out=~/claude-logs/$(basename "$f" .jsonl).txt
  echo "# > claude-jsonl-to-text.sh \"$f\" > \"$out\" "
  claude-jsonl-to-text.sh "$f" > "$out"
  touch -r "$f" "$out"
done

# - - - - - - = = = - - - - - - . 
#-eof

