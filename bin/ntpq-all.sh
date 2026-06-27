#!/bin/sh
echo
echo "# > ntpq -n -c associations  "
ntpq -n -c associations
echo
echo "# > ntpq -n -c peers  "
ntpq -n -c peers
echo
#-eof

