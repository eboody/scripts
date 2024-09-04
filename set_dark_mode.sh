#!/bin/bash

set -e

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null
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

# Set GTK dark mode
set_gtk_dark_mode() {
    install_if_needed "gnome-themes-extra"
    
    mkdir -p ~/.config/gtk-3.0
    echo "[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark" > ~/.config/gtk-3.0/settings.ini

    echo "gtk-application-prefer-dark-theme=true
gtk-theme-name=\"Adwaita-dark\"" >> ~/.gtkrc-2.0
}

# Set Qt dark mode
set_qt_dark_mode() {
    install_if_needed "qt5ct"
    install_if_needed "kvantum"
    
    echo "export QT_QPA_PLATFORMTHEME=qt5ct" >> ~/.profile
    
    mkdir -p ~/.config/qt5ct
    echo "[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/airy.conf
custom_palette=false
standard_dialogs=default
style=kvantum-dark" > ~/.config/qt5ct/qt5ct.conf

    mkdir -p ~/.config/Kvantum
    echo "theme=KvArcDark" > ~/.config/Kvantum/kvantum.kvconfig
}

# Update Hyprland config
update_hyprland_config() {
    config_file="$HOME/.config/hypr/hyprland.conf"
    if [ -f "$config_file" ]; then
        if ! grep -q "exec-once = gsettings set org.gnome.desktop.interface color-scheme prefer-dark" "$config_file"; then
            echo "Adding dark mode setting to Hyprland config..."
            echo "exec-once = gsettings set org.gnome.desktop.interface color-scheme prefer-dark" >> "$config_file"
        fi
    else
        echo "Hyprland config file not found. Please add the following line to your config:"
        echo "exec-once = gsettings set org.gnome.desktop.interface color-scheme prefer-dark"
    fi
}

# Main function
main() {
    echo "Setting up dark mode for Hyprland..."
    set_gtk_dark_mode
    set_qt_dark_mode
    update_hyprland_config
    echo "Dark mode setup complete. Please restart Hyprland for changes to take effect."
}

# Run the main function
main
