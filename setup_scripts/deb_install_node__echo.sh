#!/bin/bash

cat <<HERE
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# d251118-jdg: MANUAL install steps from: https://nodejs.org/en/download
#              (this worked like a charm in mcs-server-2.dcs-mgt.nl OS=Debian13/Trixie)
#
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
#
# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"
#
# Download and install Node.js:
nvm install 24
#
# Verify the Node.js version:
node -v # Should print "v24.11.1".
#
# Verify npm version:
npm -v # Should print "11.6.2".
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
# next also do:
#
sudo npm i -g nodemon
#
sudo npm i -g pm2
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
HERE

#-eof

