#!/bin/bash

# https://perldoc.perl.org/perlrun#-i%5Bextension%5D

# perl -i -pe 's/sudo(.*?)exit 1/sudo$1exit 0/'
# find . \( -path "./.*" -prune \) -o \( -type f -name '*.sh' -exec echo "# file={}" \; \) | o

# find . \( -path "./.*" -prune \) -o \( -name '*perl_replace_allfiles_example.*' -prune \) -o \( -type f -name '*.sh' -exec perl -i -pe 's/sudo(.*?)exit 1/sudo$1exit 0/' {} \; \)

echo find . -type f -name '*.sh' -exec perl -i -pe 's/replace (this) string/with this $1 string/' {} \; 

#-eof

