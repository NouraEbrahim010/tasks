#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 -d DIRECTORY_PATH"
    echo "Options:"
    echo "  -d DIRECTORY_PATH    Specify the directory to analyze"
    exit 1
}

# Parse command line arguments
while getopts "d:" opt; do
    case $opt in
        d) DIRECTORY_PATH="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2; usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage;;
    esac
done

# Check if required options are provided
if [ -z "$DIRECTORY_PATH" ]; then
    echo "Error: Missing required options."
    usage
fi

# Check if the directory exists
if [ ! -d "$DIRECTORY_PATH" ]; then
    echo "Error: Directory not found. Exiting."
    exit 1
fi

# Analyze files in the specified directory
echo "Analyzing files in $DIRECTORY_PATH..."

for file in "$DIRECTORY_PATH"/*; do
    echo "--------------------------------------------------------"
    echo "File: $file"

    # Display metadata using ExifTool
    echo "Metadata (ExifTool):"
    exiftool "$file"

    # Display information using Mediainfo
    echo "Media Information (Mediainfo):"
    mediainfo "$file"

    # Check for strings in the file
    echo "Strings in the file:"
    strings "$file"

    # Check for network packets using Tcpdump (for pcap files)
    if [[ "$file" == *.pcap ]]; then
        echo "Network Packets (Tcpdump):"
        tcpdump -r "$file"
    fi

    # Additional checks or tools can be added here based on file type

    echo "--------------------------------------------------------"
done

echo "File analysis script completed successfully."
exit 0
