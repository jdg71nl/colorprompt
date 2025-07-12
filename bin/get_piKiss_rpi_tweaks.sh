#!/bin/bash
#= get_piKiss_rpi_tweaks.sh 
#
cat <<HERE

# this will install PiKISS into \$HOME/piKiss/ 
# and immediatelly run the app (ctrl-C to exit)
# (next time run it using: \$HOME/piKiss/run_piKiss.sh ) 

HERE
read -p "Press ENTER to continue ..." 
#
curl -sSL https://raw.githubusercontent.com/jmcerrejon/PiKISS/refs/heads/master/res/install.sh | bash
#
PATH_piKiss="$HOME/piKiss"
RUN_FILE="$PATH_piKiss/run_piKiss.sh"
cat <<HERE >$RUN_FILE
#!/bin/bash
BASENAME=`basename $0`
SCRIPT=`realpath $0`     
SCRIPT_PATH_piKiss=`dirname $SCRIPT`
cd $SCRIPT_PATH_piKiss
./piKiss.sh
#-eof
HERE
chmox +x $RUN_FILE
#
#-eof

