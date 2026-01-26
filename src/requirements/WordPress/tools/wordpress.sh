#!/bin/bash


set -e

#docker handels the waiting "condtion: service healty"
#until mysqladmin ping -h mariadb -u root -p$(cat /run/secrets/db_root_password) --silent; do
#    echo "Waiting for MariaDB..."
#    sleep 2
#done

echo "MariaDB is ready!"
export WP_PATH="/usr/local/bin/wp"


if [ ! -f "$WP_PATH" ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar "$WP_PATH"
fi
#check if wp-cli works
wp --info --allow-root || echo "wp-cli check failed, continuing..."


exec "$@"  # Runs: php-fpm8.4 -F

# https://wp-cli.org/
#curl -0 https://raw.githubusercontent.com/wp-cli/wp-cli/v2.12.0/utils/wp-completion.bash
#source /FULL/PATH/TO/wp-completion.bash
#source ~/.bash_profile