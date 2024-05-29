#!/bin/bash

# Function to check if a line exists in .bashrc
line_exists() {
    grep -Fxq "$1" ~/.bashrc
}

# Define lines to be added
lines_to_add=(
    'alias ls="eza --icons --git"'
    'alias cat="bat"'
    'alias cw="cargo watch -c -q -w src/ -x \"run\" -i \"src/templates\" -i \"src/public\" "'
    'alias ct="cargo watch -c -q -w tests/ -x \"test -q quick_dev -- --nocapture\""'
    'alias clippy="cargo clippy -- -W clippy::pedantic -W clippy::nursery -W clippy::unwrap_used"'
    'alias brc="nvim ~/.bashrc"'
    'alias sb="source ~/.bashrc"'
    'alias la="eza -l --icons --git -a"'
    'alias tree="eza --tree --icons"'
    'alias thunderstorm="mpv --loop ~/Music/thunderstorm.flac"'
    'alias ehyp="nvim ~/.config/hypr/hyprland.conf"'
    'alias envim="nvim ~/.config/nvim"'
    'alias obs="nvim ~/documents/notes/$(date +\"%m-%d-%Y\").md"'
    'alias ein="nvim ~/scripts/install.sh"'
    'alias in="sh ~/scripts/install.sh"'
    'alias pushconf="sh ~/scripts/push_config.sh"'
    'alias roci="ssh eran@therocinante.hopto.org"'
    'export SSH_AUTH_SOCK=~/.1password/agent.sock'
    'alias logout="pkill -KILL -u $USER"'
    'alias rsync="rsync --exclude-from=/home/eran/.config/rsync_exclude.txt"'
    'alias ptree="tree -I \"target|node_modules\""'
    'alias cd="z"'
    'eval "$(starship init bash)"'
    'source ~/scripts/zoxide.sh'
    'alias mirrors="sudo reflector --verbose --latest 10 --sort rate --save /etc/pacman.d/mirrorlist"'
    'export EDITOR="nvim"'
)


# Function to check if a line already exists in .bashrc
line_exists() {
    grep -Fxq "$1" ~/.bashrc
}

# Loop through lines and add to .bashrc if they don't exist
for line in "${lines_to_add[@]}"; do
    if ! line_exists "$line"; then
        echo "$line" >> ~/.bashrc
        echo "Added: $line"
    else
        echo "Skipped (already exists): $line"
    fi
done

# Source .bashrc to reflect changes
source ~/.bashrc
echo ".bashrc updated and sourced."

