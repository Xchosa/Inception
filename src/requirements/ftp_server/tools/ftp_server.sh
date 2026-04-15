#!/bin/bash


set -e

FTP_PASSWORD=$(cat /run/secrets/sftp_password)

echo "FTP server configured without SSL"

echo "Setting up FTP user: $FTP_USER"

useradd -u 1001 -g www-data -d /var/www/html -s /bin/bash "$FTP_USER" 2>/dev/null || echo "User already exists"
if echo "$FTP_USER:$FTP_PASSWORD" | chpasswd 2>&1; then
    echo "Password set successfully"
else
    echo "Password setting failed"
    exit 1
fi


chown -R $FTP_USER:www-data /var/www/html
chmod -R 775 /var/www/html
mkdir -p /var/run/vsftpd/empty

#upload directory 
mkdir -p /var/www/html/wp-content/uploads
chown -R $FTP_USER:www-data /var/www/html/wp-content
chmod -R 775 /var/www/html/wp-content

echo "Starting vsftpd in foreground..."


exec vsftpd /etc/vsftpd.conf

