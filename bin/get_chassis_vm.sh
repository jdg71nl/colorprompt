#!/bin/bash

#: [ ! "$(hostnamectl)" ] && exit 1
#: # the 'iconv' is needed when jq returns 'null' so to turn it into string 'null':
#: CHAS=$(hostnamectl --json=pretty | jq -r .Chassis | iconv -f utf-8 -t us-ascii//TRANSLIT)
#: # We have seen these outputs by a quick scan (copied bewlow):
#: # null
#: # laptop
#: # vm

CHAS=""
# the 'iconv' is needed when jq returns 'null' so to turn it into string 'null':
[ "$(which hostnamectl)" ] && [ "$(which jq)" ] && CHAS=$(hostnamectl --json=pretty | jq -r .Chassis | iconv -f utf-8 -t us-ascii//TRANSLIT)
# outputs: null | laptop | vm
[ "$CHAS" == "null" ] && CHAS=""
[ "$CHAS" == "laptop" ] && CHAS="phy"

echo "# CHAS='$CHAS' "
echo "# Note: this functionality is also integrated in: write_distro_file.sh "

#-eof

#: --[CWD=~/colorprompt(git:main)]--[1754163659 21:40:59 Sat 02-Aug-2025 CEST]--[dcs@D-211-201]--[hw:RPI4b-1.4/2G,os:Debian-12/bookworm,isa:aarch64]------
#: > hostnamectl --json=pretty
#: {
#:         "Hostname" : "D-211-201",
#:         "StaticHostname" : "D-211-201",
#:         "PrettyHostname" : null,
#:         "DefaultHostname" : "localhost",
#:         "HostnameSource" : "static",
#:         "IconName" : "computer",
#:         "Chassis" : null,
#:         "Deployment" : null,
#:         "Location" : null,
#:         "KernelName" : "Linux",
#:         "KernelRelease" : "6.12.25+rpt-rpi-v8",
#:         "KernelVersion" : "#1 SMP PREEMPT Debian 1:6.12.25-1+rpt1 (2025-04-30)",
#:         "OperatingSystemPrettyName" : "Debian GNU/Linux 12 (bookworm)",
#:         "OperatingSystemCPEName" : null,
#:         "OperatingSystemHomeURL" : "https://www.debian.org/",
#:         "HardwareVendor" : null,
#:         "HardwareModel" : null,
#:         "HardwareSerial" : null,
#:         "FirmwareVersion" : null,
#:         "ProductUUID" : null
#: }
#: --[CWD=~]--[1754163463 21:37:43 Sat 02-Aug-2025 CEST]--[jdg@ex-sjors-laptop]--[hw:/31G,os:Ubuntu-24.04/noble,isa:x86_64]------
#: > hostnamectl --json=pretty
#: {
#:         "Hostname" : "ex-sjors-laptop",
#:         "StaticHostname" : "ex-sjors-laptop",
#:         "PrettyHostname" : null,
#:         "DefaultHostname" : "localhost",
#:         "HostnameSource" : "static",
#:         "IconName" : "computer-laptop",
#:         "Chassis" : "laptop",
#:         "Deployment" : null,
#:         "Location" : null,
#:         "KernelName" : "Linux",
#:         "KernelRelease" : "6.11.0-29-generic",
#:         "KernelVersion" : "#29~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Jun 26 14:16:59 UTC 2",
#:         "OperatingSystemPrettyName" : "Ubuntu 24.04.2 LTS",
#:         "OperatingSystemCPEName" : null,
#:         "OperatingSystemHomeURL" : "https://www.ubuntu.com/",
#:         "HardwareVendor" : "Notebook",
#:         "HardwareModel" : "NJx0MU",
#:         "HardwareSerial" : null,
#:         "FirmwareVersion" : "1.07.07NLWL",
#:         "FirmwareVendor" : "INSYDE Corp.",
#:         "FirmwareDate" : 1637107200000000,
#:         "MachineID" : "d95da653455f48c9a826a8e71c7e4029",
#:         "BootID" : "39fbe19dae5f43809f4d39b688add857",
#:         "ProductUUID" : null
#: }
#: 
#: 
#: --[CWD=~]--[1754163656 19:40:56 Sat 02-Aug-2025 UTC]--[ubuntu@admin]--[hw:/19G,os:Ubuntu-22.04/jammy,isa:x86_64]------
#: > hostnamectl --json=pretty
#: {
#:         "Hostname" : "admin",
#:         "StaticHostname" : "admin",
#:         "PrettyHostname" : null,
#:         "DefaultHostname" : "localhost",
#:         "HostnameSource" : "static",
#:         "IconName" : "computer-vm",
#:         "Chassis" : "vm",
#:         "Deployment" : null,
#:         "Location" : null,
#:         "KernelName" : "Linux",
#:         "KernelRelease" : "5.15.0-117-generic",
#:         "KernelVersion" : "#127-Ubuntu SMP Fri Jul 5 20:13:28 UTC 2024",
#:         "OperatingSystemPrettyName" : "Ubuntu 22.04.5 LTS",
#:         "OperatingSystemCPEName" : null,
#:         "OperatingSystemHomeURL" : "https://www.ubuntu.com/",
#:         "HardwareVendor" : null,
#:         "HardwareModel" : null,
#:         "ProductUUID" : null
#: }
#: 
#: 
#: 
#: 
#: --[CWD=~]--[1754163653 21:40:53 Sat 02-Aug-2025 CEST]--[jdg@deb-vm-minim2]--[os:Debian-12/bookworm,isa:aarch64]------
#: > hostnamectl --json=pretty
#: {
#:         "Hostname" : "deb-vm-minim2.j71.nl",
#:         "StaticHostname" : "deb-vm-minim2.j71.nl",
#:         "PrettyHostname" : null,
#:         "DefaultHostname" : "localhost",
#:         "HostnameSource" : "static",
#:         "IconName" : "computer-vm",
#:         "Chassis" : "vm",
#:         "Deployment" : null,
#:         "Location" : null,
#:         "KernelName" : "Linux",
#:         "KernelRelease" : "6.1.0-33-arm64",
#:         "KernelVersion" : "#1 SMP Debian 6.1.133-1 (2025-04-10)",
#:         "OperatingSystemPrettyName" : "Debian GNU/Linux 12 (bookworm)",
#:         "OperatingSystemCPEName" : null,
#:         "OperatingSystemHomeURL" : "https://www.debian.org/",
#:         "HardwareVendor" : "VMware, Inc.",
#:         "HardwareModel" : "VMware20,1",
#:         "HardwareSerial" : null,
#:         "FirmwareVersion" : "VMW201.00V.24006586.BA64.2406042154",
#:         "ProductUUID" : null
#: }
#: 
#: 


#: --[CWD=~]--[1754164713 21:58:33 Sat 02-Aug-2025 CEST]--[jdg@gw-235-015]--[os:Debian-12/bookworm,isa:x86_64]------
#: > hostnamectl 
#:  Static hostname: gw-235-015.dcs-mgt.nl
#:        Icon name: computer-laptop
#:          Chassis: laptop 💻
#:       Machine ID: f85c15a7f974427aaa2dd852c17a2660
#:          Boot ID: b79a16ab332d45838f28816312f11aaf
#: Operating System: Debian GNU/Linux 12 (bookworm)  
#:           Kernel: Linux 6.1.0-37-amd64
#:     Architecture: x86-64
#:  Hardware Vendor: Supermicro
#:   Hardware Model: SYS-E50-9AP
#: Firmware Version: 1.9

#: --[CWD=~]--[1754164776 21:59:36 Sat 02-Aug-2025 CEST]--[jdg@gw-235-015]--[os:Debian-12/bookworm,isa:x86_64]------
#: > hostnamectl --json=pretty
#: {
#:         "Hostname" : "gw-235-015.dcs-mgt.nl",
#:         "StaticHostname" : "gw-235-015.dcs-mgt.nl",
#:         "PrettyHostname" : null,
#:         "DefaultHostname" : "localhost",
#:         "HostnameSource" : "static",
#:         "IconName" : "computer-laptop",
#:         "Chassis" : "laptop",
#:         "Deployment" : null,
#:         "Location" : null,
#:         "KernelName" : "Linux",
#:         "KernelRelease" : "6.1.0-37-amd64",
#:         "KernelVersion" : "#1 SMP PREEMPT_DYNAMIC Debian 6.1.140-1 (2025-05-22)",
#:         "OperatingSystemPrettyName" : "Debian GNU/Linux 12 (bookworm)",
#:         "OperatingSystemCPEName" : null,
#:         "OperatingSystemHomeURL" : "https://www.debian.org/",
#:         "HardwareVendor" : "Supermicro",
#:         "HardwareModel" : "SYS-E50-9AP",
#:         "HardwareSerial" : null,
#:         "FirmwareVersion" : "1.9",
#:         "ProductUUID" : null
#: }

