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
echo "# [updating] .bashrc ... "
#
# also: bin/prepend_scp_protection_to_bashrc.sh
#
#{ echo "This is the new first line"; cat file.txt; } > file.tmp && mv file.tmp file.txt
#
BASHRC="$HOME/.bashrc"
{
cat <<'HERE'
#= $HOME/.bashrc
# Note: .bashrc is aonly required for interactive sessions, and its possible stdout output can break scp; to fix the advice from Claude: "sshd runs .bashrc even for non-interactive sessions, so that text lands in scp's data stream and scp aborts. The fix is to only do that for interactive shells. Put this at the top of ~/.bashrc on the remote: [[ $- == *i* ]] || return"
[[ $- == *i* ]] || return

HERE
cat "$BASHRC"
} > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
#
# - - - - - - = = = - - - - - - . 
echo "# [done]: install.sh ... "
#-eof
