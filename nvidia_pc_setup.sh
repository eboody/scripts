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

    # Install ddcutil from AUR (assuming you have yay or another AUR helper installed)
    paru -Sy ddcutil || { echo "Failed to install ddcutil"; exit 1; }

    sudo paru -Sy --needed --noconfirm "${aur_stuff[@]}"

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

