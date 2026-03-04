#!/bin/bash
#
# https://git-scm.com/docs/git-clone
# create shallow copy:
set -x
git clone --depth=1 -- %@
set +x
#
#-eof

