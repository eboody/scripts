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
)

cd $HOME


# Update the system
sudo pacman -Syu

# Install official packages
sudo pacman -S --needed --noconfirm "${official_packages[@]}"

# Check if SSHD service is running
if systemctl is-active --quiet sshd; then
    echo "SSHD is already running."
else
    # Starting the SSHD service
    echo "Starting the SSHD (OpenSSH Daemon) service..."
    sudo systemctl start sshd
    echo "SSHD service started."

    # Enabling the SSHD service to start on boot
    echo "Enabling the SSHD service to start on boot..."
    sudo systemctl enable sshd
    echo "SSHD service enabled on boot."
fi

git config --global user.email "eboodnero@gmail.com"
git config --global user.name "Eran Boodnero"

rustup install stable

# Function to check if paru is already installed
check_if_installed() {
    if command -v paru &> /dev/null
    then
        echo "Paru is already installed."
        return 0
    else
        return 1
    fi
}

# Install paru if it's not already installed
if ! check_if_installed; then
    echo "Installing Paru..."

    # Clone the Paru package from AUR
    git clone https://aur.archlinux.org/paru.git

    # Install Paru
    cd paru
    makepkg -si

    # Go back to the previous directory
    cd ..

    # Cleanup: Remove the cloned directory
    echo "Cleaning up..."
    rm -rf paru

    echo "Paru installation complete."
else
    echo "Skipping installation."
fi

# Install AUR packages
paru -Sy --needed --noconfirm "${aur_packages[@]}"

sh $HOME/scripts/docker_setup.sh
sh $HOME/scripts/pull_config.sh
sh $HOME/scripts/tmux_tpm.sh
sh $HOME/scripts/rofi_theme.sh
sh $HOME/scripts/aliases.sh
sh $HOME/scripts/update_dns.sh
sh $HOME/scripts/laptop_setup.sh
# sh $HOME/scripts/emojis.sh

# Function to check if 1Password is already installed
check_if_installed() {
    if command -v 1password &> /dev/null
    then
        echo "1Password is already installed."
        return 0
    else
        return 1
    fi
}

# Install 1Password if it's not already installed
if ! check_if_installed; then
    echo "Installing 1Password..."

    # Get the 1Password signing key
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import

    # Clone the 1Password package from AUR
    git clone https://aur.archlinux.org/1password.git

    # Install 1Password
    cd 1password
    makepkg -si

    # Go back to the previous directory
    cd ..

    # Cleanup: Remove the cloned directory
    echo "Cleaning up..."
    rm -rf 1password

    echo "1Password installation complete."
else
    echo "Skipping installation."
fi

# set up 1password ssh agent
grep -q 'export SSH_AUTH_SOCK=~/.1password/agent.sock' ~/.bashrc || echo 'export SSH_AUTH_SOCK=~/.1password/agent.sock' >> ~/.bashrc

# Function to check if a Cargo package is installed
is_installed() {
  cargo install --list | grep -q "^$1 v"
}

# Array of packages to be installed
packages=(
  "typeshare-cli"
  "cargo-watch"
  "cargo-script"
  "cargo-run-script"
  "sccache"
)

# Install packages if they are not already installed
for package in "${packages[@]}"; do
  if ! is_installed "$package"; then
    echo "Installing $package..."
    cargo install "$package"
  else
    echo "$package is already installed."
  end
done

# create a gitignore that ignores everything in .config
[ -f ~/.config/.gitignore ] || echo "*" > $HOME/.config/.gitignore

sudo timedatectl set-timezone America/Los_Angeles
sudo hwclock --systohc --utc
