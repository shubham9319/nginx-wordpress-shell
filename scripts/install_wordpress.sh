#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <DB_NAME> <DB_USER> <DB_PASS> <ServerName> <ServerAlias>"
    exit 1
fi

# Get input from command line arguments
DB_NAME=$1
DB_USER=$2
DB_PASS=$3
SERVER_NAME=$4
SERVER_ALIAS=$5

# Create a MySQL database and user for WordPress
echo "${SUDO_PASSWORD}" | sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Download and extract WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz

# Move WordPress files to the Apache web root directory
echo "${SUDO_PASSWORD}" | sudo mv wordpress /var/www/html/$DB_NAME

# Set correct permissions
echo "${SUDO_PASSWORD}" | sudo chown -R www-data:www-data /var/www/html/$DB_NAME
echo "${SUDO_PASSWORD}" | sudo chmod -R 755 /var/www/html/$DB_NAME

# Create Apache virtual host for WordPress
echo "${SUDO_PASSWORD}" | sudo bash -c "cat <<EOT > /etc/apache2/sites-available/$DB_NAME.conf
<VirtualHost *:80>
    ServerAdmin admin@$SERVER_NAME
    DocumentRoot /var/www/html/$DB_NAME
    ServerName $SERVER_NAME
    ServerAlias $SERVER_ALIAS

    <Directory /var/www/html/$DB_NAME>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOT"

# Enable the virtual host and rewrite module
echo "${SUDO_PASSWORD}" | sudo a2ensite $DB_NAME.conf
echo "${SUDO_PASSWORD}" | sudo a2enmod rewrite
echo "${SUDO_PASSWORD}" | sudo systemctl restart apache2
echo "${SUDO_PASSWORD}" | sudo systemctl daemon-reload

echo "WordPress installation and setup completed."
