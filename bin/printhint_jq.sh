#!/bin/bash
#= printhint_jq.sh

cat <<EOF

# https://jqlang.org/
# https://formulae.brew.sh/formula/jq

# install Mac, Debian, Alpine:
> brew install jq
> apt install jq
> apk add jq

#
> cat apps/api/package.json | jq '{ type }'
{
  "type": "module"
}

#
> cat apps/api/package.json | jq '.type'
"module"

# select sub tree, conditional include sub objects
> cat package.json | jq '{ nx: { targets: (.nx.targets | map_values(if has("dependsOn") then {dependsOn} else {} end)) } }' 
{
  "nx": {
    "targets": {
      "build": {},
      "prune-lockfile": {
        "dependsOn": ["build"]
      },
      "copy-workspace-modules": {
        "dependsOn": ["build"]
      }
    }
  }
}

# select property of array entry 0
> curl --silent 'https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=53RDBL' | jq '.[0] | {tenaamstellen_mogelijk}'
{
  "tenaamstellen_mogelijk": "Nee"
}


EOF

#-EOF

