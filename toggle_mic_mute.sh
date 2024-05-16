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
