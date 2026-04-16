**Project Description**
Inception is a containerized infrastructure project that demonstrates advanced Docker orchestration skills through the deployment of a complete LAMP-like web stack. The project implements a multi-service architecture using custom-built Docker containers without relying on pre-built images, showcasing deep understanding of containerization principles and service orchestration.

Architecture
The stack consists of five core services orchestrated through Docker Compose:

**NGINX**: Reverse proxy with SSL/TLS termination serving on port 443
- Routes WordPress requests to PHP-FPM
- Serves static portfolio website on dedicated subdomain (https://poverbec.42.fr/portfolio)
- Enforces TLS 1.3 encryption for all connections

**WordPress**: PHP-FPM application server with Redis caching integration
- CMS for main website content
- Integrated with MariaDB for data persistence
- Redis object caching for performance optimization

**MariaDB**: Database backend with persistent storage
- Stores WordPress data and user information
- Health checks ensure readiness before dependent services start

**Redis**: Caching layer for WordPress optimization
- Improves performance through object caching
- Reduces database load for frequently accessed data

**Portfolio Website**: Static web application hosted via NGINX
- Modern single-page portfolio site with HTML/CSS/JavaScript
- Located at `paulswebsite/` directory
- Showcases projects and personal information
- Accessible via subdomain routing in NGINX configuration

Each service runs in isolated containers built from custom Dockerfiles with secure inter-container communication via a dedicated Docker network.

Docker Implementation

Custom Container Images
All services use custom-built images from Debian Bookworm base, ensuring:
- Minimal attack surface through targeted package installation
- Reproducible builds across environments
- Security compliance through controlled dependencies

Service Orchestration
The docker-compose.yml defines:
- Service dependencies with health checks
- Volume persistence for data integrity
- Secret management for credential security
- Network isolation for service communication

Instructions
Prerequisites
	Docker and Docker Compose installed
	Sudo privileges for host file modification
	Available ports: 443, 9000, 3306

Setup 
1. **Initial Configuration**

   Run the setup script to generate necessary environment files, secrets, and host configurations.
   ```bash
   make setup
   ```
   This command will:
   - Create a default `.env` file.
   - Generate self-signed SSL certificates and other required secrets.
   - Add `poverbec.42.fr` to your `/etc/hosts` file, pointing to `127.0.0.1`.

2. **Build and Run Containers**

   Build the Docker images and start all services in detached mode.
   ```bash
   make up
   ```
   This will start NGINX, WordPress, MariaDB, Redis, and the FTP server.

3. **Stopping the Application**

   To stop the running containers without deleting data:
   ```bash
   make down
   ```

4. **Cleaning Up**

   To stop containers and remove all associated volumes (this will delete your database and WordPress files):
   ```bash
   make clean
   ```

   To perform a full clean, which also removes the host data directories:
   ```bash
   make fclean
   ```



**Access Services:**
- WordPress: https://poverbec.42.fr
- WordPress Admin: https://poverbec.42.fr/wp-admin
- paulswebsite: https://poverbec.42.fr/paulswebsite

---

## Technical Comparisons

### Virtual Machines vs Docker

| Aspect | Virtual Machines | Docker Containers |
|---|---|---|
| Resource Overhead | High (full OS per VM) | Low (shared kernel) |
| Boot Time | Minutes | Seconds |
| Isolation Level | Hardware-level | Process-level |
| Portability | Platform-specific | Write once, run anywhere |
| Use Case | Complete OS environments | Application packaging |

### Secrets vs Environment Variables

| Method | Security Level | Visibility | Persistence |
|---|---|---|---|
| Docker Secrets | High | Mount-only access | tmpfs (memory) |
| Environment Variables | Low | Process environment | Container lifecycle |

**Note:** Secrets are mounted to `/run/secrets/` and accessed only by authorized containers, preventing credential exposure.

### Docker Network vs Host Network

| Aspect | Docker Bridge Network | Host Network |
|---|---|---|
| Isolation | Container-to-container isolation | No isolation |
| Performance | Slight overhead | Native performance |
| Security | Network-isolated | Direct exposure |

### Docker Volumes vs Bind Mounts

| Storage Type | Management | Portability | Performance |
|---|---|---|---|
| Docker Volumes | Docker-managed | High | Optimized |
| Bind Mounts | Host filesystem | Low | Direct access |

---

## Technical Infrastructure

### SSL/TLS Implementation
- Custom SSL certificates in `ssl/` directory
- TLS 1.3 enforcement via NGINX configuration
- Automatic HTTP to HTTPS redirection

### Database Management
- MariaDB with custom initialization scripts
- Automated database and user creation
- Health checks for service readiness
- Data persistence through bind mounts

### WordPress Integration
- WP-CLI for automated installation and configuration
- Redis object caching integration
- Multi-user setup with role-based access
- PHP-FPM optimization for container environments

---

## Configuration Files

| File | Purpose |
|---|---|
| `docker-compose.yml` | Container orchestration |
| `default.conf` | NGINX configuration |
| `Makefile` | Build automation |

---

## Resources

| Topic | Links |
|---|---|
| **Docker** | [Docker Compose Docs](https://docs.docker.com/compose/) |
| **NGINX** | https://www.youtube.com/watch?v=iInUBOVeBCc
		https://nginx.org/en/docs/ [Documentation](https://nginx.org/en/docs/) |
| **WordPress** | [Installation Guide](https://developer.wordpress.org/advanced-administration/before-install/howto-install/) |
| **MariaDB** | [Docker Guide](https://mariadb.com/docs?q=docker) |
| **FTP Server** | [FTP in WordPress](https://creativethemes.com/blocksy/blog/what-is-ftp-and-how-to-use-it-in-wordpress/#:~:text=That's%20where%20FTP%20(File%20Transfer,plugin%20that%20broke%20your%20site.

---

## AI Usage

AI assistance was utilized for:
- Dockerfile optimization and best practices
- Docker Compose service configuration syntax
- SSL certificate configuration for NGINX
- WordPress CLI automation scripting
- Troubleshooting container networking issues
