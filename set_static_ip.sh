#!/bin/bash

# ==============================================================================
# Script to set a static IP address on Raspberry Pi OS (using dhcpcd)
# ==============================================================================
#
# This script will guide you through configuring a network interface to use
# a static IP address, a gateway, and DNS servers.
#
# ALWAYS RUN WITH SUDO: sudo ./set_static_ip.sh
#
# ==============================================================================

# --- SCRIPT LOGIC (do not modify below this line) ---

# 1. Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: This script must be run with root privileges."
  echo "Please run it using 'sudo ./set_static_ip.sh'"
  exit 1
fi

# 2. Gather information from the user
echo "--- Interactive Static IP Configuration ---"
echo "Please provide the following details. Press Enter to accept the default values in brackets."
echo ""

# Ask for the network interface
read -p "Enter the network interface [eth0]: " -i "eth0" INTERFACE

# Ask for the static IP address
read -p "Enter the desired static IP address (e.g., 192.168.1.10/24) [192.168.1.10/24]: " -i "192.168.1.10/24" STATIC_IP

# Ask for the gateway IP address
read -p "Enter your router/gateway IP address [192.168.1.1]: " -i "192.168.1.1" GATEWAY_IP

# Ask for DNS servers
read -p "Enter DNS servers (space-separated) [192.168.1.1 1.1.1.1]: " -i "192.168.1.1 1.1.1.1" DNS_SERVERS

# 3. Configuration file
CONFIG_FILE="/etc/dhcpcd.conf"

# 4. Display the configuration and ask for confirmation
echo ""
echo "--- Configuration Summary ---"
echo "The following settings will be applied to the interface '$INTERFACE':"
echo "   IP Address: $STATIC_IP"
echo "   Gateway:    $GATEWAY_IP"
echo "   DNS Servers:  $DNS_SERVERS"
echo ""
echo "This will append the configuration to: $CONFIG_FILE"
echo ""
read -p "Do you want to proceed? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Operation cancelled."
  exit 0
fi

# 5. Create a backup of the original configuration file
BACKUP_FILE="$CONFIG_FILE.bak.$(date +%F-%T)"
echo -e "\nℹ️  Creating a backup of the original configuration file at: $BACKUP_FILE"
cp "$CONFIG_FILE" "$BACKUP_FILE"
if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to create backup file. Aborting."
    exit 1
fi

# 6. Append the new configuration to the file
# A "Here Document" (<<EOF) is used to write the lines.
echo "✍️  Applying configuration..."
cat <<EOF >> "$CONFIG_FILE"

# --- Static IP configuration added by script on $(date) ---
interface $INTERFACE
    static ip_address=$STATIC_IP
    static routers=$GATEWAY_IP
    static domain_name_servers=$DNS_SERVERS
EOF

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to write to the configuration file. Aborting."
    # Restore the backup in case of a write error
    mv "$BACKUP_FILE" "$CONFIG_FILE"
    exit 1
fi

# 7. Final message and instructions
echo ""
echo "✅ Configuration applied successfully!"
echo "The changes will take effect after a system reboot."
echo ""
read -p "Would you like to reboot the system now? (y/n): " reboot_confirm
if [[ "$reboot_confirm" == "y" || "$reboot_confirm" == "Y" ]]; then
  echo "Rebooting now..."
  reboot
else
  echo "Please reboot your Raspberry Pi manually with 'sudo reboot' to apply the changes."
fi

exit 0
