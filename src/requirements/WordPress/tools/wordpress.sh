#!/bin/bash


set -e

WP_PATH="/usr/loca/bin/wp"

if [ ! -f "WP_PATH"]
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar "WP_PATH"
fi
wp --info --allow-root

exec php-fpm8.4 -F

# https://wp-cli.org/
#curl -0 https://raw.githubusercontent.com/wp-cli/wp-cli/v2.12.0/utils/wp-completion.bash
#source /FULL/PATH/TO/wp-completion.bash
#source ~/.bash_profile