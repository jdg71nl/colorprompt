#!/usr/bin/env bash
#= cp-realpath-parents-to-folder.sh

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# https://en.wikipedia.org/wiki/Command-line_interface#Command_description_syntax
# <angle>        brackets for required parameters:   ping <hostname>
# [square]       brackets for optional parameters:   mkdir [-p] <dirname>
# ellipses ...   for repeated items:                 cp <source1> [source2...] <dest>
# vertical |     bars for choice of items:           netstat {-t|-u}
#
usage() {
  #echo "# usage: $BASENAME < req.flag > [ -opt.flag string ] "
  echo "# usage: $BASENAME <file> <file2> <file3> <target_dir> " 
  echo "# will resolve realpath() to each file/folder, and copy --parents to target_dir "
  exit 1
}
if [[ $# < 2 ]]; then
  usage
fi
# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 

# web says: https://stackoverflow.com/questions/1853946/getting-the-last-argument-passed-to-a-shell-script
#TARGET="${@: -1}"

# gemini says:
#TARGET="${!#}"
# or the "array way":
#args=("$@")
#TARGET="${args[-1]}"

#[ ! -d "$TARGET" ] && echo "# Error: Target '$TARGET' does not exist or is not a directory." && exit 1

# 2. Extract the last argument (Target Directory) using indirect expansion
TARGET_DIR="${!#}"

# 3. Verify the target directory exists and is actually a directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target '$TARGET_DIR' does not exist or is not a directory." >&2
    exit 1
fi

# Convert target directory to an absolute path
TARGET_DIR=$(realpath "$TARGET_DIR")


for ((i=1; i<$#; i++)); do
    # Fetch the current file argument dynamically
    CURRENT_FILE="${!i}"

    # Check if the file/folder actually exists before processing
    if [ ! -e "$CURRENT_FILE" ]; then
        echo "Warning: '$CURRENT_FILE' does not exist. Skipping..." >&2
        continue
    fi

    # 5. "Expand" the path to resolve any symlinks to their real, absolute paths
    REAL_PATH=$(realpath "$CURRENT_FILE")

    echo "Copying: $REAL_PATH -> $TARGET_DIR"

    # 6. Use cp --parents.
    # We must explicitly use absolute paths here so '--parents' mirrors
    # the structure perfectly from the root directory down.
    cp -r --parents "$REAL_PATH" "$TARGET_DIR"
done

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

