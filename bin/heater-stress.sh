#!/usr/bin/env bash
#= colorprompt/bin/heater-stress.sh

# d261030 JDG https://claude.ai/chat/b78aec0e-1ffe-4879-b9b3-a401b9ffb701

# install on Mac:
# > brew install stress-ng
# install on Linux:
# > apt install stress-ng

# all cores, 60% load, FPU-heavy
stress-ng --cpu 0 --cpu-method matrixprod --cpu-load 60

#-eof
