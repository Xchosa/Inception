#!/bin/bash

set -e

DOMAIN="poverbec.42.fr"
SSL_DIR="/etc/nginx/certs/"
SITES_DIR="/etc/nginx/sites-available"

mkdir -p "$SSL_DIR"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$SSL_DIR/privkey.pem" \
    -out "$SSL_DIR/fullchain.pem" \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=$DOMAIN"

exec nginx -g "daemon off;"