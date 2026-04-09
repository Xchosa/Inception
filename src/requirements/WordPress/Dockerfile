FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    mariadb-client \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    ca-certificates \
    php-redis \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY ./tools/wordpress.sh /wordpress.sh


RUN chmod +x /wordpress.sh


ENTRYPOINT  [ "/wordpress.sh" ]

