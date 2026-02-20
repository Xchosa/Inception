FROM debian:bookworm-slim


RUN apt update && apt upgrade -y && \
	apt install -y redis-Server php-redis

ENTRYPOINT [ "/redisCacheScript.sh" ]