User documentation


Services Overview
The Inception stack provides a complete web hosting environment with the following services:


## Services

**NGINX** - Reverse proxy with TLS 1.3 encryption on port 443

**WordPress** - PHP-FPM application server connected to MariaDB and Redis

**MariaDB** - Database backend with persistent storage

**Redis** - Caching layer for WordPress optimization

**FTP Server** - File transfer access to WordPress files (port 21, 30000-30009)

**Portfolio** - Static website showcasing projects (https://poverbec.42.fr/portfolio)



# Test WordPress
curl -Ik https://poverbec.42.fr

# Access MariaDB
docker exec -it inception-mariadb-1 mysql -u root
docker exec -it inception-mariadb-1 mysql -u root -p
docker exec -it mariadb mysql -u paul -p$(cat /run/secrets/db_user_password) mydb

# Test Redis
connect to Redis container: 
docker exec -it redis redis-cli

docker exec -it redis redis-cli ping

# Check FTP (requires lftp)

lftp -u paulFTP localhost:21
get filename.txt           # Download file
put /local/path/file.txt   # Upload file
mget *.txt                 # Download multiple files (with confirmation)
mput /local/path/*.txt     # Upload multiple files (with confirmation)
rm filename.txt            # Delete file
mv oldname.txt newname.txt # Rename filelk

# Useful options
put -O /var/www/html/ /home/user/file.txt   # Upload with target directory
get -O /home/user/ filename.txt              # Download to specific path



All services communicate through a secure Docker network with SSL encryption enforced.

Project Management
# Build and start all services
make up

# Create required data directories
# Configure host networking
# Build custom Docker images
# Start all services with health checks
# put hosts file from script/hosts to /etc/hosts 		((etc/home/usr))

Website Access
WordPress Frontend
URL: https://poverbec.42.fr

Main website accessible via browser
Automatic HTTP to HTTPS redirect
TLS 1.3 encryption enforced
WordPress Administration
URL: https://poverbec.42.fr/wp-admin

Admin Credentials:

Username: SuperUser (from MYSQL_USER)
Password: Located in wp_admin_password.txt
Author User:

Username: paul (from WP_USER)
Password: Located in wp_user_password.txt
Credential Management
Password Files Location


All credentials are stored in the secrets directory 
(which need to be created for a functiontional containerized project)

File					Purpose					Usage
db_root_password.txt	MariaDB root access		Database administration
db_user_password.txt	WordPress DB user		Application database access
wp_admin_password.txt	WordPress admin	Site 	administration
wp_user_password.txt	WordPress author		Content creation


Environment Configuration
Service configuration managed in .env:

MYSQL_DATABASE=mydb
MYSQL_USER=paul

# WordPress settings  
WP_ADMIN_USER=SuperUser
WP_USER=paul
DOMAIN_Name=poverbec.42.fr



Service Health Verification
WordPress Functionality:
# Test WordPress accessibility
curl -Ik https://poverbec.42.fr

# Check WordPress installation
curl -s https://poverbec.42.fr | grep -i wordpress


Database Connectivity:
# Access MariaDB container
docker exec -it mariadb sh
docker exec -it mariadb-1 mysql -u root -p

# Connect to database
mysql -u paul -p$(cat /run/secrets/db_user_password) mydb

Cache Performance
docker exec -it redis redis-cli monitor
# Check WordPress cache status
# Navigate to WP Admin → Plugins → Redis Object Cache


NGINX Configuration
# Test NGINX configuration
docker exec nginx nginx -t

# Check SSL certificate
openssl s_client -connect poverbec.42.fr:443 -servername poverbec.42.fr

# test FTP
lftp -u paulFTP localhost
-> enter password 
(the inbuild ftp server to transfer your secrets 
sftp://<user>@localhost) to mount your VM File directory

to upload:
e.g. 
put /home/<user>/dataDirectory/*.txt


Data Persistence
Data Persistence
Storage Locations
WordPress files: wordpress
Database data: mariadb


Debug Access
# Debug individual containers
make debug-wordpress
make debug-mariadb  
make debug-nginx

# View container logs
docker logs --follow [container_name]


# run single Container
docker run -p8000:80 website 

Service Dependencies
Services start in order:

MariaDB (with health check)
Redis
WordPress (waits for MariaDB)
NGINX (waits for WordPress)