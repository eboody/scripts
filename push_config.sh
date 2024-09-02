#!/bin/bash

CONFIG_PATH=/home/eran/.config
SCRIPT_PATH=/home/eran/scripts

cd $CONFIG_PATH

if [ -d ".git" ]; then
    echo "Directory is already initialized with git."
else
    echo "Directory is not initialized with git."
    git init
    git branch -M main
    git config pull.rebase false
    git branch --set-upstream-to=origin/main main
    git remote add origin git@github.com:eboody/dotfiles
fi

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
  "$CONFIG_PATH/qutebrowser"
)

# Add each file to git
for file_name in "${file_names[@]}"; do
  git add "$file_name"
done

# Remove tmux/plugins directory from Git index
git rm --cached -r -f "$CONFIG_PATH/tmux/plugins"

# Commit with current date and time as message
commit_message="Update: $(date +'%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_message"

# Push to your GitHub repository
git push origin main

cd $SCRIPT_PATH

git add .

commit_message="Update: $(date +'%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_message"
git push origin main
