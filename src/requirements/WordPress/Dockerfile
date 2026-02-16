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
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates
# copy files from host to container 
# relative Dockerfile loccation to absolute path in container
COPY ./tools/wordpress.sh /wordpress.sh

#add execute permission
RUN chmod +x /wordpress.sh


# run before CMD 
#wordpress becomes the argument to entrypoint 
# /wordpress.sh php-fpm8 -F 
ENTRYPOINT  [ "/wordpress.sh" ]

