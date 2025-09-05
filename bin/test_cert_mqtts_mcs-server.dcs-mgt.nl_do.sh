#!/bin/bash

set -x
echo "{}" | openssl s_client -verify 1 -showcerts -connect mcs-server.dcs-mgt.nl:8883
set +x

#-eof

