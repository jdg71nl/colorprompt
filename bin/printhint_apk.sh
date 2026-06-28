#!/bin/bash
#= printhint_rsync_ssh.sh

cat <<EOF

# show local CPU arch
> apk --print-arch
aarch64

#
cat /etc/apk/repositories

#
apk update

# 
apk upgrade

# install
apk add package-name

# show installed packages:
apk info -v
apk list --installed

# package info:
apk info package-name
#
> apk version atlec-goserver
Installed:                                Available:
atlec-goserver-1.14.0-r0                = 1.14.0-r0

EOF

#-EOF
