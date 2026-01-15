#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/mysql" ] ; then
	mysql_install_db --user=msql --datadir=/var/lib/mysql
fi

exec mysqld_safe