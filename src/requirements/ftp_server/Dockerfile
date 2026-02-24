
FROM debian:bookworm


RUN apt update && apt upgrade -y && \ 
	apt install -y \
	vsftpd && \
	rm -rf /var/lib/apt/lists/* 

COPY ./tools/ftp_server.sh /ftp_server.sh
COPY ./conf/vsftpd.conf /etc/vsftpd.conf

RUN chmod +x /ftp_server.sh

# Expose FTP ports
EXPOSE 21 20 21100-21110

ENTRYPOINT  [ "/ftp_server.sh" ]




