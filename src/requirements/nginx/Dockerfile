
FROM debian:bookworm

RUN apt update && apt upgrade -y && \
	apt install -y nginx openssl

CMD ["nginx", "-g", "daemon off;"]

# copy files from host to container 
# relative Dockerfile loccation to absolute path in container
COPY ./tools/nginx.sh /nginx.sh

RUN chmod +x /nginx.sh 


ENTRYPOINT  [ "/nginx.sh" ]


