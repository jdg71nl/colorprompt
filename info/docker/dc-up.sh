#!/bin/bash

#
BASENAME=`basename $0`
SCRIPT=`realpath $0`             # -s, --strip, --no-symlinks : don't expand symlinks
SCRIPT_PATH=`dirname $SCRIPT`
cd $SCRIPT_PATH

#
YAML_FILE="docker-compose.yaml"
[ ! -f "$YAML_FILE" ] && YAML_FILE="docker-compose.yml"
[ ! -f "$YAML_FILE" ] && echo "# Error: file not found!" && exit 1

YAML_PATH="$SCRIPT_PATH/$YAML_FILE"

# Note: on running "docker-compose":
# [1]
# --no-cache  rebuild every layer
# -pull       always attempt to pull newwer version of external images
# [2]
# "docker images" will show repo names like "vidly_frontend" -- the first part is the app name and DC uses the folder-name for this, 2nd part is svc name.
#
# ref: https://docs.docker.com/reference/compose-file/

#
#docker-compose -f $YAML_PATH up -d
# docker compose -f $YAML_PATH up -d 
# Note: carefull with '--remove-orphans' as it destroy any container not defined in this YAML
# docker compose -f $YAML_PATH up -d --remove-orphans
# docker compose -f $YAML_PATH up -d 

docker compose -f "$YAML_PATH" up -d 

#-eof
