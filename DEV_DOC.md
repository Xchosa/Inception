Developer documentation

## Prerequisites

Before setting up the project, ensure you have:

- Docker and Docker Compose installed
- OpenSSL for certificate generation
- `lftp` for FTP connections: `sudo apt install lftp`
- Access to `/etc/hosts` file (requires sudo)

  generate a secrets/sftpSSL directory and a secrets/ssl directory to store the selfsigned certtificat and key with openssl

## 1. Create Secrets

Generate secret files required by Docker Compose:

```bash
mkdir -p src/secrets

# Database passwords
echo "root_password" > src/secrets/db_root_password
echo "user_password" > src/secrets/db_password

# WordPress admin password
echo "wp_admin_pass" > src/secrets/wp_admin_password

# SFTP password
echo "sftp_pass" > src/secrets/sftp_password
```

# 2. Generate NGINX SSL certificates

openssl req -x509 -nodes -days 365 -newkey rsa:2048 
    -keyout src/secrets/ssl/privKey.pem
    -out src/secrets/ssl/certificate.pem
    -subj "/C=US/ST=State/L=City/O=Organization/CN=poverbec.42.fr"

  for sftpSSL
    ftp-cert.pem
    ftp-key.pem
  for ssl
    certificate.pem
    privKey.pem

### 3. . Create Environment Files

# MariaDB

MYSQL_DATABASE=mydb
MYSQL_USER=paul

# WordPress

WP_ADMIN_USER=SuperUser
WP_ADMIN_EMAIL=super@example.com
WP_USER=paul
WP_USER_EMAIL=paul@example.com
WP_DB_PREFIX=wp_

# FTP

FTP_USER=SuperUser

# Domain

DOMAIN_Name=poverbec.42.fr

## Update System Hosts File

 -is made by the makefile but consider configure it
sudo cp script/hosts /etc/hosts
This maps `poverbec.42.fr` to `127.0.0.1` for local development.

### Quick Start

make up

# This command:

# - Creates required data directories

# - Backs up /etc/hosts

# - Copies custom hosts file

# - Builds and starts all containers with Docker Compose

## Individual Commands

# Start services only (without rebuild)

cd src && docker compose up

# Rebuild after code changes

cd src && docker compose up --build

# Start specific service

cd src && docker compose up --build wordpress

# View logs

cd src && docker compose logs -f
cd src && docker compose logs -f wordpress  # Specific service

# Stop services

make down

# Stop and remove volumes

cd src && docker compose down -v

## Container Management Commands

### View Container Status

# List all running containers

docker ps

# List all containers (including stopped)

docker ps -a

# Check specific service

docker ps | grep ftp
docker ps | grep wordpress
docker ps | grep mariadb

## Execute Commands in Containers

(containers are running or use docker build <wordpress>)
docker compose exec wordpress bash
(executes process in a already running Container)
docker compose logs wordpress

(same directory as compose file => creates a new seperate Container for ) 
(rm flag => deletes container after leaving)
docker compose run --rm --entrypoint sh <wordpress>

# Open interactive shell

docker exec -it wordpress bash
docker exec -it mariadb bash
docker exec -it ftp_server bash

# Check if vsftpd is running

docker exec ftp_server ps aux | grep vsftpd

# Access MariaDB

docker exec -it mariadb mysql -u root -p$(cat /run/secrets/db_root_password)

# WordPress WP-CLI commands

docker exec wordpress wp user list --allow-root
docker exec wordpress wp plugin list --allow-root

### Stop/Remove Containers

# Stop specific container

docker stop ftp_server
docker stop wordpress
docker stop mariadb

# Stop all containers

cd src && docker compose down

# Remove all containers

docker rm $(docker ps -aq) -f

# Remove all images

docker rmi $(docker images -q) -f

## Volume and Storage Management

### Data Persistence Locations

Your project data is stored in `/home/poverbec/data/`:

/home/poverbec/data/
├── mariadb/          # MariaDB persistent database files
└── wordpress/        # WordPress files and uploads
    └── wp-content/
        └── uploads/  # User-uploaded files (accessible via HTTPS)

### Storage Cleanup Commands

# Clean up unused Docker data (containers, networks, build cache)

make clean

# Full cleanup: remove all containers and data directories

make fclean

# This removes:

# - All Docker containers and images

# - All volume data (/home/poverbec/data/mariadb, /home/poverbec/data/wordpress)

# - SSL directories

