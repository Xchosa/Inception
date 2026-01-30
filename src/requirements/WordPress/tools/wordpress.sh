#!/bin/bash


set -e

#docker handels the waiting "condtion: service healty"
#until mysqladmin ping -h mariadb -u root -p$(cat /run/secrets/db_root_password) --silent; do
#    echo "Waiting for MariaDB..."
#    sleep 2
#done

DB_USER_PASS=$(cat /run/secrets/db_user_password)

echo "MariaDB is ready!"
export WP_PATH="/usr/local/bin/wp"
export WP_ROOT="/var/www/html"
export WP_USER="www-data"

if [ ! -f "$WP_PATH" ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar "$WP_PATH"
fi
#check if wp-cli works
wp --info --allow-root || echo "wp-cli check failed, continuing..."

cd /var/www/html


if [ ! -f "wp-settings.php" ]; then
    wp core download --allow-root
    
    # 4. Create wp-config.php
    # Connect WordPress to MariaDB container
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$DB_USER_PASS\
        --dbhost=mariadb:3306 \
		--dbprefix="$WP_DB_PREFIX"

    # 5. Install WordPress
    wp core install --allow-root \
        --url="poverbec.42.fr" \
         --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
fi

chown -R www-data:www-data $WP_ROOT


exec php-fpm8.4 -F

# https://wp-cli.org/
#curl -0 https://raw.githubusercontent.com/wp-cli/wp-cli/v2.12.0/utils/wp-completion.bash
#source /FULL/PATH/TO/wp-completion.bash
#source ~/.bash_profile


## jetzt muss mnoch WP Core gedownloaded werden
#	 WP user/admin soll von mariadb nebehmen 
