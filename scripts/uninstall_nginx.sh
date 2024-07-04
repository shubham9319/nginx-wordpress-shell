#!/bin/bash

# Stop and disable Nginx service
echo "${SUDO_PASSWORD}" | sudo systemctl stop nginx
echo "${SUDO_PASSWORD}" | sudo systemctl disable nginx

# Uninstall Nginx
echo "${SUDO_PASSWORD}" | sudo apt remove --purge nginx nginx-common nginx-full -y

# Remove Nginx directories and files
echo "${SUDO_PASSWORD}" | sudo rm -rf /etc/nginx
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/www/html
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/log/nginx
echo "${SUDO_PASSWORD}" | sudo rm -rf /usr/share/nginx

# Adjust firewall rules to remove Nginx
echo "${SUDO_PASSWORD}" | sudo ufw delete allow 'Nginx Full'

echo "Nginx and related files and directories have been removed."

