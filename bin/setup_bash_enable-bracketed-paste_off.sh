#!/bin/bash
#= setup_bash_enable-bracketed-paste_off.sh

BASENAME=$(basename $0)
echo "# running: $BASENAME ... "
# SCRIPT=$(realpath -s $0)  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' ...
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)
# echo "# now changing-dir to:"
# cd $SCRIPT_PATH

# inspri: https://askubuntu.com/questions/662222/why-bracketed-paste-mode-is-enabled-sporadically-in-my-terminal-screen
# jdg: I often got long delays when pasting multi-line text in a SSH session (SecureCRT specifically?), and this solves it.

cat >$HOME/.bashrc.bracketed_paste_off  <<HERE
#= \$HOME/.bashrc.bracketed_paste_off
# d251225-jdg inspri: https://askubuntu.com/questions/662222/why-bracketed-paste-mode-is-enabled-sporadically-in-my-terminal-screen
if [[ $- == *i* ]]; then
  bind 'set enable-bracketed-paste off'
fi
#-eof
HERE

#
grep -q '.bashrc.bracketed_paste_off' ~/.bashrc || echo -e "\n# inserted by: setup_bash_enable-bracketed-paste_off.sh \n[ -f ~/.bashrc.bracketed_paste_off ] && source ~/.bashrc.bracketed_paste_off \n" >> ~/.bashrc

#-eof

