#!/bin/bash
#= .mqtt-config.sh
#
IS_MAC=0
MQTT_HOST="host"
MQTT_PORT="8883"
MQTT_USER="user"
MQTT_PASS="pass"
MQTT_TOPIC="#"
#
MQTT_PROT="mqtts"
[ "$MQTT_PORT" == "1883" ] && MQTT_PROT="mqtt"
[ "$MQTT_PORT" == "8883" ] && MQTT_PROT="mqtts"
MQTT_SPECIAL=""
[ "$MQTT_PORT" != "1883" ] && [ "$MQTT_PORT" != "8883" ] && MQTT_SPECIAL=":$MQTT_PORT"
#
#-eof
