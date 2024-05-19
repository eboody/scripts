#!/bin/bash

# Get the MAC address of the primary network interface
mac_address=$(cat /sys/class/net/$(ip route show default | awk '/default/ {print $5}')/address)

# Define the expected MAC address for the laptop
laptop_mac_address="04:7b:cb:b3:3c:e6"

# Check for root permissions
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

aur_stuff=(
laptop-mode-tools
fprint
)

# Check if the current MAC address matches the laptop's MAC address
if [ "$mac_address" == "$laptop_mac_address" ]; then
    sudo pacman -S --needed --noconfirm "${aur_stuff[@]}"
    sudo sh /home/eran/scripts/setup_mic_mute.sh
else
    echo "not on laptop"
fi
