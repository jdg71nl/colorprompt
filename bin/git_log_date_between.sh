#!/bin/bash

set -x
git log --date=iso --pretty=format:'%ad, %h, %s' | awk '$0 >= "2025-05-23" && $0 <= "2025-10-01"'
set +x

#-eof

