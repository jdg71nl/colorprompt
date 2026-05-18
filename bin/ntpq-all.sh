#!/bin/sh
echo "# > ntpq -n -c associations  "
ntpq -n -c associations
echo "# > ntpq -n -c peers  "
ntpq -n -c peers
#-eof

