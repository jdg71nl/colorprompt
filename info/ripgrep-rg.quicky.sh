#= ripgrep-rg.quicky.sh

# https://github.com/burntsushi/ripgrep

# Install on Debian:
# https://packages.debian.org/sid/utils/ripgrep
sudo apt install ripgrep

# Install on Alpine Linux:
sudo apk add ripgrep

# Install on Mac:
# https://formulae.brew.sh/formula/ripgrep
brew install ripgrep

# - - - 
# Guide ==> https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md

# RegEx guide ==> https://docs.rs/regex/latest/regex/#syntax

# seach pattern in any files & sub:
rg pattern

# only show files that contain pattern (not the contents):
rg -l pattern

# search only in files that match "glob" pattern:
rg pattern -g '*.sh'

# search words that start with git... but that have minimum an extra Word-letter:
rg 'git\w' -g '*.sh'

# search the word git with no Word-letter before and after:
rg '\Wgit\W' -g '*.sh'

#-eof

