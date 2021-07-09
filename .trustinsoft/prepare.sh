#!/bin/bash -e

# apt-get update
# apt-get install jq

readonly INPUT_FILE="orig_config.json"
readonly MACHDEPS=(
  x86_32
  x86_64
  gcc_x86_32
  gcc_x86_64
)

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
printf '%s\n' "${results[@]}" | jq '.[]' | jq -s > config.json
