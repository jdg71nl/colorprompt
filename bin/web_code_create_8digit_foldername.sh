#!/bin/bash
#= web_code_create_8digit_foldername.sh 

rand32=$(./generate_random_number_32bits_min_0_max_4294967295.pl) 
code8digit=$(awk -v min=10000000 -v max=99999999 -v rand32=$rand32 -v max32int=4294967295 'BEGIN{print int(min+rand32/max32int*(max-min+1))}')

echo $code8digit

# visually test using:
# > for ((n=1; n <= 123; n++)); do ./web_code_create_new_8digit_folder.sh ; sleep 0.1 ; done

#-eof

