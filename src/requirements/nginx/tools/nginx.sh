#!/bin/bash

set -e

DOMAIN="poverbec.42.fr"
SSL_DIR="/etc/nginx/ss1"
SITES_DIR="/etc/nginx/sites-available"

mkdir -p "$SSL_DIR"

exec nginx -g "daemon off;"