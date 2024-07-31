#!/bin/bash
DEVICE_MAC_ADDRESS="E8:9C:25:2F:AA:33"
bluetoothctl << EOF
connect $DEVICE_MAC_ADDRESS
EOF
