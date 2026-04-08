#!/bin/bash

set -e


SSL_DIR="/etc/nginx/certs"
SITES_DIR="/etc/nginx/sites-available"


exec nginx -g "daemon off;"