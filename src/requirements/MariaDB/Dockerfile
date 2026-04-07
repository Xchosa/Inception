FROM debian:bookworm


RUN apt update && apt upgrade -y && \
	apt install -y mariadb-server mariadb-client openssl && \
	rm -rf /var/lib/apt/lists/* 
    

COPY ./tools/MariaDB.sh /MariaDB.sh

RUN chmod +x /MariaDB.sh 


ENTRYPOINT  [ "/MariaDB.sh" ]

