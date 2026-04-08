FROM debian:bookworm


RUN apt update && apt upgrade -y && \
	apt install -y mariadb-server mariadb-client && \
	rm -rf /var/lib/apt/lists/* 
    
COPY ./conf/default.conf /etc/mysql/mariadb.conf.d/default.conf
COPY ./tools/MariaDB.sh /MariaDB.sh

RUN chmod +x /MariaDB.sh 

EXPOSE 3306

ENTRYPOINT  [ "/MariaDB.sh" ]

