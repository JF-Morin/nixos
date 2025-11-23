#!/usr/bin/env bash

# --- Function to extract and process the Sink IDs ---
get_next_sink_id() {
    # 1. Get the raw output
    STATUS_OUTPUT=$(wpctl status -k)

    # 2. Extract the list of all Sink IDs
    #    - Start search after "Sinks:"
    #    - Stop search when a line starts with "├─" or "└─" that is NOT part of "Sinks:"
    #    - Extract only the digits (the ID) using a regex match.
    ALL_IDS=$(echo "$STATUS_OUTPUT" | \
              awk '/Sinks:/ {p=1; next} 
                   /^[[:space:]]*(├─|└─)/ {p=0} 
                   p==1 && /^[[:space:]]*│[[:space:]]*(\*)?[[:space:]]*[0-9]+/ {
                       # Match and print the first sequence of digits (the ID)
                       match($0, /[0-9]+/, id_arr);
                       print id_arr[0];
                   }' | \
              sort -n)

    # 3. Find the ID of the currently selected Sink (the one with '*')
    # **ADJUSTED COMMAND**
    CURRENT_ID=$(echo "$STATUS_OUTPUT" | \
                 awk '/Sinks:/ {p=1; next} 
                      p==1 && /\*/ {
                          # Match and print the first sequence of digits (the ID)
                          match($0, /[0-9]+/, id_arr);
                          print id_arr[0];
                          exit;
                      }')

    # --- Validation ---
    if [[ -z "$ALL_IDS" || -z "$CURRENT_ID" ]]; then
        echo "Error: Could not retrieve Sink IDs or the current active Sink ID." >&2
        return 1
    fi

    # --- Looping Logic ---
    # Convert the list of IDs into a Bash array
    ID_ARRAY=($ALL_IDS)
    # Get the total number of IDs
    NUM_IDS=${#ID_ARRAY[@]}

    # Find the index of the current ID in the array
    CURRENT_INDEX=-1
    for i in "${!ID_ARRAY[@]}"; do
        if [[ "${ID_ARRAY[$i]}" == "$CURRENT_ID" ]]; then
            CURRENT_INDEX=$i
            break
        fi
    done

    if [[ "$CURRENT_INDEX" -eq -1 ]]; then
        echo "Error: Current ID '$CURRENT_ID' not found in the list of available IDs." >&2
        return 1
    fi

    # Calculate the index of the next ID, using modulo to loop back to 0
    NEXT_INDEX=$(((CURRENT_INDEX + 1) % NUM_IDS))

    # The Next ID is the value at the calculated index
    NEXT_ID=${ID_ARRAY[$NEXT_INDEX]}

    # Output the results
    #echo "Current Sink ID (*): $CURRENT_ID"
    #echo "Next Sink ID (Looping): $NEXT_ID"
    #echo ""
    #echo "$NEXT_ID" # Print the ID alone for script chaining/use
    echo $NEXT_ID
}

# --- Main execution ---
# Store the next ID and display the status
RESULT=$(get_next_sink_id)
echo "$RESULT"
wpctl set-default $RESULT

if [[ $? -eq 0 ]]; then
    NEXT_SINK_ID=$(echo "$RESULT" | tail -n 1) # Get the last line (the ID)
    
    # Optional: Uncomment the lines below to automatically switch the sink
    # echo "Switching default sink to ID $NEXT_SINK_ID..."
    # wpctl set-default $NEXT_SINK_ID
fi
