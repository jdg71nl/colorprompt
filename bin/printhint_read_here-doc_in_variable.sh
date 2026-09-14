#!/bin/bash
#= printhint_read_here-doc_in_variable.sh

# - - - - - - = = = - - - - - - . 
# d260914 inspri https://claude.ai/chat/6f69a26e-ccdf-4558-b80a-967fa44eba6b

# - - - - - - = = = - - - - - - . 
var_from_literal_here_doc=$(cat <<'EOF'
{
  "system": {
    "mac_address": "",
    "host_type": "unknown|vps|mac|rpi|vm"
  },
  "hardware": {
    "isa": "amd64|arm64",
    "cpu_speed": "",
    "cores": 1,
    "mem": ""
  }
}
EOF
)
echo "# var_from_literal_here_doc = $var_from_literal_here_doc "

# - - - - - - = = = - - - - - - . 
unknown="unknown"
var_from_expanded_here_doc=$(cat <<EOF
{
  "system": {
    "mac_address": "",
    "host_type": "$unknown"
  },
  "hardware": {
    "isa": "amd64|arm64",
    "cpu_speed": "",
    "cores": 1,
    "mem": ""
  }
}
EOF
)
echo "# var_from_expanded_here_doc = $var_from_expanded_here_doc "

# - - - - - - = = = - - - - - - . 
# Below -d '' tells read to keep going until a NUL byte (which never appears), so it slurps the whole heredoc into one variable (and preserves trailing newline). -r prevents backslash mangling. This 'read' method prevents creating a subshell

# Gotcha: read returns a non-zero exit status when it hits EOF without finding the delimiter — which it always will here. That's harmless, but it trips up set -e. If you run with set -e, guard it with a  || true

read -r -d '' var_using_read_literal_here_doc <<'EOF' || true
{
  "system": {
    "mac_address": "",
    "host_type": "unknown|vps|mac|rpi|vm"
  },
  "hardware": {
    "isa": "amd64|arm64",
    "cpu_speed": "",
    "cores": 1,
    "mem": ""
  }
}
EOF
echo "# var_using_read_literal_here_doc = $var_using_read_literal_here_doc "

# - - - - - - = = = - - - - - - . 
#-eof
