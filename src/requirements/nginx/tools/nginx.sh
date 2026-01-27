#!/bin/bash

set -e

DOMAIN="poverbec.42.fr"
SSL_DIR="/etc/nginx/certs"
SITES_DIR="/etc/nginx/sites-available"

#


#mkdir -p "$SSL_DIR"

#cp /run/secrets/certificate.pem  "$SSL_DIR/certificate.pem"
#cp /run/secrets/privKey.pem  "$SSL_DIR/privKey.pem"

#only readable by ngnix
#chmod 600 "$SSL_DIR/privKey.pem" 

## read and write 
#chmod 644 "$SSL_DIR/certificate.pem"

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#    -keyout "$SSL_DIR/privkey.pem" \
#    -out "$SSL_DIR/fullchain.pem" \
#    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=$DOMAIN"

exec nginx -g "daemon off;"