
FROM debian:bookworm

RUN apt update && apt upgrade -y && \
	apt install -y nginx openssl iputils-ping && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
COPY ./paulswebsite/app.js /var/www/paulswebsite/app.js
COPY ./paulswebsite/index.html /var/www/paulswebsite/index.html
COPY ./paulswebsite/styles.css /var/www/paulswebsite/styles.css
EXPOSE 443

COPY ./tools/nginx.sh /nginx.sh

RUN chmod +x /nginx.sh 



#ENTRYPOINT [ "ping 8.8.8.8" ]

ENTRYPOINT  [ "/nginx.sh" ]


