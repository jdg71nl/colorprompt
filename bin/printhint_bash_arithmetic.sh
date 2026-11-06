#!/bin/bash
#= bin/printhint_bash_arithmetic.sh

cat <<'EOF'

# d261106 https://claude.ai/chat/67965374-21d5-40cd-92e0-2487220a56cd

For arithmetic, use `$(( ... ))` and put the command substitution inside it:

```bash
NEW_VAR=$(( $(nproc) - 1 ))
```

Other ways to do arithmetic in bash:

```bash
CORES=$(nproc)
NEW_VAR=$((CORES - 1))     # you can drop the $ on variable names inside $(( ))
((CORES--))                # changes the variable itself
((CORES += 2))
let "NEW_VAR = CORES - 1"  # older syntax, works the same way
```

Bash arithmetic only works with integers. For decimals, use `bc` or `awk`, for example `echo "$x * 1.5" | bc`.

If this is for something like `make -j`, you might want to keep the result at 1 or higher so it never ends up as 0 on a single-core machine:

```bash
JOBS=$(( $(nproc) > 1 ? $(nproc) - 1 : 1 ))
```

`nproc` isn't available on macOS, so use `sysctl -n hw.ncpu` there instead.

EOF

#-eof

