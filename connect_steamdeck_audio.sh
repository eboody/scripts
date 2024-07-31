#!/bin/bash
DEVICE_MAC_ADDRESS="B0:0C:9D:A4:EE:B2"
bluetoothctl << EOF
connect $DEVICE_MAC_ADDRESS
EOF
