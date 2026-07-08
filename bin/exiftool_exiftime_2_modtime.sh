#!/bin/bash
#= exiftool_exiftime_2_modtime.sh
# OLD name: pic_exif_time_2_modtime_this_dir.sh

# works for both IMAGES as MOVIES (see below)

# https://exiftool.org/
# https://github.com/exiftool/exiftool
# https://github.com/exiftool/exiftool/discussions
# https://exiftool.org/forum/index.php?topic=11776.0
#
# rjames86/My Exiftool Cheatsheet.md
# https://gist.github.com/rjames86/33b9af12548adf091a26

# install on MacOS:
# > brew install exiftool

#set -x
#exiftool '-DateTimeOriginal>FileModifyDate' .

FILE="$1"
[ ! -f "$FILE" ] && echo "# Error: file '$FILE' not found." && exit 1

exiftool '-DateTimeOriginal>FileModifyDate' $FILE

#-eof

#: ExifTool by Phil Harvey (philharvey66 at gmail.com)
#: ----------------------------------------------------------------------------
#: 
#: ExifTool is a customizable set of Perl modules plus a full-featured
#: command-line application for reading and writing meta information in a wide
#: variety of files, including the maker note information of many digital
#: cameras by various manufacturers such as Canon, Casio, DJI, FLIR, FujiFilm,
#: GE, HP, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Nikon, Nintendo,
#: Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh,
#: Samsung, Sanyo, Sigma/Foveon and Sony.
#: 
#: Below is a list of file types and meta information formats currently
#: supported by ExifTool (r = read, w = write, c = create):
#: 
#:   File Types
#:   ------------+-------------+-------------+-------------+------------
#:   360   r/w   | DR4   r/w/c | JNG   r/w   | ODP   r     | RTF   r
#:   3FR   r     | DSF   r     | JP2   r/w   | ODS   r     | RW2   r/w
#:   3G2   r/w   | DSS   r     | JPEG  r/w   | ODT   r     | RWL   r/w
#:   3GP   r/w   | DV    r     | JSON  r     | OFR   r     | RWZ   r
#:   7Z    r     | DVB   r/w   | JXL   r/w   | OGG   r     | RM    r
#:   A     r     | DVR-MS r    | K25   r     | OGV   r     | SEQ   r
#:   AA    r     | DYLIB r     | KDC   r     | ONP   r     | SKETCH r
#:   AAC   r     | EIP   r     | KEY   r     | OPUS  r     | SO    r
#:   AAE   r     | EPS   r/w   | KVAR  r     | ORF   r/w   | SR2   r/w
#:   AAX   r/w   | EPUB  r     | LA    r     | ORI   r/w   | SRF   r
#:   ACR   r     | ERF   r/w   | LFP   r     | OTF   r     | SRW   r/w
#:   AFM   r     | EXE   r     | LIF   r     | PAC   r     | SVG   r
#:   AI    r/w   | EXIF  r/w/c | LNK   r     | PAGES r     | SWF   r
#:   AIFF  r     | EXR   r     | LRV   r/w   | PBM   r/w   | THM   r/w
#:   APE   r     | EXV   r/w/c | M2TS  r     | PCAP  r     | TIFF  r/w
#:   ARQ   r/w   | F4A/V r/w   | M4A/V r/w   | PCAPNG r    | TNEF  r
#:   ARW   r/w   | FFF   r/w   | MACOS r     | PCD   r     | TORRENT r
#:   ASF   r     | FIT   r     | MAX   r     | PCX   r     | TTC   r
#:   AVI   r     | FITS  r     | MEF   r/w   | PDB   r     | TTF   r
#:   AVIF  r/w   | FLA   r     | MIE   r/w/c | PDF   r/w   | TXT   r
#:   AZW   r     | FLAC  r     | MIFF  r     | PEF   r/w   | URL   r
#:   BMP   r     | FLIF  r/w   | MKA   r     | PFA   r     | VCF   r
#:   BPG   r     | FLV   r     | MKS   r     | PFB   r     | VNT   r
#:   BTF   r     | FPF   r     | MKV   r     | PFM   r     | VRD   r/w/c
#:   C2PA  r     | FPX   r     | MNG   r/w   | PGF   r     | VSD   r
#:   CHM   r     | GIF   r/w   | MOBI  r     | PGM   r/w   | VSDX  r
#:   COS   r     | GLV   r/w   | MODD  r     | PLIST r     | WAV   r
#:   CR2   r/w   | GPR   r/w   | MOI   r     | PICT  r     | WDP   r/w
#:   CR3   r/w   | GZ    r     | MOS   r/w   | PMP   r     | WEBP  r/w
#:   CRM   r/w   | HDP   r/w   | MOV   r/w   | PNG   r/w   | WEBM  r
#:   CRW   r/w   | HDR   r     | MP3   r     | PPM   r/w   | WMA   r
#:   CS1   r/w   | HEIC  r/w   | MP4   r/w   | PPT   r     | WMV   r
#:   CSV   r     | HEIF  r/w   | MPC   r     | PPTX  r     | WOFF  r
#:   CUR   r     | HTML  r     | MPG   r     | PS    r/w   | WOFF2 r
#:   CZI   r     | ICC   r/w/c | MPO   r/w   | PSB   r/w   | WPG   r
#:   DCM   r     | ICO   r     | MQV   r/w   | PSD   r/w   | WTV   r
#:   DCP   r/w   | ICS   r     | MRC   r     | PSP   r     | WV    r
#:   DCR   r     | IDML  r     | MRW   r/w   | QTIF  r/w   | X3F   r/w
#:   DFONT r     | IIQ   r/w   | MXF   r     | R3D   r     | XCF   r
#:   DIVX  r     | IND   r/w   | NEF   r/w   | RA    r     | XISF  r
#:   DJVU  r     | INSP  r/w   | NKA   r     | RAF   r/w   | XLS   r
#:   DLL   r     | INSV  r     | NKSC  r/w   | RAM   r     | XLSX  r
#:   DNG   r/w   | INX   r     | NRW   r/w   | RAR   r     | XMP   r/w/c
#:   DOC   r     | ISO   r     | NUMBERS r   | RAW   r/w   | ZIP   r
#:   DOCX  r     | ITC   r     | NXD   r     | RIFF  r     |
#:   DPX   r     | J2C   r     | O     r     | RSRC  r     |
#: 
#: 

#: # d260706-jdg: Claude says: MOV has other tags than JPG (CreationDate):
#: > exiftool -time:all -G1 -a -s IMG_5531.MOV
#: [System]        FileModifyDate                  : 2026:07:06 20:44:31+02:00
#: [System]        FileAccessDate                  : 2026:07:06 20:50:47+02:00
#: [System]        FileInodeChangeDate             : 2026:07:06 20:50:53+02:00
#: [QuickTime]     CreateDate                      : 2026:07:06 18:44:05
#: [QuickTime]     ModifyDate                      : 2026:07:06 18:44:31
#: [Track1]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track1]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track1]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track1]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track2]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track2]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track2]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track2]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track3]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track3]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track3]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track3]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track4]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track4]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track4]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track4]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track5]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track5]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track5]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track5]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track6]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track6]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track6]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track6]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Track7]        TrackCreateDate                 : 2026:07:06 18:44:05
#: [Track7]        TrackModifyDate                 : 2026:07:06 18:44:31
#: [Track7]        MediaCreateDate                 : 2026:07:06 18:44:05
#: [Track7]        MediaModifyDate                 : 2026:07:06 18:44:31
#: [Keys]          CreationDate                    : 2026:07:06 13:17:00+02:00
#: 

