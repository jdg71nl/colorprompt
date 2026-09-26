#!/bin/bash
#= prepend_scp_protection_to_bashrc.sh

#{ echo "This is the new first line"; cat file.txt; } > file.tmp && mv file.tmp file.txt

BASHRC="$HOME/.bashrc"
{
cat <<'HERE'
#= $HOME/.bashrc
# Note: .bashrc is aonly required for interactive sessions, and its possible stdout output can break scp; to fix the advice from Claude: "sshd runs .bashrc even for non-interactive sessions, so that text lands in scp's data stream and scp aborts. The fix is to only do that for interactive shells. Put this at the top of ~/.bashrc on the remote: [[ $- == *i* ]] || return"
[[ $- == *i* ]] || return

HERE
cat "$BASHRC"
} > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"

#-eof

