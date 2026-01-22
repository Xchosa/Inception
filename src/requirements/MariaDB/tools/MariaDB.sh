#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ] ; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql
fi

 	# Start mysqld temporarily to configure users
mysqld_safe --datadir=/var/lib/mysql &
MYSQL_PID=$!

until mysqladmin ping --silent; do
	sleep 1
done

#setup mode 
mysql -e "CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS ${MYSQL_USER}'@'%' IDENTIFIED BY ${db_user_password}';" 
mysql -e "GRANT ALL PRIVILEDGES ON ${MYSQL_DATABASE}. * TO '${MYSQL_USER}'@'%';"
mysql -e "CREATE USER IF NOT EXITS ${WP_ADMIN_USER}'@';'IDENTIFIED BY '${wp_admin_password}';"
mysql -e "GRANT ALL PRIVILEDGES ON ${MYSQL_DATABASE}. * TO '${WP_ADMIN_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES";	

# shutdown server before execute 
mysqladmin shutdown --socket=/var/run/mysqld/mysqld.sock 
#production mode 
#Safe wrapper with auto-restart, logging, proper shutdown
exec mysqld_safe