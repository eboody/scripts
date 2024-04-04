#!/bin/bash

# Define your preferred theme configuration here
mypref="config1" # Change this to your preferred configuration (e.g., "config1", "config2", etc.)

# Create the rofi config directory if it doesn't already exist
mkdir -p ~/.config/rofi

# Function to install theme using git
install_via_git() {
    echo "Attempting to install Dracula theme for Rofi using git..."
    if git clone https://github.com/dracula/rofi.git /tmp/dracula-rofi && [ -f "/tmp/dracula-rofi/theme/${mypref}.rasi" ]; then
        cp "/tmp/dracula-rofi/theme/${mypref}.rasi" ~/.config/rofi/config.rasi
        echo "Dracula theme installed successfully using git."
        return 0
    else
        echo "Failed to clone Dracula theme repository or specified config does not exist."
        return 1
    fi
}

# Function to install theme manually if git installation fails
install_manually() {
    echo "Attempting to install Dracula theme for Rofi manually using curl..."
    if curl -L "https://raw.githubusercontent.com/dracula/rofi/master/theme/${mypref}.rasi" -o ~/.config/rofi/config.rasi; then
        echo "Dracula theme installed successfully using curl."
    else
        echo "Failed to download the Dracula theme using curl."
    fi
}

# Try to install using git
if ! install_via_git; then
    # Fallback to manual installation if git method fails
    install_manually
fi
