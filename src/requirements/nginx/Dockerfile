
FROM debian:bookworm

RUN apt update && apt upgrade -y && \
	apt install -y nginx openssl iputils-ping


COPY ./tools/landingPage /var/www/html 

#CMD ["ping", "8.8.8.8"]
#CMD ["nginx", "-g", "daemon off;"]
COPY ./conf/nginx.conf  /etc/nginx/nginx.conf

EXPOSE 443
# copy files from host to container 
# relative Dockerfile loccation to absolute path in container
COPY ./tools/nginx.sh /nginx.sh

RUN chmod +x /nginx.sh 



#ENTRYPOINT [ "ping 8.8.8.8" ]

ENTRYPOINT  [ "/nginx.sh" ]



# umleiten auf Homeseite mit 4 buttens -> zu jeweiligen container, wordpress, eigen webseite, one page php fuer mariadb 
# diese lading page var/www/html 


#difference cmd and Entrypoint
#ngix so configuieren das er den server.conf ausfuehrt 

