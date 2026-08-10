#!/bin/bash
#= printhint_jq.sh

cat <<EOF

# info:
# https://jqlang.org/
# https://formulae.brew.sh/formula/jq
# https://www.devtoolsdaily.com/cheatsheets/jq/
# https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4  =  @olih/jq-cheetsheet.md
# https://cht.sh/jq

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

# select property of array entry 0
> curl --silent 'https://opendata.rdw.nl/resource/m9d7-ebf2.json?kenteken=53RDBL' | jq '.[0] | {tenaamstellen_mogelijk}'
{
  "tenaamstellen_mogelijk": "Nee"
}

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

#
> cat apps/api/package.json | jq '{ nx: { targets: (.nx.targets | { "migration-generate" }) } }'
{
  "nx": {
    "targets": {
      "migration-generate": {
        "executor": "nx:run-commands",
        "options": {
          "command": "TSX_TSCONFIG_PATH=tsconfig.base.json node --import tsx ./node_modules/typeorm/cli.js migration:generate apps/api/src/migrations/{args.name} -d apps/api/src/data-source.ts"
        }
      }
    }
  }
}

> cat apps/api/package.json | jq '{ nx: { targets: { "migration-generate" : { options: (.nx.targets."migration-generate".options | { command }) } } } }'
{
  "nx": {
    "targets": {
      "migration-generate": {
        "options": {
          "command": "TSX_TSCONFIG_PATH=tsconfig.base.json node --import tsx ./node_modules/typeorm/cli.js migration:generate apps/api/src/migrations/{args.name} -d apps/api/src/data-source.ts"
        }
      }
    }
  }
}


EOF

#-EOF

