#!/usr/bin/env bash
#= 

cat <<EOF

# - - - - - - = = = - - - - - - .
# ncdu
# https://dev.yorhel.nl/ncdu

# on Mac:
brew install ncdu
ncdu /Users/jdg

# - - - - - - = = = - - - - - - .
# dust (Rust-based, faster du-like tool)
# https://github.com/bootandy/dust

# on Mac:
brew install dust
dust -X /Users/jdg

# on Debian
apt install du-dust

# - - - - - - = = = - - - - - - .

EOF

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

