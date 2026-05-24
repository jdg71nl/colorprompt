#!/bin/bash
#= _smartdump-expand.sh

# general settings:
. $HOME/.config/smartdump/config.sh

# source client settings (this system)
#. $CLIENT_CONF
. $HOME/.config/smartdump/client.sh

echo -n "$0: expanding file/source list ... "

# update rsync-includes file
# first > :
echo "# rsync includes file: $INCL_FILE" > $INCL_FILE
# then >> :
echo "+ $CONF_DIR/**" >> $INCL_FILE
echo "- */node_modules/***" >> $INCL_FILE
#echo "+ *.sh" >> $INCL_FILE
echo "+ **/*.sh" >> $INCL_FILE

cat $FILELIST | $EXPAND_PL | sort | uniq >> $INCL_FILE
echo "- **" >> $INCL_FILE

# manual: cd $HOME/.conf/smartdump/; cat $FILELIST | _smartdump-expand-filelist.pl | sort | uniq > rsync.includes.txt

echo "done!"

