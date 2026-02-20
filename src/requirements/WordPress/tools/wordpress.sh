#!/bin/bash


set -e

#docker handels the waiting "condtion: service healty"
#until mysqladmin ping -h mariadb -u root -p$(cat /run/secrets/db_root_password) --silent; do
#    echo "Waiting for MariaDB..."
#    sleep 2
#done


MYSQL_PASS=$(cat /run/secrets/db_user_password)
#MYSQL_ROOT=
WP_ROOT_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)


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
#wp --info --allow-root || echo "wp-cli check failed, continuing..."

cd /var/www/html


if [ ! -f "wp-settings.php" ]; then
    wp core download --allow-root
    
    # Create wp-config.php
    # Connect WordPress to MariaDB container
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASS \
        --dbhost=mariadb:3306 \
		--dbprefix="$WP_DB_PREFIX"

    #Add Redis configuration
    cat >> /var/www/html/wp-config.php << 'EOF'
// Redis Object Cache
define('WP_CACHE', true);
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_TIMEOUT', 1);
define('WP_REDIS_READ_TIMEOUT', 1);
define('WP_REDIS_DATABASE', 0);
EOF
    # Install WordPress
    wp core install --allow-root \
        --url="poverbec.42.fr" \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ROOT_PASS \
        --admin_email="$WP_ADMIN_EMAIL" \
        --wp_user="$WP_USER" \
        --wp_user_password="$WP_USER_PASS" \
        --skip-email
    # configure Redis Object Cache
    
fi




chown -R www-data:www-data /var/www/html
sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
#sed -i '/find/replace|listen = /run/php/php8.2-fpm.sock|listen = 9000 

#default listens to a local file / socket 
exec php-fpm8.2 -F

# https://wp-cli.org/
#curl -0 https://raw.githubusercontent.com/wp-cli/wp-cli/v2.12.0/utils/wp-completion.bash
#source /FULL/PATH/TO/wp-completion.bash
#source ~/.bash_profile


## jetzt muss mnoch WP Core gedownloaded werden
#	 WP user/admin soll von mariadb nebehmen 
