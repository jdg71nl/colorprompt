#!/bin/bash
echo "# "
echo "# [starting]: install.sh ... "
#
# - - - - - - = = = - - - - - - . 
echo "# [running] write_distro_file ... "
#
. $HOME/colorprompt/bin/write_distro_file.sh
echo "# done."
#
# - - - - - - = = = - - - - - - . 
echo "# [updating] .bashrc ... "
#
BASHRC="$HOME/.bashrc"
touch $BASHRC
# remove old line:
sed -i 's/^.*colorprompt\.sh.*$/# &/' ${BASHRC}
echo -e "\nsource \$HOME/colorprompt/colorprompt.sh \n" >> $BASHRC
echo "# done."
#
# - - - - - - = = = - - - - - - . 
echo "# [done]: install.sh ... "
#-eof
