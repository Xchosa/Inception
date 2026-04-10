#!/bin/bash

set -e


#envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template \
#  	> /etc/nginx/conf.d/default.conf


exec nginx -g "daemon off;"