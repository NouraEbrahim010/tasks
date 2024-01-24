#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 -f DOMAIN_FILE -i ITERATIONS"
    echo "Options:"
    echo "  -f DOMAIN_FILE      Specify the file containing the list of domains"
    echo "  -i ITERATIONS       Specify the number of iterations"
    exit 1
}

# Function to perform subdomain enumeration using amass and subfinder
enumerate_subdomains() {
    local input_file=$1
    local output_file=$2

    # Perform enumeration using amass
    amass enum -dL "$input_file" -o "$output_file.amass.txt"

    # Perform enumeration using subfinder
    subfinder -dL "$input_file" -o "$output_file.subfinder.txt"

    # Combine and sort the results
    cat "$output_file.amass.txt" "$output_file.subfinder.txt" | sort -u > "$output_file"
}

# Parse command line arguments
while getopts "f:i:" opt; do
    case $opt in
        f) DOMAIN_FILE="$OPTARG";;
        i) ITERATIONS="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2; usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage;;
    esac
done

# Check if required options are provided
if [ -z "$DOMAIN_FILE" ] || [ -z "$ITERATIONS" ]; then
    echo "Error: Missing required options."
    usage
fi

# Check if the file containing domains exists
if [ ! -f "$DOMAIN_FILE" ]; then
    echo "Error: Domain file not found. Exiting."
    exit 1
fi

# Perform subdomain enumeration for the specified number of iterations
for ((iteration = 1; iteration <= ITERATIONS; iteration++)); do
    echo "Iteration $iteration: Enumerating subdomains..."
    enumerate_subdomains "$DOMAIN_FILE" "iteration_$iteration"
    DOMAIN_FILE="iteration_$iteration"
done

# Count and display the unique subdomains
total_subdomains=$(cat "$DOMAIN_FILE" | wc -l)
echo "Total Unique Subdomains: $total_subdomains"

# Save the unique subdomains to a file
cat "$DOMAIN_FILE" > "unique_subdomains.txt"

echo "Script completed successfully."
exit 0
