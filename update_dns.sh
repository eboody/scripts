#!/bin/bash

# Check if 8.8.8.8 is already in the file
if ! grep -q "8.8.8.8" /etc/resolv.conf; then
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf > /dev/null
fi

# Check if 8.8.4.4 is already in the file
if ! grep -q "8.8.4.4" /etc/resolv.conf; then
    echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null
fi

echo "/etc/resolv.conf updated successfully."
