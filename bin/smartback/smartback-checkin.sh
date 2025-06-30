#!/bin/bash
#= smartback-checkin.sh 

if [ `id -u` != 0 ]; then 
	# re-run as root:
	echo "# provide your password for 'sudo':"
	#sudo "$0" "$*"
	sudo "$0" "$@"
	exit 0
fi

# https://unix.stackexchange.com/questions/129072/whats-the-difference-between-and
# According to this page, $@ and $* do pretty much the same thing:
# - The $@ holds list of all arguments passed to the script. 
# - The $* holds list of all arguments passed to the script.
# They aren't the same. $* is a single string, whereas $@ is an actual array.

CONF_FILE="/etc/smartback/config.sh"
[ ! -f "$CONF_FILE" ] && echo "# smartback:config.sh does not yet exist, please run smartback.sh first to create it." && exit 1
#
source $CONF_FILE
#
#SCRIPT_DIR

# idea 'env' ==> https://stackoverflow.com/questions/12996397/command-not-found-when-using-sudo

#smartback-checkin.pl "$@"
#sudo -E env "PATH=$SCRIPT_DIR" smartback-checkin.pl "$@"
#sudo -E env "PATH=$PATH" smartback-checkin.pl "$@"
$SCRIPT_DIR/smartback-checkin.pl "$@"

#-eof

