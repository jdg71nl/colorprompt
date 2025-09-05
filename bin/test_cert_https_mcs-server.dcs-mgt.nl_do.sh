#!/bin/bash

set -x
echo "GET /" | openssl s_client -verify 1 -showcerts -connect mcs-server.dcs-mgt.nl:8443
set +x

#-eof

