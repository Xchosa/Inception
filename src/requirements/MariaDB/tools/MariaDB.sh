#!/bin/bash

set -e

#ping 0.0.0.0
#ping -t 127.0.0.1 > /dev/null 2>&1 &


DB_NAME="${MYSQL_DATABASE}"
DB_USER="${MYSQL_USER}"
USER_PASSWORD=$(cat /run/secrets/db_user_password)
ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld


cat <<EOF > /tmp/initmariadb.sql
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

exec mysqld --user=mysql --init-file=/tmp/initmariadb.sql