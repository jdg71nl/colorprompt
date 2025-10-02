#!/bin/bash
#= show-proc-cpuinfo-x86-vmx-svm.sh

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# function f_realpath() {
#   [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
# }
# SCRIPT="$(f_realpath $0)"
#
# ARG_0="$0"
# echo "# \$0 = $0 "
BASENAME=$(basename $0)
echo "# running: $BASENAME ... "
# SCRIPT=$(realpath -s $0)  # man says: "-s, --strip, --no-symlinks : don't expand symlinks"
# MacOS does not do '-s' ...
SCRIPT=$(realpath $0)
SCRIPT_PATH=$(dirname $SCRIPT)
# echo "# now changing-dir to:"
# cd $SCRIPT_PATH
# pwd
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# Note: below comes from: get_platform.sh
[ ! -x /usr/bin/uname ] && echo "# Error: we cannot run /usr/bin/uname ! (we are not on a Unix/Linux platform?) " && exit 1
case "$(/usr/bin/uname -s)" in
    Darwin)
      PLAT='MacOS'
      ;;
    Linux)
      PLAT='Linux'
      ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      PLAT='Windows'
      ;;
    *)
      PLAT='Unknown'
      ;;
esac
# echo "# PLAT = MacOS | Linux | Windows | Unknown "
echo "# OS_Platform PLAT='$PLAT'  # Options: MacOS | Linux | Windows | Unknown "

[ ! -r /proc/cpuinfo ] && echo "# Error: we cannot read /proc/cpuinfo !" && exit 1

echo "# > egrep -c '(vmx|svm)' /proc/cpuinfo "
egrep -c '(vmx|svm)' /proc/cpuinfo

#-eof

