
FROM debian:bookworm


RUN apt update && apt upgrade -y && \ 
	apt install -y \
	net-tools \
	iproute2 \
	vsftpd && \
	rm -rf /var/lib/apt/lists/* 

# copy to container root dirc , place nf file to  
COPY ./tools/ftp_server.sh /ftp_server.sh 
COPY ./conf/vsftpd.conf /etc/vsftpd.conf

RUN chmod +x /ftp_server.sh

# Expose FTP ports
EXPOSE 21 30000-30009

ENTRYPOINT  [ "/ftp_server.sh" ]




