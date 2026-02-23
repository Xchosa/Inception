# Inception Project
This project has been created as part
of the 42 curriculum by poverbec

Setup:
check if other web server is running 
if yes stop it 
sudo systemctl stop apache2
sudo systemctl disable apache2


Wordpress configuration:
https://poverbec.42.fr/wp-admin


Inception is a Docker-based infrastructure project that implements a multi-service web stack using containerization. The project creates a complete web environment with NGINX as a reverse proxy, WordPress with PHP-FPM, MariaDB for database management, and Redis for caching - all orchestrated through Docker Compose.

The goal is to demonstrate container orchestration skills by building custom Docker images (no pre-built images allowed) and configuring secure inter-container communication. Each service runs in its own isolated container with proper networking, volume management, and SSL/TLS encryption.

Instructions
Prerequisites
	Docker and Docker Compose installed
	Sudo privileges for host file modification
	Available ports: 443, 9000, 3306, 8080


Setup 
# Build and start all services
make up

# Access the services
# WordPress: https://poverbec.42.fr
# WordPress Admin: https://poverbec.42.fr/wp-admin
make down     # Stop all services
make clean    # Remove containers and volumes  
make debug-wordpress  # Debug WordPress container
make debug-mariadb    # Debug MariaDB container

NGINX .
Supports  TLSv1.3 only.
Acts as a reverse proxy for WordPress and the static site.
WordPress

Runs with PHP-FPM
Connected to MariaDB and Redis for database and caching respectively.
MariaDB

Database service for WordPress.
Data stored in a dedicated volume.
Redis

Configured to cache WordPress data.

FTP Server
Provides file transfer access to the WordPress site files for upload, download, and management.
Static Website

A small non-PHP website (e.g., personal portfolio or resume).
Hosted by NGINX as a separate subdomain.
Adminer

Database management tool for MariaDB.
Portainer

Resources:
Docker Container: https://docs.docker.com/compose/

NGINX: 	https://www.youtube.com/watch?v=iInUBOVeBCc
		https://nginx.org/en/docs/

Wordpress: 	https://developer.wordpress.org/advanced-administration/before-install/howto-install/

MariaDB Docker Guide:	https://mariadb.com/docs?q=docker

FTP_Server: https://creativethemes.com/blocksy/blog/what-is-ftp-and-how-to-use-it-in-wordpress/#:~:text=That's%20where%20FTP%20(File%20Transfer,plugin%20that%20broke%20your%20site.

Key Configuration Files
Container orchestration: docker-compose.yml
NGINX config: default.conf
Build automation: Makefile



AI Usage
AI assistance was utilized for:

Dockerfile optimization and best practices
Docker Compose service configuration syntax
SSL certificate configuration for NGINX
WordPress CLI automation scripting
Troubleshooting container networking issues


Project Description
Inception is a containerized infrastructure project that demonstrates advanced Docker orchestration skills through the deployment of a complete LAMP-like web stack. The project implements a multi-service architecture using custom-built Docker containers without relying on pre-built images, showcasing deep understanding of containerization principles and service orchestration.
Architecture
The stack consists of four core services orchestrated through Docker Compose:

NGINX: Reverse proxy with SSL/TLS termination serving on port 443
WordPress: PHP-FPM application server with Redis caching integration
MariaDB: Database backend with persistent storage
Redis: Caching layer for WordPress optimization
Each service runs in isolated containers built from custom Dockerfiles with secure inter-container communication via a dedicated Docker network.

Docker Implementation
Custom Container Images
All services use custom-built images from Debian Bookworm base, ensuring:

Minimal attack surface through targeted package installation
Reproducible builds across environments
Security compliance through controlled dependencies
Service Orchestration
The docker-compose.yml defines:

Service dependencies with health checks
Volume persistence for data integrity
Secret management for credential security
Network isolation for service communication


Technical Comparisons

Virtual Machines vs Docker
Aspect		Virtual Machines					Docker Containers
Resource 	Overhead High (full OS per VM)		Low (shared kernel)
Boot Time	Minutes								Seconds
Isolation 	Level	Hardware-level isolation	Process-level isolation
Portability	Platform-specific					Write once, run anywhere
Use Case	Complete OS environments			Application packaging

Docker's lightweight nature allows the Inception stack to run efficiently with minimal resource consumption while maintaining service isolation.

Secrets vs Environment Variables
Method			Security Level		Visibility					Persistence
Docker 			Secrets	High		Mount-only access			tmpfs (memory)
Environment 	Variables			Low	Process environment		Container(lifecycle)

Secrets are mounted to /run/secrets/ and accessed only by authorized containers, preventing credential exposure in process lists or container inspection.


Docker Network vs Host Network
Network Type			Docker Bridge Network				Host Network

Isolation				Container-to-container isolation	no isolation

Performance				Slight overhead						native performace

Security				Network								Direct


Docker Volumes vs Bind Mounts
Storage Type		Management			Portability		Performance
Docker Volumes		Docker-managed		High			Optimized
Bind Mounts			Host filesystem		Low				Direct access

This approach provides:
Direct data access from host system
Simplified backup procedures
Development environment flexibility
Host filesystem integration

Technical Infrastructure
SSL/TLS Implementation
Custom SSL certificates in ssl
TLS 1.3 enforcement via NGINX configuration
Automatic HTTP to HTTPS redirection
Database Management
MariaDB with custom initialization scripts
Automated database and user creation
Health checks for service readiness
Data persistence through bind mounts
WordPress Integration
WP-CLI for automated installation and configuration
Redis object caching integration
Multi-user setup with role-based access
PHP-FPM optimization for container environments