#!/usr/bin/env bash
#= create_bash_profile_rc.sh 

cd
cat <<HERE >> .bash_profile
#= .bash_profile
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
#-eof
HERE

# - - - - - - = = = - - - - - - . 
#-eof

