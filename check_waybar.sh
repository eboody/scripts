#!/bin/bash

# Export display environment variables
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export WAYLAND_DISPLAY=$(ls $XDG_RUNTIME_DIR | grep -m1 wayland)

# Check if Waybar is running
if ! pgrep -x "waybar" > /dev/null
then
    # If Waybar is not running, start it
    waybar &
    echo "Waybar restarted at $(date)" >> ~/waybar_restart.log
fi
