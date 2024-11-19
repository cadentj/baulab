#!/bin/bash

# Define the list of remote machines
USER="caden"
MACHINES=("karasuno" "karakuri" "hawaii" "tokyo" "umibozu" "kyoto" "saitama" "osaka" "bippu" "hamada")

# Define your password (input securely if desired)
PASSWORD="nnsight"

# Temporary directory to store outputs
TEMP_DIR=$(mktemp -d)
OUTPUT_FILE="${TEMP_DIR}/nvidia_smi_statuses.txt"

# Function to fetch nvidia-smi output for a single machine
fetch_status() {
    local machine=$1
    local temp_file="${TEMP_DIR}/${machine}_nvidia_smi.txt"

    echo "Fetching nvidia-smi output from $machine..."
    sshpass -p "$PASSWORD" ssh -o ProxyJump=login.khoury.northeastern.edu "$USER@$machine" "nvidia-smi" > "$temp_file" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        echo "Success: Output saved for $machine"
    else
        echo "Error: Could not retrieve nvidia-smi output from $machine" > "$temp_file"
    fi
}

# Export necessary variables and functions for parallel execution
export TEMP_DIR PASSWORD
export -f fetch_status

# Run the fetch_status function for all machines in parallel
echo "Starting parallel execution..."
parallel -j ${#MACHINES[@]} fetch_status ::: "${MACHINES[@]}"

# Combine all outputs into a single file
echo "Aggregating results..."
{
    for machine in "${MACHINES[@]}"; do
        echo "======== $machine ========"
        cat "${TEMP_DIR}/${machine}_nvidia_smi.txt"
        echo
    done
} > "$OUTPUT_FILE"

# Display the unified output
cat "$OUTPUT_FILE"

# Clean up temporary files
rm -rf "$TEMP_DIR"
