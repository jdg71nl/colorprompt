#!/bin/bash
#= printhint_bash-param-expansion-remove-prefix-suffix.sh

cat <<EOF

# https://stackoverflow.com/questions/428109/extract-substring-in-bash
# > tmp=\${a#*_}   # remove prefix ending in "_"
# > b=\${tmp%_*}   # remove suffix starting with "_"
# HOST=\${BASENAME%__mount.sh*}
#
# better: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

FULL="filename.ext"

NAME="\${FULL%.*}"   # % = remove suffix, everuthing (*) after "."
EXT_="\${FULL#*.}"   # # = remove prefix, everything (*) before "."

echo "# FULL='\$FULL'  NAME='\$NAME'  EXT_='\$EXT_' "

# FULL='filename.ext'  NAME='filename'  EXT_='ext' 

EOF

#-eof

