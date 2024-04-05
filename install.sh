# List of official packages to be installed
official_packages=(
    vim
    libinput
    interception-tools
    libevdev
    glibc
    firefox
    git
    kitty
    gcc
    rustup
    gimp
    wget
    pavucontrol
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
    rofi-lbonn-wayland
    zoxide
    bat
    fzf
    p7zip
    npm
    nodejs
)

# Update the system
sudo pacman -Syu

# Install official packages
sudo pacman -S --needed --noconfirm "${official_packages[@]}"

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
sh $HOME/scripts/merge_dotfiles.sh
sh $HOME/scripts/tmux_tpm.sh
sh $HOME/scripts/rofi_theme.sh
sh $HOME/scripts/aliases.sh

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

cargo install typeshare-cli
cargo install cargo-watch

# create a gitignore that ignores everything in .config
[ -f ~/.config/.gitignore ] || echo "*" > $HOME/.config/.gitignore
