
FROM debian:bookworm

RUN apt update && apt upgrade -y && \
	apt install -y nginx openssl iputils-ping && \
	rm -rf /var/lib/apt/lists/*

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

COPY ./tools/nginx.sh /nginx.sh

RUN chmod +x /nginx.sh 



#ENTRYPOINT [ "ping 8.8.8.8" ]

ENTRYPOINT  [ "/nginx.sh" ]


