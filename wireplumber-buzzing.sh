#!/bin/bash

# File path to the suspend-node.lua script
SCRIPT_PATH="/usr/share/wireplumber/scripts/node/suspend-node.lua"

# Backup the original file
if [ ! -f "$SCRIPT_PATH.bak" ]; then
    echo "Creating a backup of the original script at $SCRIPT_PATH.bak"
    sudo cp "$SCRIPT_PATH" "$SCRIPT_PATH.bak"
fi

# Modify the timeout in the script
echo "Modifying the timeout in $SCRIPT_PATH..."
sudo sed -i 's/tonumber(node.properties\["session.suspend-timeout-seconds"\]) or [0-9]\+/tonumber(node.properties["session.suspend-timeout-seconds"]) or 0/' "$SCRIPT_PATH"

# Restart the WirePlumber service to apply changes
echo "Restarting WirePlumber..."
systemctl --user restart wireplumber

echo "Modification complete! Timeout has been disabled. A backup of the original file is available at $SCRIPT_PATH.bak."

