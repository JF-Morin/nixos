#!/usr/bin/env bash

# Parse sink IDs and find the current default from wpctl status
sinks_section=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep -v 'Sinks:\|Sources:')

mapfile -t sink_ids < <(echo "$sinks_section" | grep -oE '[0-9]+\.' | tr -d '.')
current_id=$(echo "$sinks_section" | grep '\*' | grep -oE '[0-9]+\.' | tr -d '.')

# Find next sink, wrapping around
next_id=""
found=false
for id in "${sink_ids[@]}"; do
    if $found; then
        next_id=$id
        break
    fi
    [ "$id" = "$current_id" ] && found=true
done
[ -z "$next_id" ] && next_id="${sink_ids[0]}"

wpctl set-default "$next_id"
