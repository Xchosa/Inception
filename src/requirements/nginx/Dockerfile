
FROM debian:bookworm

RUN apt update && apt upgrade -y && \
	apt install -y nginx openssl iputils-ping

#CMD ["ping", "8.8.8.8"]
#CMD ["nginx", "-g", "daemon off;"]

# copy files from host to container 
# relative Dockerfile loccation to absolute path in container
COPY ./tools/nginx.sh /nginx.sh

RUN chmod +x /nginx.sh 


#ENTRYPOINT [ "ping 8.8.8.8" ]

ENTRYPOINT  [ "/nginx.sh" ]




#difference cmd and Entrypoint
#ngix so configuieren das er den server.conf ausfuehrt 

