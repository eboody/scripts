#!/bin/bash

# Step 1: Generate SSH Host Keys (Skip if already generated)
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

# Step 2: Update /etc/ssh/sshd_config for Port 2222
# Backup the original config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
# Uncomment the Port line and change it to 2222, then disable root login
sed -i '/^#Port 22/c\Port 2222' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Step 3: Set permissions for the host keys
chmod 600 /etc/ssh/ssh_host_*

# Step 4: Add user (This part is manual due to security concerns)
useradd -m eran
passwd eran

# Step 5: Run SSHD in debug mode (comment this out if running in production)
/usr/sbin/sshd -d
