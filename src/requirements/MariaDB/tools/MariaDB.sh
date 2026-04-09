#!/bin/bash

set -e

#ping 0.0.0.0
#ping -t 127.0.0.1 > /dev/null 2>&1 &

#tail -f

db_root_password=$(cat /run/secrets/db_root_password)
db_user_password=$(cat /run/secrets/db_user_password)


mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	chown -R mysql:mysql /var/lib/mysql

	cat <<EOF > /tmp/initmariadb.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${db_user_password}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${db_root_password}';
FLUSH PRIVILEGES;
EOF

	exec mysqld --user=mysql --init-file=/tmp/initmariadb.sql
else
	exec mysqld --user=mysql
fi
