#!/bin/bash

set -e

#DOMAIN="poverbec.42.fr"
SSL_DIR="/etc/nginx/certs"
SITES_DIR="/etc/nginx/sites-available"


exec nginx -g "daemon off;"