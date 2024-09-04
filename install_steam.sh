#!/bin/bash

set -e

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null
}

# Function to enable multilib repository
enable_multilib() {
    if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
        echo "Enabling multilib repository..."
        sudo sed -i "/\[multilib\]/,/Include/s/^#//" /etc/pacman.conf
        sudo pacman -Sy
    else
        echo "Multilib repository is already enabled."
    fi
}

# Function to install a package if it's not already installed
install_if_needed() {
    if ! is_installed "$1"; then
        echo "Installing $1..."
        sudo pacman -S --noconfirm "$1"
    else
        echo "$1 is already installed."
    fi
}

# Main installation function
install_steam() {
    enable_multilib

    # Install Steam
    install_if_needed "steam"

    # Install optional but recommended packages
    install_if_needed "ttf-liberation"  # Font alternative
    install_if_needed "xdg-desktop-portal"  # For file chooser support
    install_if_needed "lib32-systemd"  # For network connectivity if using systemd-networkd

    # Increase vm.max_map_count
    echo "Increasing vm.max_map_count..."
    echo "vm.max_map_count = 2147483642" | sudo tee /etc/sysctl.d/12-steam.conf
    sudo sysctl --system

    # Install Vulkan drivers
    echo "Do you want to install Vulkan drivers? (y/n)"
    read -r install_vulkan
    if [[ $install_vulkan =~ ^[Yy]$ ]]; then
        echo "Select your GPU vendor:"
        echo "1) NVIDIA"
        echo "2) AMD"
        echo "3) Intel"
        read -r gpu_choice
        case $gpu_choice in
            1) install_if_needed "lib32-nvidia-utils" ;;
            2) install_if_needed "lib32-vulkan-radeon" ;;
            3) install_if_needed "lib32-vulkan-intel" ;;
            *) echo "Invalid choice. Skipping Vulkan driver installation." ;;
        esac
    fi

    # Install Proton-GE
    echo "Do you want to install Proton-GE (a custom Proton version)? (y/n)"
    read -r install_proton_ge
    if [[ $install_proton_ge =~ ^[Yy]$ ]]; then
        install_if_needed "yay"  # Install yay AUR helper if not present
        yay -S --noconfirm proton-ge-custom
    fi

    echo "Steam installation and setup complete!"
    echo "Remember to restart your system for some changes to take effect."
    echo "After restarting, you can launch Steam and enable Proton in Steam > Settings > Steam Play."
}

# Run the main installation function
install_steam
