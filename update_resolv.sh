#!/bin/bash

# Backup the current /etc/resolv.conf
cp /etc/resolv.conf /etc/resolv.conf.bak

# Replace IP addresses with 1.1.1.1
sed -i 's/nameserver .*/nameserver 1.1.1.1/' /etc/resolv.conf

echo "IP addresses in /etc/resolv.conf have been replaced with 1.1.1.1"
