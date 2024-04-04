#!/bin/bash

# Function to check if Docker is installed
check_docker_installed() {
    if command -v docker &> /dev/null; then
        echo "Docker is already installed."
        return 0
    else
        return 1
    fi
}

# Function to check if Docker service is running
check_docker_running() {
    if systemctl is-active --quiet docker; then
        echo "Docker service is already running."
        return 0
    else
        return 1
    fi
}

# Install Docker if it's not installed
if ! check_docker_installed; then
    echo "Installing Docker..."
    sudo pacman -S docker --noconfirm

    echo "Enabling Docker service..."
    sudo systemctl enable docker

    echo "Starting Docker service..."
    sudo systemctl start docker

    echo "Docker installation and setup complete."
else
    echo "Docker is installed."

    # Start and enable Docker service if it's not running
    if ! check_docker_running; then
        echo "Starting and enabling Docker service..."
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker service is up and running."
    else
        echo "No action needed. Docker service is running."
    fi
fi

# Adding the current user to the Docker group
echo "Adding the current user to the Docker group..."
sudo usermod -aG docker $USER
echo "You may need to log out and log back in for group changes to take effect."

