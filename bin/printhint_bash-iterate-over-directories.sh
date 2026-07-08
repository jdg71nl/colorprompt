#!/bin/bash
#= printhint_bash-iterate-over-directories.sh

cat <<EOF

--[CWD=/etc/openvpn]--[1783513137 14:18:57 Wed 08-Jul-2026 CEST]--[root@j-pi-3b-upmon]--[hw:RPI3b+1.3/906.9M,os:Alpine-3.23.4/n/a,isa:aarch64]------
> lt 
total 28K    
-rwxr-xr-x    1 root     root        2.6K Apr 28 09:09 up.sh
-rwxr-xr-x    1 root     root         964 Apr 28 09:09 down.sh
drwxr-xr-x    2 root     root        4.0K May 18 21:49 jmoon-gwclient/
drwxr-xr-x    2 root     root        4.0K Jul  8 12:00 hub2-silv25vpn-gwclient/
drwxr-xr-x   39 root     root        4.0K Jul  8 12:17 ../
lrwxrwxrwx    1 root     root          52 Jul  8 13:28 hub1-silv25vpn-gwclient.conf -> hub1-silv25vpn-gwclient/hub1-silv25vpn-gwclient.conf
lrwxrwxrwx    1 root     root          52 Jul  8 13:28 hub2-silv25vpn-gwclient.conf -> hub2-silv25vpn-gwclient/hub2-silv25vpn-gwclient.conf
drwxr-xr-x    2 root     root        4.0K Jul  8 13:48 hub1-silv25vpn-gwclient/
lrwxrwxrwx    1 root     root          47 Jul  8 14:02 jmoon-gwclient.conf -> /etc/openvpn/jmoon-gwclient/jmoon-gwclient.conf
drwxr-xr-x    5 root     root        4.0K Jul  8 14:02 ./

> for x in */; do echo "# \${x%/}"; done
# hub1-silv25vpn-gwclient
# hub2-silv25vpn-gwclient
# jmoon-gwclient

EOF

#-eof

