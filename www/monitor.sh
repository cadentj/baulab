#!/bin/bash

# Define the list of remote machines
USER="caden"
MACHINES=("karasuno" "karakuri" "hawaii" "tokyo" "umibozu" "kyoto" "saitama" "osaka" "bippu" "hamada" "andromeda" "kobe" "macondo" "naoshima")

# Define your password (input securely if desired)
PASSWORD="nnsight"

# Define output file
OUTPUT_FILE="/share/u/caden/www/cluster.txt"

# Timeout duration for SSH commands
SSH_TIMEOUT=10

# Function to fetch nvidia-smi output for a single machine
fetch_status() {
    local machine=$1
    local temp_file="${TEMP_DIR}/${machine}_nvidia_smi.txt"

    echo "Fetching nvidia-smi output from $machine..."
    sshpass -p "$PASSWORD" ssh -o ConnectTimeout=$SSH_TIMEOUT "$USER@$machine" "nvidia-smi" > "$temp_file" 2>/dev/null
    
    if [[ $? -eq 0 ]]; then
        echo "Success: Output saved for $machine"
    else
        echo "Error: Could not retrieve nvidia-smi output from $machine" > "$temp_file"
    fi
}

# Temporary directory to store intermediate outputs
TEMP_DIR=$(mktemp -d)

# Ensure the output file is cleared before starting
> "$OUTPUT_FILE"

# Export necessary variables and functions for loop execution
export TEMP_DIR PASSWORD SSH_TIMEOUT
export -f fetch_status

# Run the fetch_status function for all machines
echo "Starting execution..."
for machine in "${MACHINES[@]}"; do
    fetch_status "$machine" &
done
wait

# Combine all outputs into a single file
echo "Aggregating results..."
{
    for machine in "${MACHINES[@]}"; do
        echo "<|$machine|>"
        cat "${TEMP_DIR}/${machine}_nvidia_smi.txt"
        echo "</|$machine|>"
    done
} > "$OUTPUT_FILE"

# Display the unified output
cat "$OUTPUT_FILE"

# Clean up temporary files
rm -rf "$TEMP_DIR"
