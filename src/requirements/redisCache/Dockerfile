#!/bin/bash

FROM debian:bookworm


RUN apt-get update && \
	apt-get install -y \
		redis-server \
	&& rm -rf /var/lib/apt/lists/*

COPY tools/redisCacheScript.sh /redisCacheScript.sh
RUN	chmod +x /redisCacheScript.sh

#RUN mkdir -p /var/lib/redis && \
#	chown redis:redis /var/lib/redis


EXPOSE 6379

ENTRYPOINT [ "/redisCacheScript.sh" ]