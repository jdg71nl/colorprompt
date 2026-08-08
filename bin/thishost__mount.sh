#!/bin/bash

BASENAME=`basename $0`

### https://stackoverflow.com/questions/428109/extract-substring-in-bash
# > tmp=${a#*_}   # remove prefix ending in "_"
# > b=${tmp%_*}   # remove suffix starting with "_"
# HOST=${BASENAME%__mount.sh*}
### better: https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

HOST=${BASENAME%__mount.sh*}

#: echo "# BASENAME = $BASENAME "
#: echo "# HOST     = $HOST "
#: # gives: 
#: # > ./thishost__mount.sh
#: # # BASENAME = thishost__mount.sh
#: # # HOST     = thishost
#: exit 0

# - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - . 
#> mount_sshfs_here.sh -h $HOST 

# HOST=""  # done above
USER="jdg"
PORT="22"
RDIR="."
LDIR=""

# dynamic defaults:
if [ -z $LDIR ]; then
  LDIR=$HOST
fi

PWD="$(pwd)"
FULLDIR="$PWD/$LDIR"
#echo "# PWD = $PWD "
#echo "# FULLDIR = $FULLDIR "
#exit 1

if [ ! -d "${FULLDIR}" ]; then
  echo "# > mkdir -pv ${FULLDIR} "
  mkdir -pv "${FULLDIR}"
fi

# - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - . 
# before d260806 

#echo "# > sshfs -p ${PORT} -o ServerAliveInterval=30 -o follow_symlinks ${USER}@${HOST}:${RDIR} ${FULLDIR} "
#          sshfs -p ${PORT} -o ServerAliveInterval=30 -o follow_symlinks ${USER}@${HOST}:${RDIR} ${FULLDIR}

# - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - . 
# d260806 https://claude.ai/chat/58758d22-44f6-4137-81e3-e265e9dd842f

echo "# >" sshfs -p ${PORT} ${USER}@${HOST}:${RDIR} ${FULLDIR} -o ServerAliveInterval=30 -o follow_symlinks -o auto_cache -o kernel_cache -o cache_timeout=20 -o Ciphers=aes128-gcm@openssh.com -o Compression=no

           sshfs -p ${PORT} ${USER}@${HOST}:${RDIR} ${FULLDIR} -o ServerAliveInterval=30 -o follow_symlinks -o auto_cache -o kernel_cache -o cache_timeout=20 -o Ciphers=aes128-gcm@openssh.com -o Compression=no

# - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - .  - - - - - - = = = - - - - - - . 
#-eof

