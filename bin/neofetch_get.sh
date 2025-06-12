#= neofetch_get.sh
FILE="$HOME/colorprompt/bin/neofetch"
echo "# > curl https://raw.githubusercontent.com/dylanaraps/neofetch/refs/heads/master/neofetch > ~/colorprompt/bin/neofetch  ... "
curl https://raw.githubusercontent.com/dylanaraps/neofetch/refs/heads/master/neofetch > $FILE
chmod +x $FILE
#-eof
