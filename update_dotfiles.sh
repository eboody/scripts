#!/bin/bash

# Define an array of file names
file_names=("~/.config/hypr" "~/.config/tmux" "~/.config/kitty" "~/.config/nvim")

# Add each file to git
for file_name in "${file_names[@]}"; do
  git add "$file_name"
done

# Commit with current date and time as message
commit_message="Update: $(date +'%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_message"

# Push to your GitHub repository
git push git@github.com:eboody/dotfiles

