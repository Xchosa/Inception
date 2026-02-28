#!/bin/bash


set -e

export FTP_PASSWORD=$(cat /run/secrets/sftp_password | tr -d '\n\r')

#copy certificates from secrets to container secrets
if [ -f /run/secrets/FTPcertificate ] && [ -f /run/secrets/FTPprivKey ]; then
    echo "Copying SSL certificates to proper locations..."
    mkdir -p /etc/ssl/certs /etc/ssl/private
    cp /run/secrets/FTPcertificate /etc/ssl/certs/ftp-cert.pem
    cp /run/secrets/FTPprivKey /etc/ssl/private/ftp-key.pem
    chmod 644 /etc/ssl/certs/ftp-cert.pem
    chmod 600 /etc/ssl/private/ftp-key.pem
    echo "SSL certificates configured"
else 
    echo "ERROR: SSL certificates not found in secrets!"
    ls -la /run/secrets/ || echo "No secrets directory found"
    exit 1
fi

echo "Setting up FTP user: $FTP_USER"
echo "FTP_PASSWORD length: ${#FTP_PASSWORD}"
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
echo "Starting vsftp service..."


echo "Starting vsftpd in foreground..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf



#echo "Available network interfaces:"
#ip addr show || ifconfig -a
#echo "Checking specific IPs:"
#ping -c 1 127.0.0.1 >/dev/null 2>&1 && echo "127.0.0.1 is available" || echo "127.0.0.1 NOT available"
#ping -c 1 0.0.0.0 >/dev/null 2>&1 && echo "0.0.0.0 is available" || echo "0.0.0.0 NOT available"

# Check available IP addresses in container



exec vsftpd /etc/vsftpd.conf

