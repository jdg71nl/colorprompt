#!/bin/bash
#= printhint_dd_sdcard.sh 

# - - - - - - = = = - - - - - - . 
# d260922 inspri https://gemini.google.com/app/d55695e70016b350

# - - - - - - = = = - - - - - - . 

cat <<'EOF'

--[CWD=~/Downloads]--[1790067558 10:59:18 Tue 22-Sep-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7,isa:arm64]------

> diskutil list
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *500.3 GB   disk0
   1:             Apple_APFS_ISC Container disk1         524.3 MB   disk0s1
   2:                 Apple_APFS Container disk3         494.4 GB   disk0s2
   3:        Apple_APFS_Recovery Container disk2         5.4 GB     disk0s3

/dev/disk3 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +494.4 GB   disk3
                                 Physical Store disk0s2
   1:                APFS Volume Macintosh HD            12.6 GB    disk3s1
   2:              APFS Snapshot com.apple.os.update-... 12.6 GB    disk3s1s1
   3:                APFS Volume Preboot                 7.7 GB     disk3s2
   4:                APFS Volume Recovery                1.3 GB     disk3s3
   5:                APFS Volume Data                    442.7 GB   disk3s5
   6:                APFS Volume VM                      5.4 GB     disk3s6

/dev/disk4 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *16.1 GB    disk4
   1:             Windows_FAT_32 boot                    66.1 MB    disk4s1
   2:                      Linux                         16.0 GB    disk4s2

--[CWD=~/Downloads]--[1790067562 10:59:22 Tue 22-Sep-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7,isa:arm64]------

--[CWD=~/Downloads]--[1790067641 11:00:41 Tue 22-Sep-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7,isa:arm64]------

> sudo dd if=/dev/rdisk4 of=d260922-sdcard-16GB-backup--macos-dd-rdisk.dd.img bs=1m status=progress
Password:
  16048455680 bytes (16 GB, 15 GiB) transferred 798.027s, 20 MB/s
15343+0 records in
15343+0 records out
16088301568 bytes transferred in 798.926119 secs (20137408 bytes/sec)

--[CWD=~/Downloads]--[1790068449 11:14:09 Tue 22-Sep-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7,isa:arm64]------

> file *img
d260922-sdcard-16GB-backup--macos-dd-rdisk.dd.img: DOS/MBR boot sector; partition 1 : ID=0xc, active, start-CHS (0x0,130,3), end-CHS (0x8,138,2), startsector 8192, 129024 sectors; partition 2 : ID=0x83, start-CHS (0x8,138,3), end-CHS (0x3ff,254,63), startsector 137216, 31285248 sectors

--[CWD=~/Downloads]--[1790068578 11:16:18 Tue 22-Sep-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7,isa:arm64]------

# how to test the IMG:

# download UTM (Qemu UI for MacOS): https://mac.getutm.app/

# convert .img to .qcow2:
# > brew install qemu
# then:

--[CWD=~/Downloads]--[1790069241 11:27:21 Tue 22-Sep-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7,isa:arm64]------

> qemu-img convert -f raw -O qcow2 d260922-sdcard-16GB-backup--macos-dd-rdisk.dd.img d260922-sdcard-16GB-backup--macos-dd-rdisk.dd.qcow2

--[CWD=~/Downloads]--[1790069304 11:28:24 Tue 22-Sep-2026 CEST]--[jdg@MacMiniM2-jdg71nl]--[hw:Mac,os:MacOS-Tahoe-26.7,isa:arm64]------

EOF

# - - - - - - = = = - - - - - - . 
#-eof
