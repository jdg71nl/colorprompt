#!/bin/bash
#= rpi_get_hardware_info.sh 

# https://elinux.org/RPi_HardwareHistory#Which_Pi_have_I_got.3F
# https://www.perturb.org/rpi?rev=b03114
# https://www.perturb.org/rpi?rev=b03114&json=true

# -H "Content-Type: application/json"
# --header 'Accept: application/json' 
# somehow this returns JSON in Browser but HTML in curl:
# > curl --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' 'https://www.perturb.org/rpi?rev=b03114&json=true'

#: --[CWD=~/colorprompt(git:main)]--[1754148410 17:26:50 Sat 02-Aug-2025 CEST]--[dcs@D-211-201]--[hw:RPI4b-1.4,os:Debian-12/bookworm,isa:aarch64]------
#: > rev=$(awk '/^Revision/ { print $3 }' /proc/cpuinfo) && echo "# > curl -L perturb.org/rpi?rev=$rev" && curl -L perturb.org/rpi?rev=$rev
#: # > curl -L perturb.org/rpi?rev=b03114
#: Revision: b03114
#: Model   : 4 Model B
#: Memory  : 2 GB
#: Overvolt: No
#: Released: Q2 2020
#: Notes   : (Mfg by Sony)

# rev=$(awk '/^Revision/ { print $3 }' /proc/cpuinfo) && echo "# > curl -L perturb.org/rpi?rev=$rev" && curl -L perturb.org/rpi?rev=$rev

[ -r /proc/cpuinfo ] && rev=$(awk '/^Revision/ { print $3 }' /proc/cpuinfo) && echo "# > curl https://www.perturb.org/rpi?rev=$rev" && curl "https://www.perturb.org/rpi?rev=$rev"

#-eof

