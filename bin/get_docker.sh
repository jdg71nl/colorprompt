#!/bin/bash
#
# found on: https://forums.raspberrypi.com/viewtopic.php?t=320769
# top of file has info: https://get.docker.com
# https://docs.docker.com/engine/install/
#
cat <<HERE

# either run unattended:

curl -sSL https://get.docker.com | bash

# or save to file, and inspect/change/run manually:

curl -fsSL https://get.docker.com -o install-docker.sh
sh install-docker.sh --dry-run
sudo sh install-docker.sh

HERE
#
#-eof
