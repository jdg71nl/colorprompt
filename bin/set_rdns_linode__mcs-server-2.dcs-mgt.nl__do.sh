#!/bin/bash
#= set_rdns_linode__mcs-server-2.dcs-mgt.nl__do.sh

# https://techdocs.akamai.com/linode-api/reference/get-started

# https://techdocs.akamai.com/linode-api/reference/put-linode-ip

TOKEN=""

read -p "# Enter TOKEN: " TOKEN

#echo "# TOKEN = $TOKEN "
#exit 1

curl --request PUT \
     --url https://api.linode.com/v4/linode/instances/87160671/ips/172.235.191.188 \
     --header 'accept: application/json' \
     --header "authorization: Bearer $TOKEN" \
     --header 'content-type: application/json' \
     --data '
{
  "rdns": "mcs-server-2.dcs-mgt.nl"
}
'

exit 0

# result:
# {"address": "172.235.191.188", "gateway": "172.235.191.1", "subnet_mask": "255.255.255.0", "prefix": 24, "type": "ipv4", "public": true, "rdns": "mcs-server-2.dcs-mgt.nl", "linode_id": 87160671, "interface_id": null, "region": "nl-ams", "vpc_nat_1_1": {"vpc_id": 154963, "subnet_id": 150165, "address": "10.25.2.3"}, "assigned_entity": {"id": 87160671, "type": "linode", "label": "mcs-server-2-DCSNL", "url": "/v4/linode/instances/87160671"}}

cat <<HERE
{
  "address": "172.235.191.188",
  "gateway": "172.235.191.1",
  "subnet_mask": "255.255.255.0",
  "prefix": 24,
  "type": "ipv4",
  "public": true,
  "rdns": "mcs-server-2.dcs-mgt.nl",
  "linode_id": 87160671,
  "interface_id": null,
  "region": "nl-ams",
  "vpc_nat_1_1": {
    "vpc_id": 154963,
    "subnet_id": 150165,
    "address": "10.25.2.3"
  },
  "assigned_entity": {
    "id": 87160671,
    "type": "linode",
    "label": "mcs-server-2-DCSNL",
    "url": "/v4/linode/instances/87160671"
  }
}
HERE

cat <<HERE
--[CWD=~/colorprompt/bin(git:main)]--[1764090680 18:11:20 Tue 25-Nov-2025 CET]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Sequoia-15.6.1,isa:arm64]------
> host 172.235.191.188
188.191.235.172.in-addr.arpa domain name pointer 172-235-191-188.ip.linodeusercontent.com.
HERE

#-eof

