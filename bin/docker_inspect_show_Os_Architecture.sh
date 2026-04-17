#!/bin/bash

set -x
docker inspect --format='Os={{.Os}}, Architecture={{.Architecture}}' $@

#-eof

