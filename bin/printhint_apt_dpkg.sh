#!/bin/bash
#= printhint_apt_dpkg.sh

cat <<EOF

# list contents (files) of a package:
dpkg -L package.deb

# Find package(s) owning file(s) (search binaries).
> dpkg -S /etc/smokeping/config
smokeping: /etc/smokeping/config

EOF

#-EOF

