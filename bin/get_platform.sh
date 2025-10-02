#!/bin/bash
#= get_platform.sh

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

echo "# PLAT = MacOS | Linux | Windows | Unknown "
echo "# PLAT='$PLAT' "

#-eof
