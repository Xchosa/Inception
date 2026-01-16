#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ] ; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql
fi

#Safe wrapper with auto-restart, logging, proper shutdown
exec mysqld_safe