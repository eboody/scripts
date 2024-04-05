#!/bin/bash

# Check for root permissions
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

aur_stuff=(
qt5-wayland
qt5ct
libva
libva-nvidia-driver-git
)
# Check for Nvidia GPU
if lspci | grep -i nvidia > /dev/null; then
    echo "Nvidia GPU detected, proceeding with ddcutil setup..."


# 1. Add nvidia modules to /etc/mkinitcpio.conf
if ! grep -q "^MODULES=(.*nvidia.*nvidia_modeset.*nvidia_uvm.*nvidia_drm.*)" /etc/mkinitcpio.conf; then
    echo "Adding nvidia modules to /etc/mkinitcpio.conf..."
    sed -i 's/^MODULES=(/&nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
else
    echo "Nvidia modules already added."
fi

# Ensure linux-headers is installed
if ! pacman -Qi linux-headers > /dev/null 2>&1; then
    echo "linux-headers package is required. Installing..."
    pacman -Sy linux-headers
fi

# 2. Generate initramfs
mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img

# 3. Add options nvidia-drm modeset=1 to /etc/modprobe.d/nvidia.conf
if [ ! -f /etc/modprobe.d/nvidia.conf ]; then
    echo "Creating /etc/modprobe.d/nvidia.conf and adding modeset option..."
    echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf
else
    if ! grep -q "^options nvidia-drm modeset=1$" /etc/modprobe.d/nvidia.conf; then
        echo "Adding modeset option to /etc/modprobe.d/nvidia.conf..."
        echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia.conf
    else
        echo "Modeset option already set in /etc/modprobe.d/nvidia.conf."
    fi
fi

# 4. Add env variables to hyprland.conf
HYPR_CONF="/home/eran/.config/hypr/hyprland.conf"

if [ -f "$HYPR_CONF" ]; then
    echo "Adding env variables to $HYPR_CONF..."
    for env_var in "LIBVA_DRIVER_NAME=nvidia" "XDG_SESSION_TYPE=wayland" "GBM_BACKEND=nvidia-drm" "__GLX_VENDOR_LIBRARY_NAME=nvidia" "WLR_NO_HARDWARE_CURSORS=1"; do
        if ! grep -q "^env = $env_var$" "$HYPR_CONF"; then
            echo "env = $env_var" >> "$HYPR_CONF"
        fi
    done
else
    echo "Warning: $HYPR_CONF not found. Ensure Hyprland is installed and configured."
fi

# 5. Print bootloader configuration instructions
echo "For people using systemd-boot you can do this adding nvidia_drm.modeset=1 to the end of /boot/loader/entries/arch.conf."
echo "For people using grub you can do this by adding nvidia_drm.modeset=1 to the end of GRUB_CMDLINE_LINUX_DEFAULT= in /etc/default/grub, then run # grub-mkconfig -o /boot/grub/grub.cfg"
echo "For others check out kernel parameters and how to add nvidia_drm.modeset=1 to your specific bootloader."
    paru -Sy --needed --noconfirm "${aur_stuff[@]}"

    # Install ddcutil from AUR (assuming you have yay or another AUR helper installed)
    paru -Sy ddcutil || { echo "Failed to install ddcutil"; exit 1; }


    # Load i2c-dev kernel module
    modprobe i2c-dev

    # Make i2c-dev module load at boot
    echo i2c_dev >> /etc/modules-load.d/ddc.conf

    # Create the i2c group if it doesn't already exist
    if ! getent group i2c > /dev/null; then
        groupadd i2c
        echo "Group 'i2c' created."
    else
        echo "Group 'i2c' already exists."
    fi

    # Copy udev rules to allow group i2c read and write access to /dev/i2c-*
    cp /usr/share/ddcutil/data/45-ddcutil-i2c.rules /etc/udev/rules.d/

    # Reload udev rules
    udevadm control --reload-rules && udevadm trigger

    # Add the current user to the i2c group
    usermod -aG i2c $SUDO_USER

    echo "Setup complete. Please reboot for changes to take effect."
else
    echo "No Nvidia GPU detected. Exiting..."
    exit 1
fi

