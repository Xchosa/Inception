#!/bin/bash


set -e

#ping -t 127.0.0.1 > /dev/null 2>&1 &

MYSQL_PASS=$(cat /run/secrets/db_user_password)
WP_ROOT_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)


WP_PATH="/usr/local/bin/wp"
WP_ROOT="/var/www/html"


if [ ! -f "$WP_PATH" ]; then
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar "$WP_PATH"
fi

cd /var/www/html


if [ ! -f "wp-config.php" ]; then
    echo "Downloading WordPress core..."
    wp core download --allow-root

    echo "Creating wp-config.php"
    wp config create --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASS}" \
        --dbhost="${WP_DB_HOST}:3306" \
        --allow-root \
        --skip-check \
        --extra-php <<'EOF'
define('WP_HOME', 'https://poverbec.42.fr');
define('WP_SITEURL', 'https://poverbec.42.fr');


define('WP_CACHE', true);
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_TIMEOUT', 1);
define('WP_REDIS_READ_TIMEOUT', 1);
define('WP_REDIS_DATABASE', 0);
#define('WP_REDIS)


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
    
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ROOT_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" 

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
            --role=author \
            --user_pass="$WP_USER_PASS" \
            --allow-root

fi
wp plugin install redis-cache --allow-root
wp plugin activate redis-cache --allow-root
wp redis enable --allow-root



chown -R www-data:www-data /var/www/html


exec php-fpm8.2 -F





#if ! wp core is-installed --allow-root --path=/var/www/html; then
#    echo "Installing WordPress..."
#    wp core install --allow-root \
#        --url="${DOMAIN_NAME}" \
#        --title="${WP_TITLE}" \
#        --admin_user="$WP_ADMIN_USER" \
#        --admin_password="$WP_ROOT_PASS" \
#        --admin_email="$WP_ADMIN_EMAIL" \
#        --skip-email
#else
#    echo "WordPress is already installed."
#fi

#if [ "$WP_USER" != "$WP_ADMIN_USER" ]; then
#    if ! wp user get "$WP_USER" --allow-root --path=${WP_ROOT} > /dev/null 2>&1; then
#        echo "Creating WordPress User role: Author: $WP_USER"
#        wp user create "$WP_USER" "$WP_USER_EMAIL" \
#            --role=author \
#            --user_pass="$WP_USER_PASS" \
#            --allow-root \
#            --path=/var/www/html
#        echo "User $WP_USER created successfully"
#    else
#        echo "User $WP_USER already exists"
#    fi
#fi