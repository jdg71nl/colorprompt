#!/usr/bin/env bash
#= bash-io-redirect--info.sh
# John@de-Graaff.net

echo "# (bash-io-redirect--info.sh) doing a cat <<HERE ... : "
cat <<HERE

# file-descriptors :
/dev/stdin  = fd 0
/dev/stdout = fd 1
/dev/stderr = fd 2

# to redir do:
cmd 1> /dev/null

# 1> is the same as >
cmd > /dev/null

# only stderr
cmd 2> /dev/null

# both stdout and stderr (note: the '2>&1' part needs to be AFTER the '1>' part!)
cmd 1> /dev/null 2>&1

# enhancement: This is such a common operation, that many shells have a shorthand to a single &> operator
cmd &> /dev/null

HERE

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

