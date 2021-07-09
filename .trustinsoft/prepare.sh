#!/bin/bash -e

# apt-get update
# apt-get install jq

readonly INPUT_FILE=".trustinsoft/orig_config.json"
readonly MACHDEPS=(
  x86_32
  x86_64
  gcc_x86_32
  gcc_x86_64
)

test -e "$INPUT_FILE" || { echo "$INPUT_FILE not found."; exit 1; }

results=()

for machdep in "${MACHDEPS[@]}"; do
  # Add the "machdep" field to each object and update the "name" field
  # if it exists
  res="$(jq \
          --arg mach "$machdep" \
          'map(. + { "machdep": $mach }) |
           map(if has("name") then . + { "name": (.name + " - " + $mach) } else . end)' \
          "$INPUT_FILE")"
  results+=( "$res" )
done

# Gather all configuration objects into a single one.
touch .trustinsoft/config.json
printf '%s\n' "${results[@]}" | jq '.[]' | jq -s > .trustinsoft/config.json
