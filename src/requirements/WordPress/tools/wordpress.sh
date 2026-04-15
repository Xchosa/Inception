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
        --dbhost="${MYSQL_HOST}:3306" \
        --allow-root \
        --skip-check \
        --extra-php <<'EOF'

define('WP_CACHE', true);
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_TIMEOUT', 1);
define('WP_REDIS_READ_TIMEOUT', 1);
define('WP_REDIS_DATABASE', 0);


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

