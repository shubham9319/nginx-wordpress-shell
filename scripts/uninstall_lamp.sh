#!/bin/bash

# Stop and disable Apache and MySQL services
echo "${SUDO_PASSWORD}" | sudo systemctl stop apache2
echo "${SUDO_PASSWORD}" | sudo systemctl disable apache2
echo "${SUDO_PASSWORD}" | sudo systemctl stop mysql
echo "${SUDO_PASSWORD}" | sudo systemctl disable mysql

# Uninstall Apache, MySQL, and PHP
echo "${SUDO_PASSWORD}" | sudo apt remove --purge apache2 apache2-utils apache2-bin apache2.2-common -y
echo "${SUDO_PASSWORD}" | sudo apt remove --purge mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-* -y
echo "${SUDO_PASSWORD}" | sudo apt-get remove --purge php php-mysql libapache2-mod-php* php-cli* php-cgi php-gd  php-common* -y

# Remove Apache directories and files
echo "${SUDO_PASSWORD}" | sudo rm -rf /etc/apache2
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/www/html/*
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/log/apache2

# Remove MySQL directories and files
echo "${SUDO_PASSWORD}" | sudo rm -rf /etc/mysql
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/lib/mysql
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/log/mysql
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/log/mysql.*

# Remove PHP directories and files
echo "${SUDO_PASSWORD}" | sudo rm -rf /etc/php
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/lib/php
echo "${SUDO_PASSWORD}" | sudo rm -rf /var/log/php

# Remove any residual configuration files
echo "${SUDO_PASSWORD}" | sudo apt autoremove -y
echo "${SUDO_PASSWORD}" | sudo apt autoclean -y
echo "${SUDO_PASSWORD}" | sudo systemctl daemon-reload

echo "LAMP stack and related files and directories have been removed."
