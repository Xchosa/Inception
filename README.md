# Inception Project

🧠 Introduction
The Inception project is a DevOps-oriented exercise designed to help you master container orchestration using Docker and Docker Compose. Through this project, you'll gain hands-on experience in setting up and managing a complete multi-service infrastructure within a virtualized environment. You’ll learn how to build your own Docker images, configure services to work seamlessly together, and ensure secure and performant inter-container communication. This project touches on a wide range of essential DevOps concepts, including networking, volumes, secure service exposure, and caching.

📦 Project Overview
This infrastructure runs entirely using Docker Compose with self-written Dockerfiles (no pre-made images), and each service runs in its own dedicated container.

🧱 Services & Containers
NGINX

Serves as the web server.
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

Provides a GUI for Docker container and volume management.
🌐 Networking
All services are connected through a custom Docker network that enables secure and isolated communication between containers.

🔧 Build & Run
All Docker images are built from the project’s Dockerfiles and managed using a Makefile.

Example commands:

make up      # Starts all services using docker-compose
make down    # Stops and removes containers and networks