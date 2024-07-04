#!/bin/bash

# Update the package list
echo "${SUDO_PASSWORD}" | sudo apt update

# Install Apache
echo "${SUDO_PASSWORD}" | sudo apt install apache2 -y

# Install MySQL
echo "${SUDO_PASSWORD}" | sudo apt install mysql-server -y

# Secure MySQL installation
echo "${SUDO_PASSWORD}" | sudo mysql_secure_installation <<EOF
y
1
y
y
y
y
y
EOF

# Install PHP and required extensions
echo "${SUDO_PASSWORD}" | sudo apt-get install php php-mysql libapache2-mod-php php-cli php-cgi php-gd php-common -y

# Restart Apache to apply changes
echo "${SUDO_PASSWORD}" | sudo systemctl restart apache2
echo "${SUDO_PASSWORD}" | sudo systemctl daemon-reload

echo "LAMP stack installation completed."
