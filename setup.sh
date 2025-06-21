#!/bin/bash

SCRIPT_DIR="scripts"
NAMES_FILE=".names.json"

declare -A names_map

echo "Welcome to the setup! Please enter friendly names for your scripts."
echo "-----------------------------------------------"

# Loop over scripts folder files
for script in "$SCRIPT_DIR"/*; do
    # Only regular files
    if [ -f "$script" ]; then
        filename=$(basename "$script")
        
        # Ask user for a friendly name
        echo -n "Enter display name for '$filename': "
        read friendly_name
        
        # If empty, fallback to filename
        if [ -z "$friendly_name" ]; then
            friendly_name="$filename"
        fi
        
        # Store in associative array
        names_map["$filename"]="$friendly_name"
    fi
done

# Build JSON content
json_content="{"
first=1
for key in "${!names_map[@]}"; do
    if [ $first -eq 1 ]; then
        first=0
    else
        json_content+=","
    fi
    # Escape quotes for JSON safely
    safe_name=$(echo "${names_map[$key]}" | sed 's/"/\\"/g')
    json_content+="\"$key\":{\"name\":\"$safe_name\"}"
done
json_content+="}"

# Save JSON to hidden file quietly
echo "$json_content" > "$NAMES_FILE"

echo
echo "Setup complete! Friendly names saved successfully."
