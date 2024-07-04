#!/bin/bash

# Update the package list
echo "${SUDO_PASSWORD}" | sudo apt update

# Install Nginx
echo "${SUDO_PASSWORD}" | sudo apt install nginx -y

# Start and enable Nginx
echo "${SUDO_PASSWORD}" | sudo systemctl start nginx
echo "${SUDO_PASSWORD}" | sudo systemctl enable nginx

# Adjust the firewall to allow Nginx traffic
echo "${SUDO_PASSWORD}" | sudo ufw allow 'Nginx Full'
echo "${SUDO_PASSWORD}" | sudo ufw enable

# Check Nginx status
echo "${SUDO_PASSWORD}" | sudo systemctl status nginx

echo "Nginx installation and setup completed."

