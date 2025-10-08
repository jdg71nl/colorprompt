#!/bin/bash

#: # default type=commonjs : 
#: > npm init -y
#: > cat package.json
#: {
#:   "name": "sqlite",
#:   "version": "1.0.0",
#:   "description": "",
#:   "main": "index.js",
#:   "scripts": {
#:     "test": "echo \"Error: no test specified\" && exit 1"
#:   },
#:   "keywords": [],
#:   "author": "",
#:   "license": "ISC",
#:   "type": "commonjs"
#: }
#: > jq --arg type module '.type = $type' package.json > package.json.tmp && mv package.json.tmp package.json
#: {
#:   "name": "sqlite",
#:   "version": "1.0.0",
#:   "description": "",
#:   "main": "index.js",
#:   "scripts": {
#:     "test": "echo \"Error: no test specified\" && exit 1"
#:   },
#:   "keywords": [],
#:   "author": "",
#:   "license": "ISC",
#:   "type": "module"
#: }

set -e

#
[ -f package.json ] && echo "# Exit: file 'package.json' already exists. Consider manual update (see comments in this .sh-script)." && exit 1

#
echo "# > npm init -y "
npm init -y

#
echo "# > jq --arg type module '.type = \$type' package.json > package.json.tmp && mv package.json.tmp package.json "
jq --arg type module '.type = $type' package.json > package.json.tmp && mv package.json.tmp package.json

#
echo
echo "# > cat package.json "
cat package.json

exit 0
#-eof

