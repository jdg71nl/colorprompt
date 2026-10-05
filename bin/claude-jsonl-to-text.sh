#!/usr/bin/env bash
#= claude-jsonl-to-text.sh 

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# d261005 jdg

#: claude-log() {
#:   jq -r '
#:     select(.type=="user" or .type=="assistant") | .message.content as $c | .type as $t |
#:     ( if ($c|type)=="string" then [{type:"text",text:$c}] else $c end )[] |
#:     if .type=="text" then "\n### \($t | ascii_upcase)\n\(.text)"
#:     elif .type=="tool_use" then "  > tool \(.name): \(.input.description // .input.file_path // .input.command // "" | tostring | .[0:150])"
#:     else empty end' "$1"
#: }
#: 
#: claude-log ~/.claude/projects/-Users-jdg-dev-tmc-server/3060d4e6-c405-46cb-ad1d-ddb23f69beb6.jsonl | less

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

jq -r '
    select(.type=="user" or .type=="assistant") | .message.content as $c | .type as $t |
    ( if ($c|type)=="string" then [{type:"text",text:$c}] else $c end )[] |
    if .type=="text" then "\n### \($t | ascii_upcase)\n\(.text)"
    elif .type=="tool_use" then "  > tool \(.name): \(.input.description // .input.file_path // .input.command // "" | tostring | .[0:150])"
    else empty end' "$1"

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

RUN_EXAMPLE=<<'HERE'

mkdir -p ~/claude-logs
for f in ~/.claude/projects/-Users-jdg-dev-tmc-server/*.jsonl; do

  #claude-log "$f" > ~/claude-logs/$(basename "$f" .jsonl).txt

  out=~/claude-logs/$(basename "$f" .jsonl).txt

  claude-jsonl-to-text.sh "$f" > "$out"

  touch -r "$f" "$out"

done

grep -il "price_bars_get_length" ~/claude-logs/*.txt

HERE

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

