#!/bin/bash

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# Examples how to run command in subshell, and capture stdout and exit_code / Exit Status:

# https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html

# https://unix.stackexchange.com/questions/786103/in-bash-how-to-capture-stdout-and-the-exit-code-of-a-command-when-the-e-flag-i
#
# example how to capture both stdout and RC with 'set -e':
# > set -e
# > exit_code=0
# > OUTPUT="$(my_command 2>&1)" || exit_code=$?
#
# example how to capture both stdout and RC without 'set -e':
# > OUTPUT="$(my_command 2>&1)"
# > exit_code=$?

echo "# > STD_OUT=\"\$(echo \"hello world\" 2>&1 && exit 42)\" ; EXIT_CODE=\$? ";
STD_OUT="$(echo "hello world" 2>&1 && exit 42)" ; EXIT_CODE=$?
echo "# EXIT_CODE = '$EXIT_CODE' , STD_OUT = '$STD_OUT'"

#-eof
