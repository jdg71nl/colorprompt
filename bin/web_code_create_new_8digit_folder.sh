#!/bin/bash
#= web_code_create_new_8digit_folder.sh

max_iter=99

for ((n=1; n <= $max_iter; n++)); do 

  new_name=$(./web_code_create_8digit_foldername.sh)

  [ ! -d "$new_name" ] && mkdir -pv $new_name && break

done

#-eof

