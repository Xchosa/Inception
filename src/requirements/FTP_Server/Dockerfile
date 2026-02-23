
FROM debian:bookworm


RUN apt update && apt upgrade -y && \ 
	apt install -y \
	vsftpd \
	rm -rf /var/lib/apt/lists/*

COPY .tools/FTP_Server.sh /FTP_Server.sh

RUN chmod +x /FTP_Server.sh

# Expose FTP ports
EXPOSE 21 20 21100-21110

ENTRYPOINT  [ "/FTP_Server.sh" ]




