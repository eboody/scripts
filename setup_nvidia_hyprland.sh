#!/bin/bash

set -e

echo "Setting up NVIDIA for Hyprland with systemd-boot..."

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

# Install NVIDIA drivers
install_nvidia_drivers() {
    install_if_needed "nvidia"
    install_if_needed "nvidia-utils"
    install_if_needed "lib32-nvidia-utils"
}

# Enable DRM kernel mode setting for systemd-boot
enable_drm_kms() {
    local loader_dir="/boot/loader/entries"
    local conf_files=("$loader_dir"/*.conf)
    
    if [ ${#conf_files[@]} -eq 0 ]; then
        echo "No systemd-boot configuration files found in $loader_dir"
        echo "Please add 'nvidia_drm.modeset=1' to your kernel parameters manually."
        return
    fi

    for conf_file in "${conf_files[@]}"; do
        if ! grep -q "nvidia_drm.modeset=1" "$conf_file"; then
            echo "Enabling DRM kernel mode setting in $conf_file..."
            sudo sed -i '/^options/ s/$/ nvidia_drm.modeset=1/' "$conf_file"
            echo "Added nvidia_drm.modeset=1 to kernel parameters in $conf_file"
        else
            echo "DRM kernel mode setting is already enabled in $conf_file."
        fi
    done
}

# Update Hyprland configuration
update_hyprland_config() {
    config_file="$HOME/.config/hypr/hyprland.conf"
    
    if [ -f "$config_file" ]; then
        echo "Updating Hyprland configuration..."
        
        # Remove commented NVIDIA-specific environment variables
        sed -i '/^# env = LIBVA_DRIVER_NAME,nvidia/d' "$config_file"
        sed -i '/^# env = GBM_BACKEND,nvidia-drm/d' "$config_file"
        sed -i '/^# env = __GLX_VENDOR_LIBRARY_NAME,nvidia/d' "$config_file"
        sed -i '/^# env = WLR_NO_HARDWARE_CURSORS,1/d' "$config_file"
        
        # Add or update NVIDIA-specific environment variables
        if ! grep -q "env = LIBVA_DRIVER_NAME,nvidia" "$config_file"; then
            echo "env = LIBVA_DRIVER_NAME,nvidia" >> "$config_file"
        fi
        if ! grep -q "env = GBM_BACKEND,nvidia-drm" "$config_file"; then
            echo "env = GBM_BACKEND,nvidia-drm" >> "$config_file"
        fi
        if ! grep -q "env = __GLX_VENDOR_LIBRARY_NAME,nvidia" "$config_file"; then
            echo "env = __GLX_VENDOR_LIBRARY_NAME,nvidia" >> "$config_file"
        fi
        if ! grep -q "env = WLR_NO_HARDWARE_CURSORS,1" "$config_file"; then
            echo "env = WLR_NO_HARDWARE_CURSORS,1" >> "$config_file"
        fi
        
        echo "Hyprland configuration updated."
    else
        echo "Hyprland configuration file not found. Please create it manually and add the required environment variables."
    fi
}

# Update mkinitcpio configuration
update_mkinitcpio() {
    if ! grep -q "nvidia nvidia_modeset nvidia_uvm nvidia_drm" /etc/mkinitcpio.conf; then
        echo "Updating mkinitcpio.conf..."
        sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        sudo mkinitcpio -P
    else
        echo "mkinitcpio.conf is already configured for NVIDIA."
    fi
}

# Create pacman hook
create_pacman_hook() {
    hook_dir="/etc/pacman.d/hooks"
    hook_file="$hook_dir/nvidia.hook"
    
    if [ ! -d "$hook_dir" ]; then
        echo "Creating hooks directory..."
        sudo mkdir -p "$hook_dir"
    fi

    if [ ! -f "$hook_file" ]; then
        echo "Creating NVIDIA pacman hook..."
        sudo tee "$hook_file" > /dev/null <<EOL
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux

[Action]
Description=Update NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
Exec=/usr/bin/mkinitcpio -P
EOL
        echo "Pacman hook created."
    else
        echo "NVIDIA pacman hook already exists."
    fi
}

# Main execution
install_nvidia_drivers
enable_drm_kms
update_hyprland_config
update_mkinitcpio
create_pacman_hook

echo "NVIDIA setup for Hyprland is complete. Please reboot your system for changes to take effect."
