#!/bin/bash

set -e


envsubst '${DOMAIN_NAME}' < /etc/nginx/template/default.conf.template > /etc/nginx/conf.d/default.conf


exec nginx -g "daemon off;"