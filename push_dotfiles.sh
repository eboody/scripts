#!/bin/bash

CONFIG_PATH=/home/eran/.config

cd $CONFIG_PATH

# Define an array of file names
file_names=(
  "$CONFIG_PATH/hypr" 
  "$CONFIG_PATH/tmux"
  "$CONFIG_PATH/kitty"
  "$CONFIG_PATH/nvim"
  "$CONFIG_PATH/rsync_exclude.txt"
  "$CONFIG_PATH/starship.toml"
  "$CONFIG_PATH/waybar"
  "$CONFIG_PATH/rofi"
)

# Add each file to git
for file_name in "${file_names[@]}"; do
  git add -f "$file_name"
done

# Commit with current date and time as message
commit_message="Update: $(date +'%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_message"

# Push to your GitHub repository
git push git@github.com:eboody/dotfiles
