#!/bin/bash

set -e


#envsubst '${DOMAIN_NAME}' < /etc/nginx/template/nginx.conf.template > /etc/nginx/template/nginx.conf
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"