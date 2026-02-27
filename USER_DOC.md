User documentation


Services Overview
The Inception stack provides a complete web hosting environment with the following services:

Service		Purpose									Access Point
NGINX		Reverse proxy with SSL/TLS termination	Port 443 (HTTPS)
WordPress	Content management system				https://poverbec.42.fr
MariaDB		Database backend for WordPress			Internal network only
Redis		Caching layer for performance			Internal network only


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
lftp -u SuperUser localhost
-> enter password for wp_admin 
(the inbuild ftp server to transfer your secrets 
sftp://<user>@localhost) to mount your VM File directory


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


Service Dependencies
Services start in order:

MariaDB (with health check)
Redis
WordPress (waits for MariaDB)
NGINX (waits for WordPress)