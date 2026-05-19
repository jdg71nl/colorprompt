#!/bin/bash
#= wake_wol_minim2.sh 

# > apt-get install wakeonlan -y

# --[CWD=~]--[1740704418 02:00:18 Fri 28-Feb-2025 CET]--[root@j33rtr]--[hw:RPI5b-1.0,os:Debian-12/bookworm,isa:aarch64]------
# > arp-scan -I eth1 -l
# Interface: eth1, type: EN10MB, MAC: 50:91:e3:53:cd:0a, IPv4: 10.33.10.254
# Starting arp-scan 1.10.0 with 256 hosts (https://github.com/royhills/arp-scan)
# 10.33.10.150    00:c5:85:0b:17:45       Apple, Inc.
# 
# 1 packets received by filter, 0 packets dropped by kernel
# Ending arp-scan 1.10.0: 256 hosts scanned in 2.123 seconds (120.58 hosts/sec). 1 responded
# 
# --[CWD=~]--[1740704426 02:00:26 Fri 28-Feb-2025 CET]--[root@j33rtr]--[hw:RPI5b-1.0,os:Debian-12/bookworm,isa:aarch64]------

#: --[CWD=~/colorprompt/bin(git:main)]--[1779224783 23:06:23 Tue 19-May-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.5,isa:arm64]------
#: > ifconfig en0
#: en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
#:         options=50b<RXCSUM,TXCSUM,VLAN_HWTAGGING,AV,CHANNEL_IO>
#:         ether 00:c5:85:0b:17:45
#:         inet6 fe80::4a6:e3a5:494f:ed76%en0 prefixlen 64 secured scopeid 0x8 
#:         inet 10.62.10.150 netmask 0xffffff00 broadcast 10.62.10.255
#:         nd6 options=201<PERFORMNUD,DAD>
#:         media: autoselect (1000baseT <full-duplex>)
#:         status: active

MAC="00:c5:85:0b:17:45"

#set -o xtrace

echo "# > wakeonlan $MAC   ... "
wakeonlan $MAC

#-eof

