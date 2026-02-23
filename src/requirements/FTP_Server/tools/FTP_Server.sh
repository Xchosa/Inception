#!/bin/bash


cd /home/poverbec/Inception/secrets/ftpSSL

# Generate private key and certificate in one command
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ftp-key.pem \
    -out ftp-cert.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"


RUN useradd -m -s /bin/bash ftpuser && \
    mkdir -p /home/ftpuser/ftp && \
    chown ftpuser:ftpuser /home/ftpuser/ftp && \
    chmod 755 /home/ftpuser/ftp


# Copy FTP configuration
COPY vsftpd.conf /etc/vsftpd.conf

# Expose FTP ports
EXPOSE 21 20 21100-21110

# Start FTP service
CMD ["vsftpd", "/etc/vsftpd.conf"]