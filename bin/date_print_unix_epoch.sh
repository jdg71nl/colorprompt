#!/bin/bash
DATE_EPOCH=$(date +%s)
echo "# > DATE_EPOCH=\$(date +%s)"
echo "# > echo \$DATE_EPOCH"
echo $DATE_EPOCH
echo
echo "# additional info:"
cat <<HERE
> date +%s.%N
    %s: Seconds since the Unix Epoch (Jan 1, 1970).
    %N: Nanoseconds.

HERE
#-eof

