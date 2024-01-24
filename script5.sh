#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 [-l LENGTH] [-c COMPLEXITY]"
    echo "Options:"
    echo "  -l LENGTH          Specify the length of the password (default: 12)"
    echo "  -c COMPLEXITY      Specify the complexity of the password (easy, medium, hard)"
    exit 1
}

# Function to generate a random password
generate_password() {
    local length=$1
    tr -dc '[:alnum:]' < /dev/urandom | fold -w "$length" | head -n 1
}

# Parse command line arguments
while getopts "l:c:" opt; do
    case $opt in
        l) LENGTH="$OPTARG";;
        c) COMPLEXITY="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2; usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage;;
    esac
done

# Set default values if not provided
LENGTH=${LENGTH:-12}
COMPLEXITY=${COMPLEXITY:-medium}

# Validate complexity option
case "$COMPLEXITY" in
    easy|medium|hard) ;;
    *) echo "Error: Invalid complexity option. Use easy, medium, or hard." >&2; usage;;
esac

# Generate password based on complexity
case "$COMPLEXITY" in
    easy) PASSWORD=$(generate_password "$LENGTH");;
    medium) PASSWORD=$(generate_password "$LENGTH" | sed 's/[^a-zA-Z0-9]//g');;
    hard) PASSWORD=$(generate_password "$LENGTH" | tr -dc '[:graph:]');;
esac

# Display the generated password
echo "Generated Password: $PASSWORD"

exit 0
