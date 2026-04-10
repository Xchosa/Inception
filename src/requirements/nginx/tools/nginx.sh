#!/bin/bash

set -e


#SSL_DIR="/etc/nginx/certs"
#SITES_DIR="/etc/nginx/sites-available"

envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf > /etc/nginx/sites-available/default


exec nginx -g "daemon off;"