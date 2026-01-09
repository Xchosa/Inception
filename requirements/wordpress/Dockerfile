FROM debian:bookworm



RUN apt update && apt upgrade -y && \
    apt install -y lsb-release apt-transport-https ca-certificates wget gnupg2 && \
    wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt update && \
	apt install -y php8.4-fpm php8.4-mysql php8.4-curl php8.4-gd php8.4-mbstring php8.4-xml php8.4-xmlrpc php8.4-zip php8.4-opcache


	CMD [ "php-fpm8.4", "-F"]


