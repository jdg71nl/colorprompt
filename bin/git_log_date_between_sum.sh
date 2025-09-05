#!/bin/bash

set -x
git_log_date_between.sh | egrep '{' | perl -pe 's/^.*{(\d+)}.*$/$1/' | awk '{s+=$1} END {print s}' 
set +x

#-eof

