#!/bin/bash

# Define the path to the Obsidian desktop file
DESKTOP_FILE="/usr/share/applications/obsidian.desktop"

# Check if the file exists
if [ ! -f "$DESKTOP_FILE" ]; then
    echo "Error: Obsidian desktop file not found at $DESKTOP_FILE"
    exit 1
fi

# Create a backup of the original file
cp "$DESKTOP_FILE" "${DESKTOP_FILE}.bak"
echo "Backup created: ${DESKTOP_FILE}.bak"

# Modify the Exec line to include --disable-gpu
sed -i 's/^Exec=obsidian/Exec=obsidian --disable-gpu/' "$DESKTOP_FILE"

# Check if the modification was successful
if grep -q "Exec=obsidian --disable-gpu" "$DESKTOP_FILE"; then
    echo "Successfully modified $DESKTOP_FILE to include --disable-gpu"
else
    echo "Error: Failed to modify $DESKTOP_FILE"
    exit 1
fi

echo "Obsidian desktop file has been updated. You may need to restart your desktop environment for changes to take effect."
