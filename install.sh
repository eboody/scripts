#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a package if it's not already installed
install_if_not_exists() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        log "Installing $1..."
        sudo pacman -S --needed --noconfirm "$1" || { log "Failed to install $1"; exit 1; }
    else
        log "$1 is already installed."
    fi
}

# Function to install an AUR package if it's not already installed
install_aur_if_not_exists() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        log "Installing $1 from AUR..."
        paru -S --needed --noconfirm "$1" || { log "Failed to install $1"; exit 1; }
    else
        log "$1 is already installed."
    fi
}

# List of official packages to be installed
official_packages=(
    vim
    libinput
    interception-tools
    libevdev
    glibc
    git
    kitty
    gcc
    rustup
    gimp
    wget
    pavucontrol
    less
    openssl
    inkscape
    reflector
    sox
    deno
    qutebrowser
    thunderbird
    etcher-bin
    feh
    jq
    lsof
    tldr
    postgresql
    psql
    redis
    tmux
    tree
    ufw
    virtualbox
    virtualbox-host-modules-arch
    wofi
)

# List of AUR packages to be installed
aur_packages=(
    ripgrep
    deluge
    starship
    wl-clipboard
    brightnessctl
    yaml-cpp
    waybar
    hyprpaper
    eza
    obsidian
    nerd-fonts
    unzip
    adwaita-dark
    docker-compose
    zoom
    discord
    slack
    obs-studio
    blueberry
    deluge
    authy
    speech-dispatcher
    spotify-snapstore
    extra/rofi-wayland
    # rofi-lbonn-wayland-git
    rofi-emoji-git
    ttf-twemoji
    wtype
    zoxide
    bat
    fzf
    p7zip
    npm
    nodejs
    wev
    grim
    slurp
    rsync
    figma-linux
    ttf-twemoji
    entr
    mpv
    nwg-look
    ant-dracula-theme-git
    act
    dracula-icons-git
    1password-cli
    ungoogled-chromium-bin
    plocate
    fx
    google-earth-pro
)

# Update the system
log "Updating the system..."
sudo pacman -Syu || { log "System update failed"; exit 1; }

# Install official packages
for package in "${official_packages[@]}"; do
    install_if_not_exists "$package"
done

# Check if SSHD service is running
if ! systemctl is-active --quiet sshd; then
    log "Starting and enabling SSHD service..."
    sudo systemctl start sshd || { log "Failed to start SSHD service"; exit 1; }
    sudo systemctl enable sshd || { log "Failed to enable SSHD service"; exit 1; }
else
    log "SSHD is already running."
fi

# Configure git
log "Configuring git..."
git config --global user.email "eboodnero@gmail.com"
git config --global user.name "Eran Boodnero"

# Install Rust stable
log "Installing Rust stable..."
rustup install stable || { log "Failed to install Rust stable"; exit 1; }

# Install paru if it's not already installed
if ! command_exists paru; then
    log "Installing Paru..."
    git clone https://aur.archlinux.org/paru.git || { log "Failed to clone paru repository"; exit 1; }
    (cd paru && makepkg -si) || { log "Failed to install paru"; exit 1; }
    rm -rf paru
else
    log "Paru is already installed."
fi

# Install AUR packages
for package in "${aur_packages[@]}"; do
    install_aur_if_not_exists "$package"
done

# Run additional setup scripts
scripts=(
    "docker_setup.sh"
    "pull_config.sh"
    "tmux_tpm.sh"
    "rofi_theme.sh"
    "aliases.sh"
    "update_dns.sh"
    "laptop_setup.sh"
)

for script in "${scripts[@]}"; do
    if [ -f "$HOME/scripts/$script" ]; then
        log "Running $script..."
        sh "$HOME/scripts/$script" || { log "Failed to run $script"; exit 1; }
    else
        log "Warning: $script not found in $HOME/scripts/"
    fi
done

# Set up 1password ssh agent
grep -q 'export SSH_AUTH_SOCK=~/.1password/agent.sock' ~/.bashrc || echo 'export SSH_AUTH_SOCK=~/.1password/agent.sock' >> ~/.bashrc

# Install Cargo packages
cargo_packages=(
    "typeshare-cli"
    "cargo-watch"
    "cargo-script"
    "cargo-run-script"
    "sccache"
)

for package in "${cargo_packages[@]}"; do
    if ! cargo install --list | grep -q "^$package v"; then
        log "Installing $package..."
        cargo install "$package" || { log "Failed to install $package"; exit 1; }
    else
        log "$package is already installed."
    fi
done

# Create a gitignore that ignores everything in .config
[ -f ~/.config/.gitignore ] || echo "*" > "$HOME/.config/.gitignore"

# Set timezone and hardware clock
log "Setting timezone and hardware clock..."
sudo timedatectl set-timezone America/Los_Angeles || { log "Failed to set timezone"; exit 1; }
sudo hwclock --systohc --utc || { log "Failed to set hardware clock"; exit 1; }

log "Installation and setup completed successfully."