⚠️ **Warning**: `make fclean` **deletes all data**. Use with caution!
## known Erros 
  Package errors 4 E: Release file for http://deb.debian.org/debian-security/dists/bookworm-security/InRelease is not valid yet (invalid for another 1h 57min 7s). Updates for this repository will not be applied.

  just reset time:
  sudo systemctl restart systemd-timesyncd

## Verify Services Are Running

### Check WordPress

# Using curl (ignores self-signed cert warning)

curl -k https://poverbec.42.fr

# Check SSL certificate

curl --head https://poverbec.42.fr

# Access WordPress admin

# Visit: https://poverbec.42.fr/wp-admin

# Credentials: SuperUser / wp_admin_password_value

### Check MariaDB

docker exec -it mariadb sh
mysql -u root -p$(cat /run/secrets/db_root_password)

# Inside MySQL:

SHOW DATABASES;
USE mydb;
SHOW TABLES;

### Check FTP Server

# Local FTP connection

lftp -u SuperUser localhost:21

# Inside lftp:

> ls
> put /path/to/file.txt
> get filename.txt
> quit

Upload files to `/var/www/html/wp-content/uploads/` and access them at:

https://poverbec.42.fr/wp-content/uploads/filename.txt

### Check NGINX/Reverse Proxy

# Verify NGINX is responding

docker ps | grep nginx

# Check NGINX configuration

docker exec nginx nginx -t

## Makefile Commands Reference

| Command                  | Description                                        |
| ------------------------ | -------------------------------------------------- |
| `make up`              | Build and start all services with proper setup     |
| `make down`            | Stop all services                                  |
| `make debug-wordpress` | Launch interactive WordPress container shell       |
| `make debug-mariaDb`   | Launch interactive MariaDB container shell         |
| `make debug-nginx`     | Launch interactive NGINX container shell           |
| `make backup`          | Export WordPress database to `backup/backup.sql` |
| `make clean`           | Remove containers and clean Docker system          |
| `make fclean`          | Complete cleanup (removes all data)                |
| `make re`              | Clean and rebuild everything                       |
| `make sync-time`       | Synchronize system time (NTP)                      |

docker build .            build current image 
## Troubleshooting
get a endless loop in a containter
#ping -t 127.0.0.1 > /dev/null 2>&1 &
docker logs <container_name>

### Container Exits Immediately

Check logs for errors:
cd src && docker compose logs ftp_server
cd src && docker compose logs wordpress
cd src && docker compose logs mariadb

docker exec -it mariadb bin/bash

## Project Structure

Inception/
├── Makefile                 # Build automation
├── DEV_DOC.md              # This file
├── script/
│   └── hosts               # Custom /etc/hosts entries
├── src/
│   ├── docker-compose.yml  # Service orchestration
│   ├── .env                # Environment variables
│   ├── secrets/            # Certificates and passwords
│   │   ├── ssl/
│   │   │   ├── certificate.pem
│   │   │   └── privKey.pem
│   │   └── sftpSSL/
│   │       ├── ftp-cert.pem
│   │       └── ftp-key.pem
│   └── requirements/       # Custom Dockerfiles
│       ├── nginx/
│       ├── wordpress/
│       ├── mariadb/
│       └── ftp_server/
|
└── data/                   # Persistent volume data (created at runtime)
    ├── mariadb/
    └── wordpress/

## for using the FTP server

needed dependencies
sudo apt install lftp

lftp -u <FTP_USER_env> localhost:21

<FTP_USER_PASS_secrets>
upload via "put"
e.g. put /home/`<user>`/<test.txt>
ls
quit or

(for connecting to VM Filedirectory
 => sftp://<VM_USER>@localhost/ )

check pwd or ls -la

cd wp-content/uploads
e.g. https://poverbec.42.fr/wp-content/uploads/test.txt

Check if specific Container is running:
e.g. FTP server
  docker ps | grep ftp

Stop one specific Container
docker stop ftp_server

Check if vsftpd process is running
docker exec ftp_server ps aux | grep vsftpd

## for using redis service

docker exec -it redis redis-cli

# test:

ping or ping "Hello Redis"

# Expected output:

# PONG

# advanced test

SET mykey "Hello World"
GET mykey
DEL mykey

# SET WordPress cache example

SET "wp:user:1" "admin_user_data"
TTL sessionkey

## Genereral checks

check if wordpress works:
Curl -lk https://poverbec.42.fr

check for self signed certificate
curl --head https://poverbec.42.fr

Execute mariadb setup
Docker exec -t mariadb sh

entere Database as root user
mysql -u root -p$(cat /run/secrets/db_root_password)

https::/poverbec.42.fr//wp-admin

Build a single container:
docker compose up --build wordpress
