#!/bin/bash
echo "# "
echo "# [starting]: install.sh ... "
#
# - - - - - - = = = - - - - - - . 
echo "# [running] write_distro_file ... "
#
$HOME/colorprompt/bin/write_distro_file.sh
echo "# done."
#
# - - - - - - = = = - - - - - - . 
echo "# [updating] git-config ... "
#
$HOME/colorprompt/bin/git-config-jdg.sh
echo "# done."
#
# - - - - - - = = = - - - - - - . 
echo "# [copying] .vimrc ... "
#
DATE_TAG=$(date +d%y%m%dt%H%M%S)
SOURCE="$HOME/colorprompt/debian/root/dot.vimrc"
TARGET="$HOME/.vimrc"
[ -f "$TARGET" ] && cp -av "$TARGET" "$TARGET.$DATE_TAG"
cp -av "$SOURCE" "$TARGET"
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
