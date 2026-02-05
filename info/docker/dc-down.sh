#!/bin/bash
#
BASENAME=`basename $0`
SCRIPT=`realpath $0`             # -s, --strip, --no-symlinks : don't expand symlinks
SCRIPT_PATH=`dirname $SCRIPT`
# echo "SCRIPT='$SCRIPT"            # SCRIPT='/Users/jdg/dev/mern-template/deploy/docker/dc-mongo-52-up.sh
# echo "SCRIPT_PATH='$SCRIPT_PATH"  # SCRIPT_PATH='/Users/jdg/dev/mern-template/deploy/docker
#
YAML_FILE="docker-compose.yaml"
YAML_PATH="$SCRIPT_PATH/$YAML_FILE"
#
docker compose -f $YAML_PATH down
#
#-eof
