#!/bin/bash

# Define the repository and its API URL for latest commit
REPO_URL="https://github.com/eboody/dotfiles"
API_URL="https://api.github.com/repos/eboody/dotfiles/commits/main"

# Path to the file storing the last update's commit hash
HASH_FILE="/home/eran/.config/dotfiles_hash.txt"

# Fetch the latest commit hash from the repository
LATEST_HASH=$(curl -s "$API_URL" | grep sha | head -1 | awk '{print $2}' | sed 's/[",]//g')

# Read the last known hash, if the file exists
if [ -f "$HASH_FILE" ]; then
    KNOWN_HASH=$(cat "$HASH_FILE")
else
    touch $HASH_FILE
    KNOWN_HASH=""
fi

# Compare the hashes, clone and update if they differ, or if the hash file doesn't exist
if [ "$LATEST_HASH" != "$KNOWN_HASH" ]; then
    echo "New updates detected. Updating local configurations..."

    # Clone, copy, and update operations as before
    CLONE_DIR="/tmp/dotfiles"
    git clone "$REPO_URL" "$CLONE_DIR"
    cp -r "$CLONE_DIR/kitty" ~/.config/
    cp -r "$CLONE_DIR/hypr" ~/.config/
    cp -r "$CLONE_DIR/waybar" ~/.config/
    cp -r "$CLONE_DIR/tmux" ~/.config/
    cp -r "$CLONE_DIR/nvim" ~/.config/
    cp -r "$CLONE_DIR/rofi" ~/.config/
    cp "$CLONE_DIR/starship.toml" ~/.config/starship.toml
    cp "$CLONE_DIR/rsync_exclude" ~/.config/rsync_exclude.txt

    rm -rf "$CLONE_DIR"

    # Update the hash file with the latest hash
    echo "$LATEST_HASH" > "$HASH_FILE"



    echo "Configuration files have been successfully updated."
else
    echo "Your configurations are up-to-date. No update is necessary."
fi

    sed -i 's/linux_display_server x11/linux_display_server wayland/' ~/.config/kitty/kitty.conf
    sed -i 's/font_size 20/font_size 16/' ~/.config/kitty/kitty.conf

cd $HOME/scripts
git pull origin main
