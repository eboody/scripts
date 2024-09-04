#!/bin/bash

set -e

echo "Reverting NVIDIA-specific configurations for Hyprland..."

# Remove NVIDIA modules from mkinitcpio.conf
sudo sed -i 's/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/MODULES=()/' /etc/mkinitcpio.conf

# Remove NVIDIA options from modprobe
sudo rm -f /etc/modprobe.d/nvidia.conf

# Remove NVIDIA-specific environment variables from Hyprland config
sed -i '/^env = LIBVA_DRIVER_NAME,nvidia/d' ~/.config/hypr/hyprland.conf
sed -i '/^env = XDG_SESSION_TYPE,wayland/d' ~/.config/hypr/hyprland.conf
sed -i '/^env = GBM_BACKEND,nvidia-drm/d' ~/.config/hypr/hyprland.conf
sed -i '/^env = __GLX_VENDOR_LIBRARY_NAME,nvidia/d' ~/.config/hypr/hyprland.conf
sed -i '/^env = WLR_NO_HARDWARE_CURSORS,1/d' ~/.config/hypr/hyprland.conf

# Rebuild initramfs
sudo mkinitcpio -P

echo "NVIDIA-specific configurations have been reverted."
echo "Please reboot your system for changes to take effect."
echo "After reboot, if the issue persists, we may need to investigate further."
