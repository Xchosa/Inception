#!/bin/bash

set -e

# compose mounted required files in the container
# mounts secret to /run/secrets/ 

export db_root_password=$(cat /run/secrets/db_root_password)
export db_user_password=$(cat /run/secrets/db_user_password)
export wp_admin_password=$(cat /run/secrets/wp_admin_password)


mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql
fi


#kein eigenes error handling mit sql save, container soll crashen wenn mysql schiefgeht , und nicht nur mysql save erneut gestartet werden
# soll als PID 1 ausgefuehrt werden 

#run mariadb as user  (& ->background) lissten to all network interfaces -> wordpress container connects form docker network
mysqld --datadir=/var/lib/mysql  --user=mysql --bind-address=0.0.0.0 &
MYSQL_PID=$! 	#hold pid of the last background process / ccapture it 

until mysqladmin ping --silent; do
	sleep 1
done

#setup mode 
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${db_user_password}';" 
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

#mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${WP_ADMIN_USER}'@'%';"

mysql -e "FLUSH PRIVILEGES" || echo "Failed on FLUSH PRIVILEGES"

#mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${db_root_password}';"

# shutdown server before execute 
#mysqladmin shutdown --socket=/var/run/mysqld/mysqld.sock 

#mysqladmin shutdown -u root 
mysqladmin shutdown --socket=/var/run/mysqld/mysqld.sock 
wait $MYSQL_PID

#production mode 
#Safe wrapper with auto-restart, logging, proper shutdown
#exec mysqld_safe --datadir=/var/lib/mysql

exec mysqld --datadir=/var/lib/mysql --user=mysql --bind-address=0.0.0.0
#make fclean does not work 
#last errro 
#mariadb  | ERROR 1064 (42000) at line 1: You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'PRIVILEDGES ON 'mydb. * TO 'paul'@'%'' at line 1


#so eigentlih 
