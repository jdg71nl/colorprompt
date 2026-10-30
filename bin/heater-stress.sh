#!/usr/bin/env bash
#= colorprompt/bin/heater-stress.sh

# d261030 JDG https://claude.ai/chat/b78aec0e-1ffe-4879-b9b3-a401b9ffb701

# install on MacOS (not 10.15.8):
# > brew install stress-ng
# install on MacOS 10.15.8 Catalina:
# > sudo port selfupdate
# > sudo port install stress-ng
# install on Linux:
# > apt install stress-ng

# # [1] all cores, 60% load, FPU-heavy
# echo "# > stress-ng --cpu 0 --cpu-method matrixprod --cpu-load 60 "
# stress-ng --cpu 0 --cpu-method matrixprod --cpu-load 60

# LOAD="60"
LOAD="80"

# [2]
echo "# > stress-ng --cpu \"\$(nproc)\" --cpu-method matrixprod --cpu-load $LOAD --timeout 0   # -- nproc=$(nproc)"
stress-ng --cpu "$(nproc)" --cpu-method matrixprod --cpu-load $LOAD --timeout 0

#-eof
