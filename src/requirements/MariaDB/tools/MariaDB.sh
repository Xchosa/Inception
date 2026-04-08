#!/bin/bash

set -e

#ping 0.0.0.0
#ping -t 127.0.0.1 > /dev/null 2>&1 &

#tail -f

db_root_password=$(cat /run/secrets/db_root_password)
db_user_password=$(cat /run/secrets/db_user_password)
wp_admin_password=$(cat /run/secrets/wp_admin_password)


mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql
fi

# env und config ueberschneiden sich nicht 
# 
#exec mysqld --datadir=/var/lib/mysql --user=mysql --bind-address=0.0.0.0

#setup mode 
#exec mysqld --user=mysql
cat << EOF > .tmp/initmariadb.sql
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${db_user_password}';" 
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES" || echo "Failed on FLUSH PRIVILEGES"
EOF

exec mysqld --user=mysql --init-file=/tmp/initmariadb.sql