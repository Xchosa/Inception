FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
     && rm -rf /var/lib/apt/lists/*

COPY ./tools/ /var/www/html/
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g" , "daemon off;"]