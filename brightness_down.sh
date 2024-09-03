#!/bin/bash

chassis_type=$(cat /sys/class/dmi/id/chassis_type)
# Common chassis types for laptops are 9 (Laptop), 10 (Notebook), 14 (Sub Notebook)
if [[ "$chassis_type" == 9 || "$chassis_type" == 10 || "$chassis_type" == 14 ]]; then
    # Commands for laptop
    brightnessctl set 10%-
else
    # Commands for desktop
    ddcutil setvcp 10 - 50 --display 1
fi
