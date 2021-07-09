#!/bin/bash

set -e

apt-get update
apt-get install minify

readonly INPUT_FILE=".trustinsoft/orig_config.json"
readonly MACHDEPS=(
  x86_32
  x86_64
  gcc_x86_32
  gcc_x86_64
)

test -e "$INPUT_FILE" || { echo "$INPUT_FILE not found"; exit 1; }

results=()

for machdep in "${MACHDEPS[@]}"; do
  # Use "minify --type js" to pre-process comments. Then, for each
  # object, add the "machdep" field and update the "name" field.
  res=$(minify --type js "$INPUT_FILE" | \
        jq \
          --arg mach "$machdep" \
          'map(. + { "machdep": $mach }) |
           to_entries |
           map(
             if has("name") then
               .value + { "name": (.value.name + " - " + $mach) }
             else
               .value + { "name": ("Test " + (.key + 1 | tostring) + " - " + $mach) } end)' \
          "$INPUT_FILE")
  results+=( "$res" )
done

# Gather all configuration objects into a single one.
res="$(printf '%s\n' "${results[@]}" | jq '.[]')"
res="$(echo "$res" | jq -s '.')"
echo "$res" > .trustinsoft/config.json
