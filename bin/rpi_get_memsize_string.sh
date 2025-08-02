#!/bin/bash
#= rpi_memsize_string.sh

# Example of line:
# Memory  : 2 GB

# Examples of Memory-field:
# 256 MB 
# 256 MB / 512 MB
# 1 GB 

FILE="/proc/cpuinfo"
#: > cat /proc/cpuinfo 
#: processor       : 0
#: BogoMIPS        : 108.00
#: Features        : fp asimd evtstrm crc32 cpuid
#: CPU implementer : 0x41
#: CPU architecture: 8
#: CPU variant     : 0x0
#: CPU part        : 0xd08
#: CPU revision    : 3
#: 
#: processor       : 1
#: BogoMIPS        : 108.00
#: Features        : fp asimd evtstrm crc32 cpuid
#: CPU implementer : 0x41
#: CPU architecture: 8
#: CPU variant     : 0x0
#: CPU part        : 0xd08
#: CPU revision    : 3
#: 
#: processor       : 2
#: BogoMIPS        : 108.00
#: Features        : fp asimd evtstrm crc32 cpuid
#: CPU implementer : 0x41
#: CPU architecture: 8
#: CPU variant     : 0x0
#: CPU part        : 0xd08
#: CPU revision    : 3
#: 
#: processor       : 3
#: BogoMIPS        : 108.00
#: Features        : fp asimd evtstrm crc32 cpuid
#: CPU implementer : 0x41
#: CPU architecture: 8
#: CPU variant     : 0x0
#: CPU part        : 0xd08
#: CPU revision    : 3
#: 
#: Revision        : b03114
#: Serial          : 1000000045fb519f
#: Model           : Raspberry Pi 4 Model B Rev 1.4

REV=""
[ -r "$FILE" ] && REV=$(cat $FILE | awk '/^Revision/ { print $3 }') 
echo "# REV = $REV"

MEM=""

[ -n "$REV" ] && MEM=$(curl -sL "https://www.perturb.org/rpi?rev=$REV" | iconv -f utf-8 -t us-ascii//TRANSLIT | grep ^Memory | awk 'BEGIN { FS=":" } {print $2}' | sed 's/ \/.*$//' | sed 's/GB/G/' | sed 's/MB/M/' | sed 's/ //g')

[ -z "$MEM" ] && [ "$(which free)" ] && MEM=$(free -h | grep ^Mem | awk '{print $2}' | sed 's/\.0//' | tr -d 'i')

echo "# MEM = $MEM"

#-eof

