#!/bin/bash


set -e

#docker handels the waiting "condtion: service healty"
#until mysqladmin ping -h mariadb -u root -p$(cat /run/secrets/db_root_password) --silent; do
#    echo "Waiting for MariaDB..."
#    sleep 2
#done


MYSQL_PASS=$(cat /run/secrets/db_user_password)
WP_ROOT_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)




echo "MariaDB is ready!"
export WP_PATH="/usr/local/bin/wp"
export WP_ROOT="/var/www/html"


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

// FTP plugin 
define('FS_METHOD', 'ftpext');
define('FTP_HOST', 'ftp_server');
define('FTP_USER', getenv('WP_ADMIN_USER'));
define('FTP_PASS', file_get_contents('/run/secrets/wp_admin_password'));
define('FTP_SSL', false);
define('FTP_BASE', '/var/www/html/');
define('FTP_CONTENT_DIR', '/var/www/html/wp-content/');
define('FTP_PLUGIN_DIR', '/var/www/html/wp-content/plugins/');
define('FTP_THEME_DIR', '/var/www/html/wp-content/themes/');
EOF
    # Install WordPress
    wp core install --allow-root \
        --url="poverbec.42.fr" \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ROOT_PASS \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
fi

if [ "$WP_USER" != "$WP_ADMIN_USER" ]; then
    if ! wp user get "$WP_USER" --allow-root --path=${WP_ROOT} > /dev/null 2>&1; then
        echo "Creating WordPress User role: Author: $WP_USER"
        wp user create "$WP_USER" "$WP_USER_EMAIL" \
            --role=author \
            --user_pass="$WP_USER_PASS" \
            --allow-root \
            --path=/var/www/html
        echo "User $WP_USER created successfully"
    else
        echo "User $WP_USER already exists"
    fi
fi

chown -R www-data:www-data /var/www/html
sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf


exec php-fpm8.2 -F
#default listens to a local file / socket 

# https://wp-cli.org/
#curl -0 https://raw.githubusercontent.com/wp-cli/wp-cli/v2.12.0/utils/wp-completion.bash
#source /FULL/PATH/TO/wp-completion.bash
#source ~/.bash_profile
