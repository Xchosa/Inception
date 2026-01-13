FROM debian:bookworm


RUN apt update && apt upgrade -y && \
	apt install -y mariadb-server mariadb-client openssl && \
	rm -rf /var/lib/apt/lists/*
    
#rm package lists 
CMD [ "php-fpm8.4", "-F"]

# copy files from host to container 
# relative Dockerfile loccation to absolute path in container
COPY ./tools/MariaDB.sh /MariaDB.sh

#add execute permission
RUN chmod +x /MariaDB.sh 


# run before CMD 
#wordpress becomes the argument to entrypoint 
# /wordpress.sh php-fpm8 -F 
ENTRYPOINT  [ "/MariaDB.sh" ]

