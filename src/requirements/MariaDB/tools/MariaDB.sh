#!/bin/bash

set -e

#ping 0.0.0.0
#ping -t 127.0.0.1 > /dev/null 2>&1 &


db_root_pswd=$(cat /run/secrets/db_root_password)
db_user_pswd=$(cat /run/secrets/db_user_password)

echo "hallooooooooooooooooooooooooooo"
echo "root password length: ${db_root_pswd}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld


cat <<EOF > /tmp/initmariadb.sql
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${db_user_paswd}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${db_root_pswd}';
FLUSH PRIVILEGES;
EOF

exec mysqld --user=mysql --init-file=/tmp/initmariadb.sql