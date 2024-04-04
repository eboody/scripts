#!/bin/bash

# Define the directory and repository URL
THEME_DIR="$HOME/.config/wofi/dracula"
REPO_URL="https://github.com/dracula/wofi.git"

# Check if the theme directory exists
if [ ! -d "$THEME_DIR" ]; then
    echo "Dracula theme for Wofi not found. Installing..."
    mkdir -p "$THEME_DIR"
    git clone "$REPO_URL" "$THEME_DIR"
else
    echo "Dracula theme for Wofi found. Checking for updates..."
    cd "$THEME_DIR" && git pull
fi

# Ensure the style.css is in the correct location
cp "$THEME_DIR/style.css" "$HOME/.config/wofi/style.css"

echo "Dracula theme for Wofi installation/update complete."
