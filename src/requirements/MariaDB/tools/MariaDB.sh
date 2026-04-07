#!/bin/bash

set -e


export db_root_password=$(cat /run/secrets/db_root_password)
export db_user_password=$(cat /run/secrets/db_user_password)
export wp_admin_password=$(cat /run/secrets/wp_admin_password)


mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql
fi


mysqld --datadir=/var/lib/mysql  --user=mysql --bind-address=0.0.0.0 &
MYSQL_PID=$! 	#hold pid of the last background process 

until mysqladmin ping --silent; do
	sleep 1
done

#setup mode 
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${db_user_password}';" 
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES" || echo "Failed on FLUSH PRIVILEGES"


mysqladmin shutdown --socket=/var/run/mysqld/mysqld.sock 
wait $MYSQL_PID

exec mysqld --datadir=/var/lib/mysql --user=mysql --bind-address=0.0.0.0

