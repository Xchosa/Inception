
FROM debian:bookworm

RUN apt update && apt upgrade -y && \
	apt install -y nginx openssl iputils-ping && \
	rm -rf /var/lib/apt/lists/*



# own landing page for later 
#COPY ./tools/landingPage /var/www/html 

#CMD ["ping", "8.8.8.8"]
#CMD ["nginx", "-g", "daemon off;"]



#RUN rm -f /etc/nginx/sites-enabled/default

COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

#COPY ./conf/default.conf  /etc/nginx/nginx.conf
#CMD ["ping", "8.8.8.8"]
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

