#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 -w WARP_KEY -o OPENVPN_CONFIG_FILE"
    echo "Options:"
    echo "  -w WARP_KEY               Cloudflare Warp key"
    echo "  -o OPENVPN_CONFIG_FILE    OpenVPN configuration file"
    exit 1
}

# Parse command line arguments
while getopts "w:o:" opt; do
    case $opt in
        w) WARP_KEY="$OPTARG";;
        o) OPENVPN_CONFIG_FILE="$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2; usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage;;
    esac
done

# Check if required options are provided
if [ -z "$WARP_KEY" ] || [ -z "$OPENVPN_CONFIG_FILE" ]; then
    echo "Error: Missing required options."
    usage
fi

# Step 1: Connect using Warp
echo "Connecting to Warp..."
warp-cli connect $WARP_KEY

# Check if an IP has been assigned
warp_ip=$(curl -s https://ifconfig.me/ip)
if [ -z "$warp_ip" ]; then
    echo "Error: Failed to get Warp IP. Exiting."
    exit 1
fi
echo "Warp IP: $warp_ip"

# Step 2: Connect using OpenVPN in the background
echo "Connecting to OpenVPN..."
openvpn --config "$OPENVPN_CONFIG_FILE" --daemon

# Check connection if an IP is assigned
openvpn_ip=$(curl -s https://ifconfig.me/ip)
if [ -z "$openvpn_ip" ]; then
    echo "Error: Failed to get OpenVPN IP. Exiting."
    exit 1
fi
echo "OpenVPN IP: $openvpn_ip"

# Step 3: Second check - Ping 10.10.10.10
echo "Performing ping test..."
ping_result=$(ping -c 3 10.10.10.10)
echo "$ping_result"

# Step 4: Disconnect from Warp
echo "Disconnecting from Warp..."
warp-cli disconnect

# Additional steps or customizations can be added here

echo "VPN connection script completed successfully."
exit 0

