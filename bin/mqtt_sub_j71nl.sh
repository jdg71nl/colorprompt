#!/bin/bash
#= mqtt_sub.sh
#
# MacOS install ==> brew install mosquitto-clients
# Linux install ==> apt install mosquitto
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
IS_MAC=1
MQTT_HOST="host"
MQTT_PORT="8883"
MQTT_USER="user"
MQTT_PASS="pass"
MQTT_TOPIC="#"
#
CFILE="../.mqtt-config.sh"
if [ -f "$CFILE" ]; then
  source $CFILE
else
  echo "# Config file '$CFILE' does not exist -- copy it from: dot.mqtt-config.sh "
  exit 1
fi
#
if [ "$MQTT_PORT" == "1883" ]; then
  echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT                         -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 "
        mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT                         -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
fi
if [ "$MQTT_PORT" == "8883" ]; then
  if [ "$IS_MAC" == "1" ]; then
    echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 " 
          mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
  else
    echo "mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT --capath /etc/ssl/certs -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 "
          mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT --capath /etc/ssl/certs -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC -F '\e[92m%t \e[96m%p\e[0m' -q 2 
  fi
fi
#
#-eof
