#!/bin/bash

set -e

apt-get update
apt-get install minify

readonly INPUT_FILE=".trustinsoft/orig_config.json"
readonly COMMON_OPTIONS='{
   "files": [ "caesar.c", "main.c" ],
   "cpp-extra-args": "-I .",
   "prefix_path": ".."
}'

test -e "$INPUT_FILE" || { echo "$INPUT_FILE not found"; exit 1; }

minify --type js "$INPUT_FILE" \
  | jq --argjson common "$COMMON_OPTIONS" 'map($common + .)' \
  > .trustinsoft/config.json
