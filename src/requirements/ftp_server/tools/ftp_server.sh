#!/bin/bash


set -e

export wp_admin_password=$(cat /run/secrets/wp_admin_password)
ftpuser="$WP_ADMIN_USER"

# Generate private key and certificate in one command
if [ ! -f /run/secrets/FTPprivKey] ; then
    echo "ERROR SSL certificates needs to be loaded ! "
else 
    echo "certificates existing"
fi

echo "Creating FTP user: $ftpuser"
useradd -m -s /bin/bash "$ftpuser" || echo "User already exists"

if [ ! -d /home/"$ftpuser"/.ftp_configured ] ; then
    echo "$ftpuser:$wp_admin_password" | chpasswd
    mkdir -p /home/"$ftpuser"/ftp
    chown "$ftpuser":"$ftpuser" /home/"$ftpuser"/ftp
    chmod 755 /home/"$ftpuser"/ftp
fi
#set link 
ln -sf /var/www/html /home/"$ftpuser"/ftp/wordpress ||  echo "Link already exists"

chown -R "$ftpuser":"$ftpuser" /var/www/html
# Copy FTP configuration

echo "Starting vsftp service..."

# Start FTP service
exec  vsftpd  /etc/vsftpd.conf
