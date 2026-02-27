#!/bin/bash


set -e

#export wp_admin_password=$(cat /run/secrets/wp_admin_password)
#ftpuser="$WP_ADMIN_USER"
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
ls -la /etc/ssl/certs/ftp-cert.pem 2>/dev/null || echo "Cert file missing"
ls -la /etc/ssl/private/ftp-key.pem 2>/dev/null || echo "Key file missing"


# Check available IP addresses in container



exec vsftpd -D /etc/vsftpd.conf

#echo "Creating FTP user: $ftpuser"
#useradd -m -s /bin/bash "$ftpuser" || echo "User already exists"

#if [ ! -d /home/"$ftpuser"/.ftp_configured ] ; then
#    echo "$ftpuser:$wp_admin_password" | chpasswd
#    mkdir -p /home/"$ftpuser"/ftp
#    chown "$ftpuser":"$ftpuser" /home/"$ftpuser"/ftp
#    chmod 755 /home/"$ftpuser"/ftp
#fi
##set link 

#ln -sf /var/www/html /home/"$ftpuser"/ftp/wordpress ||  echo "Link already exists"

#chown -R "$ftpuser":"$ftpuser" /var/www/html
## Copy FTP configuration

#echo "Starting vsftp service..."

## -D keeps it as PID 1 preventing from daemonising
#exec  vsftpd -D -v /etc/vsftpd.conf
