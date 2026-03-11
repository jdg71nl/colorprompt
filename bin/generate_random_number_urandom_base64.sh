#!/bin/bash
#= generate_random_number_urandom_base64.sh

# inspri: https://gist.github.com/Horat1us/38b712d65fd11abdab23347eca41b9fb
head -c 24 /dev/urandom | base64

#-eof

