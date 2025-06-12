#!/bin/bash
#
cd $HOME
[ -d ./colorprompt/ ] && echo "# dir:colorprompt already exists!" && exit 1
read -p "# do you want to install this github repo using: [h]ttps or [s]sh ?" ANSWER
[ "$ANSWER" == "h" ] && git clone https://github.com/jdg71nl/colorprompt.git
[ "$ANSWER" == "s" ] && git clone git@github.com:jdg71nl/colorprompt.git
#.
