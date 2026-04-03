#!/usr/bin/env bash
# ^^^ better than: #!/bin/bash
#= ls_wc.sh | updated: d260403
# (c) John@de-Graaff.net
# - - - - - - = = = - - - - - - . 

echo "# > ls -1 \"$@\" | wc " 1>&2

ls -1 "$@" | wc

# - - - - - - = = = - - - - - - . 
#-eof

