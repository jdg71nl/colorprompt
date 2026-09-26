#!/usr/bin/env bash
#= 

cat <<'EOF'
#:

# summary:

{ echo "This is the new first line"; cat file.txt; } > file.tmp && mv file.tmp file.txt

# for multi-line:

file="file.txt"
{
cat <<HERE
First new line
Second new line
Third new line
HERE
cat "$file"
} > "$file.tmp" && mv "$file.tmp" "$file"

# - - - - - - = = = - - - - - - . 
# d260926 jdg https://claude.ai/chat/1a4fcb6f-5081-4393-b2c7-32fdb55bb07f
# Q:
In Linux bash scripting, I know that the ">>" appends a line at the end of a text file. 
How to I prepend a line at the top of a text file?

# A:
There's no single operator for it, because files can only be extended at the end. You have to rewrite the file. The common ways:

**1. `sed` (in place)**
```bash
sed -i '1i This is the new first line' file.txt
```
Note: this fails on an empty file, since there's no line 1 to insert before. On macOS (BSD sed), `-i` needs an explicit backup suffix, and the insert syntax is stricter:
```bash
sed -i '' '1i\
This is the new first line
' file.txt
```

**2. Temp file (portable, works everywhere including empty files)**
```bash
{ echo "This is the new first line"; cat file.txt; } > file.tmp && mv file.tmp file.txt
```

**3. `sponge` from moreutils (clean one-liner)**
```bash
{ echo "new first line"; cat file.txt; } | sponge file.txt
```
`sponge` soaks up all input before writing, so it's safe to read and write the same file.

**4. `ed` (true in-place edit, POSIX)**
```bash
printf '0a\nnew first line\n.\nw\nq\n' | ed -s file.txt
```

One trap to avoid: `cat file.txt > file.txt` or `(echo x; cat file.txt) > file.txt`. The shell truncates `file.txt` before `cat` reads it, so you'll lose the contents.

For scripts that need to run on both Linux and macOS, option 2 is the safest choice.

#.
EOF

# - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . 
# - - - - - - = = = - - - - - - . 
#-eof

