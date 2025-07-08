#!/bin/bash
#= mqtt_sub_config.sh
#
# MacOS install ==> brew install mosquitto-clients
# Linux install ==> apt install mosquitto-clients
#
BASENAME=`basename $0`
echo "# running: $BASENAME ... "
# MacOS hates '-s' # SCRIPT=`realpath -s $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT=`realpath  $0`  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
SCRIPT_PATH=`dirname $SCRIPT`
#echo "# now cd'ing (change dir) to:"
cd $SCRIPT_PATH
#pwd
#
usage() {
 #echo "# usage: $BASENAME { -req_flag | [ -opt_flag string ] } " 1>&2 
 echo "# usage: $BASENAME { file.json } { my/topic/string } " 1>&2 
 exit 1
}
#if [ -z "$2" ]; then
#  usage;
#fi
#
# NOW_EPOCH=`date '+%s'`
# NOW_STRING=`date +d%y%m%dt%H%M%S%Z`
# echo "# NOW_EPOCH=$NOW_EPOCH NOW_STRING=$NOW_STRING " && exit 0
#
IS_MAC=1
MQTT_HOST="host"
MQTT_PORT="8883"
MQTT_USER="user"
MQTT_PASS="pass"
MQTT_TOPIC="#"
MQTT_PROT="mqtts"
[ "$MQTT_PORT" == "1883" ] && MQTT_PROT="mqtt"
[ "$MQTT_PORT" == "8883" ] && MQTT_PROT="mqtts"
MQTT_SPECIAL=""
[ "$MQTT_PORT" != "1883" ] && [ "$MQTT_PORT" != "8883" ] && MQTT_SPECIAL=":$MQTT_PORT"
#
CONF_FILE=".mqtt-config.sh"
CONF_PATH="./$CONF_FILE"
[ ! -f "$CONF_PATH" ] && CONF_PATH="../$CONF_FILE"
[ ! -f "$CONF_PATH" ] && echo "# Config file '$CONF_FILE' does not exist -- copy it from: dot.mqtt-config.sh " && exit 1
source $CONF_PATH
#
# MSG="$(</dev/stdin)"
#
# man-page says format URL  ==>  mqtt(s)://[username[:password]@]host[:port]/topic
# mosquitto_pub --url mqtt://user:pwd@host:port/topic -m '{"json":true}'
#
MQTT_URL="$MQTT_PROT://$MQTT_USER:$MQTT_PASS@$MQTT_HOST$MQTT_SPECIAL/$MQTT_TOPIC"
# echo "# MQTT_URL=$MQTT_URL" && exit 0
#
#: if [ "$MQTT_PORT" == "1883" ]; then
#:   echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT                         -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 "
#:         mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT                         -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
#: fi
#: if [ "$MQTT_PORT" == "8883" ]; then
#:   if [ "$IS_MAC" == "1" ]; then
#:     echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 " 
#:           mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
#:   else
#:     echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT --capath /etc/ssl/certs -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 "
#:           mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT --capath /etc/ssl/certs -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
#:   fi
#: fi
#
#echo "# > mosquitto_sub -L $MQTT_URL -F '\e[92m%t \e[96m%p\e[0m' -q 2 ..."
#          mosquitto_sub -L $MQTT_URL -F '\e[92m%t \e[96m%p\e[0m' -q 2 
#
#FORMAT='%I %q %r %t %p'
#FORMAT='Time:%I QoS:%q Retain:%r Topic:%t Message:%p'
FORMAT='Time:%I QoS:%q Retain:%r Topic:\e[92m%t\e[0m Message:\e[96m%p\e[0m'
#FORMAT='\e[92m%t \e[96m%p\e[0m'
#
echo "# > mosquitto_sub -L $MQTT_URL -F '$FORMAT' -q 2 ..."
          mosquitto_sub -L $MQTT_URL -F "$FORMAT" -q 2 
#
#-eof

 
