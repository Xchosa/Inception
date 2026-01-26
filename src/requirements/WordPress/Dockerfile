FROM debian:bookworm



RUN apt update && apt upgrade -y && apt install -y \
    curl \
    #mysql-client \
    wget \
    gnupg2 \
    lsb-release \
    ca-certificates \
    apt-transport-https && \
    wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y \
    php8.4-fpm \
    php8.4-mysql \
    php8.4-curl \
    php8.4-gd \
    php8.4-mbstring \
    php8.4-xml \
    php8.4-xmlrpc \
    php8.4-zip \
    php8.4-opcache && \
    rm -rf /var/lib/apt/lists/*

    
CMD [ "php-fpm8.4", "-F"]

# copy files from host to container 
# relative Dockerfile loccation to absolute path in container
COPY ./tools/wordpress.sh /wordpress.sh

#add execute permission
RUN chmod +x /wordpress.sh


# run before CMD 
#wordpress becomes the argument to entrypoint 
# /wordpress.sh php-fpm8 -F 
ENTRYPOINT  [ "/wordpress.sh" ]

