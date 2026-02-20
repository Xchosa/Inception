#!/bin/bash

FROM debian:bookworm-slim


RUN apt update && apt upgrade -y && \
	apt install -y redis-server && \
	#apt-get install -y php-redis && \
	#pecl docker-php-ext-enable redis \ 
	rm -rf /var/lib/apt/lists/*

COPY tools/redisCacheScript.sh /redisCacheScript.sh
RUN	chmod +x /redisCacheScript.sh

RUN mkdir -p /var/lib/redis && \
	chown redis:redis /var/lib/redis

#COPY tools/wp-config.php /etc/redis/wp-config.php

EXPOSE 6379

ENTRYPOINT [ "/redisCacheScript.sh" ]