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
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
echo "11111111111"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${db_user_password}';" 
echo "22222222"
mysql -e "GRANT ALL PRIVILEDGES ON '${MYSQL_DATABASE}. * TO '${MYSQL_USER}'@'%';"
echo "33333333333"
#mysql -e "CREATE USER IF NOT EXISTS '${WP_ADMIN_USER}'@'%'IDENTIFIED BY '${wp_admin_password}';"
#echo "444444444"
mysql -e "GRANT ALL PRIVILEDGES ON ${MYSQL_DATABASE}.* TO '${WP_ADMIN_USER}'@'%';"
echo "5"
mysql -e "FLUSH PRIVILEGES" || echo "Failed on FLUSH PRIVILEGES"

# shutdown server before execute 
mysqladmin shutdown --socket=/var/run/mysqld/mysqld.sock 
#production mode 
#Safe wrapper with auto-restart, logging, proper shutdown
exec mysqld_safe

#make fclean does not work 
#last errro 
#mariadb  | ERROR 1064 (42000) at line 1: You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'PRIVILEDGES ON 'mydb. * TO 'paul'@'%'' at line 1
