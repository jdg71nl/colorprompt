#!/bin/bash
#= pipe_convert_binary_to_dotted_ascii.sh 

# this breaks on MacOS (Claude: BSD tr respects your locale, and in a UTF-8 locale it chokes on byte sequences that aren't valid UTF-8.)
# tr -c '\11\12\15\40-\176' '.'

# force C locale:
cat | LC_ALL=C tr -c '\11\12\15\40-\176' '.'

#-eof


