FROM debian:bookworm


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/custom.cnf /etc/mysql/mariadb.conf.d/custom.cnf
COPY ./tools/MariaDB.sh /MariaDB.sh

RUN chmod +x /MariaDB.sh 

EXPOSE 3306

ENTRYPOINT  [ "/MariaDB.sh" ]

