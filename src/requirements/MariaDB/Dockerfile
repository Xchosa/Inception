FROM debian:bookworm


RUN apt update && apt upgrade -y && \
	apt install -y mariadb-server mariadb-client openssl && \
	rm -rf /var/lib/apt/lists/* 
    
# relative Dockerfile location to absolute path in container
COPY ./tools/MariaDB.sh /MariaDB.sh

#add execute permission
RUN chmod +x /MariaDB.sh 


ENTRYPOINT  [ "/MariaDB.sh" ]

