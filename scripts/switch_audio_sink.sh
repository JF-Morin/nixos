#!/usr/bin/env bash
# Script: get_wpctl_sinks_raw.sh
# Description: Executes 'wpctl status -k' and extracts only the raw lines 
#              listing the audio sinks, excluding the header and footer lines.

# --- Configuration ---
WPCTL_CMD="wpctl"
WPCTL_ARGS="status -k"
# --- End Configuration ---

# Function to display an error message and exit
#function error_exit() {
#    echo -e "\033[0;31mERROR:\033[0m $1" >&2
#    exit 1
#}
#
## Check if wpctl is installed
#if ! command -v $WPCTL_CMD &> /dev/null; then
#    error_exit "$WPCTL_CMD could not be found. Please ensure PipeWire is installed."
#fi
#
#echo "--- Filtered Audio Sinks ---"
#echo "--- Def | ID | Nickname | Volume ---"
#
## Use awk to select the line range (between Sinks and Sources), 
## filter out non-device lines, and then extract the required fields (ID, Nickname, Volume) 
## for formatted output.
#
#$WPCTL_CMD $WPCTL_ARGS | awk '
## Set a flag when we enter the Sinks block
#/├─ Sinks:/ { in_sinks = 1; next }
#
## Unset the flag when we leave the Sinks block
#/├─ Sources:/ { in_sinks = 0; next }
#
## Only process lines within the Sinks block that contain a device ID
#in_sinks && $0 ~ /[0-9]+\./ {
#    
#    # 0. Determine Default Status
#    # Check if the line contains an asterisk; set is_default to "*" or a space
#    is_default = " ";
#    if ($0 ~ /\*/) {
#        is_default = "*";
#    }
#    
#    # 1. Extract ID: find the number and remove the trailing dot
#    match($0, /[0-9]+\./);
#    id = substr($0, RSTART, RLENGTH - 1);
#
#    # 2. Extract Volume: find the text inside [vol: ...]
#    match($0, /\[vol: [^\]]+\]/);
#    volume = substr($0, RSTART, RLENGTH);
#
#    # 3. Extract Nickname: everything between the ID and the Volume.
#    
#    # Find the position where the ID ends (including the dot)
#    id_end_pos = index($0, id ".");
#    
#    # Find the position where the volume starts
#    vol_start_pos = index($0, volume);
#    
#    # Start: 2 characters after the ID dot (to skip the dot and the following space)
#    nickname_start = id_end_pos + length(id) + 2;
#    # Length: calculated from vol_start minus the nickname start position
#    nickname_len = vol_start_pos - nickname_start;
#    
#    # Extract the raw nickname text
#    nickname_raw = substr($0, nickname_start, nickname_len);
#    
#    # Trim leading/trailing whitespace from the nickname
#    gsub(/^[[:space:]]+|[[:space:]]+$/, "", nickname_raw);
#
#    # 4. Print the result with the new Default column
#    printf "%s | %s | %s | %s\n", is_default, id, nickname_raw, volume;
#}
#'
#
#echo "--- End of Filtered Sinks ---"#

# --- 2. Extract ID of the First Non-Default Sink into a variable ---

# Use awk to find the ID of the first sink that is not marked as default.
# The result is captured using command substitution $().
FIRST_NON_DEFAULT_SINK_ID=$($WPCTL_CMD $WPCTL_ARGS | awk '
# Set a flag when we enter the Sinks block
/├─ Sinks:/ { in_sinks = 1; next }

# Unset the flag when we leave the Sinks block
/├─ Sources:/ { in_sinks = 0; next }

# Only process lines within the Sinks block that contain a device ID
in_sinks && $0 ~ /[0-9]+\./ {
    
    # Check if the line does NOT contain the asterisk (*)
    if ($0 !~ /\*/) {
        
        # 1. Extract ID: find the number and remove the trailing dot
        match($0, /[0-9]+\./);
        id = substr($0, RSTART, RLENGTH - 1);
        
        # Print the ID and immediately stop processing
        print id;
        exit; # Exit awk immediately after finding the first non-default ID
    }
}
')

# Set the new output volume ID

wpctl set-default $FIRST_NON_DEFAULT_SINK_ID

exit 0
