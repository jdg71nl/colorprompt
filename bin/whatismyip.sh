#!/bin/bash
#= whatismyip.sh

#echo "wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
#wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

#url="http://89.106.162.3/pubtools/whatismyip.php"
#url="http://89.106.162.12/pubtools/whatismyip.php"
#cmd="wget -q -O - $url"
#cmd2=$cmd' | grep -i "Your IP is"'
#echo "cmd: $cmd2"
#$cmd | grep -i "Your IP is"

#echo "cmd> wget -q -O - http://89.106.162.12/"
#echo "cmd> wget -q -O - http://vps2.de-graaff.net:2080/pubtools/whatismyip.php"

#echo "cmd> curl -o - http://vps2.de-graaff.net:2080/pubtools/whatismyip.php"
#curl -o - http://vps2.de-graaff.net:2080/pubtools/whatismyip.php

# > curl-cat https://dgt-bv.com/whatismyip.php
# <!-- usage: curl https://dgt-bv.com/whatismyip.php -->
# <pre>
# Your IP address is                : 80.100.229.147
# The DNS PTR-record for your IP is : jdglb21.xs4all.nl
# Local time on server is           : Mon, 08 Mar 2021 11:29:25 +0100
# Local time in Unix-Epoch seconds  : 1615199365
# </pre>
#
# > type curl-cat 
#curl-cat is aliased to `curl -fsL'
#
#curl -fsL https://dgt-bv.com/whatismyip.php
#
# d251120-jdg: decommissioned j71.nl:
#echo "# > curl -fsL https://j71.nl/whatismyip.php "
#curl -fsL https://j71.nl/whatismyip.php
#
# d251120 find this via Gemini while asking about Miktrotik RouterOS:
#: --[CWD=~]--[1763652243 16:24:03 Thu 20-Nov-2025 CET]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Sequoia-15.6.1,isa:arm64]------
#: > curl https://ipinfo.io/
#: {
#:   "ip": "176.182.174.25",
#:   "hostname": "176-182-174-25.abo.bbox.fr",
#:   "city": "Jonchery-sur-Vesle",
#:   "region": "Grand Est",
#:   "country": "FR",
#:   "loc": "49.2895,3.8135",
#:   "org": "AS5410 Bouygues Telecom SA",
#:   "postal": "51140",
#:   "timezone": "Europe/Paris",
#:   "readme": "https://ipinfo.io/missingauth"
#: }
#
echo "# > curl https://ipinfo.io/ "
curl https://ipinfo.io/
#
#-eof

