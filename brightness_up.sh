#!/bin/bash

# Check if on a laptop (assuming the presence of a battery directory)
if ls /sys/class/power_supply/ | grep -qi battery; then
    # Command for laptop
    brightnessctl set 10%+
else
    # Command for desktop
    ddcutil setvcp 10 + 33 --display 1
fi

