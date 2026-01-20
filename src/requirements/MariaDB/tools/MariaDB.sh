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
	
	mysql -e 


#Safe wrapper with auto-restart, logging, proper shutdown
exec mysqld_safe