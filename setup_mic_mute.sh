#!/bin/bash

# Define variables
UDEV_RULE_FILE="/etc/udev/rules.d/99-micmute.rules"
TOGGLE_SCRIPT="/usr/local/bin/toggle_mic_mute.sh"
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Create udev rule
echo "Creating udev rule..."
echo 'SUBSYSTEM=="leds", KERNEL=="platform::micmute", MODE="0660", GROUP="users"' | sudo tee $UDEV_RULE_FILE

# Reload udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

sudo chmod 666 /sys/class/leds/platform::micmute/brightness

# Add current user to 'users' group
echo "Adding current user to 'users' group..."
sudo usermod -aG users $USER

# Create the toggle script
echo "Creating toggle script..."
sudo tee $TOGGLE_SCRIPT > /dev/null << 'EOF'
#!/bin/bash

# Get the default source (microphone)
DEFAULT_SOURCE=$(pactl info | grep 'Default Source' | cut -d ' ' -f3)

# Toggle mute state
pactl set-source-mute "$DEFAULT_SOURCE" toggle

# Check the current mute state
MUTE_STATE=$(pactl get-source-mute "$DEFAULT_SOURCE")

if [[ "$MUTE_STATE" == "Mute: yes" ]]; then
    # Microphone is muted, turn off the indicator light
    echo 0 > /sys/class/leds/platform::micmute/brightness
else
    # Microphone is unmuted, turn on the indicator light
    echo 1 > /sys/class/leds/platform::micmute/brightness
fi
EOF

# Make the script executable
echo "Making the toggle script executable..."
sudo chmod +x $TOGGLE_SCRIPT

# Add binding to Hyprland config
echo "Adding key binding to Hyprland config..."
mkdir -p "$(dirname "$HYPRLAND_CONFIG")"
if ! grep -q "bind =, XF86AudioMicMute" "$HYPRLAND_CONFIG"; then
    echo "bind =, XF86AudioMicMute, exec, $TOGGLE_SCRIPT" >> "$HYPRLAND_CONFIG"
else
    echo "Key binding already exists in $HYPRLAND_CONFIG"
fi

# Reload Hyprland configuration
echo "Reloading Hyprland configuration..."
hyprctl reload

echo "Setup complete. Please log out and log back in for group changes to take effect, then test the microphone mute key."
