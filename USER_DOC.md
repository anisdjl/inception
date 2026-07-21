# User Documentation
 
Welcome to the **Inception** infrastructure user documentation. This guide provides clear and straightforward instructions for end users and system administrators to manage, access, and monitor the services provided by this stack.
 
---
 
## 1. Provided Services Overview
 
The infrastructure consists of several isolated containerized services connected via an internal Docker network:
 
* **NGINX**: The primary web server and reverse-proxy acting as the single secure HTTPS entry point (Port 443).
* **WordPress + PHP-FPM**: The web content management system running on PHP-FPM.
* **MariaDB**: The relational database management system hosting WordPress data.
* **Redis**: In-memory cache memory service optimizing WordPress performance.
* **FTP Server**: Remote file transfer service providing direct access to WordPress files.
* **Adminer**: Web-based graphical interface for database management.
* **Portainer**: Web-based interface for managing and inspecting Docker containers, networks, and volumes.
* **Static Website**: A lightweight resume showcase page.
---
 
## 2. Managing the Infrastructure (Start & Stop)
 
All operations are managed through the `Makefile` located at the root of the repository.
 
### Start the Infrastructure
 
To build and start all containers in detached mode:
 
```bash
make
```
 
(Alternative: `make build`)
 
### Stop the Infrastructure
 
To stop and remove all active containers without deleting persistent data:
 
```bash
make clean
```
 
### Full Reset (Purge)
 
To stop all containers, remove networks, and permanently delete all persistent volumes/data:
 
```bash
make fclean
```
 
---
 
## 3. Accessing Web Applications
 
Make sure `adjelili.42.fr` is mapped to `127.0.0.1` in your local `/etc/hosts` file.
 
| Service | Web URL / Access | Description |
|---|---|---|
| WordPress Main Site | https://adjelili.42.fr/ | Primary WordPress website |
| WordPress Admin Panel | https://adjelili.42.fr/wp-admin/ | WordPress administration dashboard |
| Adminer (Database GUI) | https://adjelili.42.fr/adminer/ | Web interface to manage MariaDB |
| Portainer (Docker GUI) | https://adjelili.42.fr/portainer/ | Interface to inspect the Docker stack |
| Static Website | https://adjelili.42.fr/cv/ | Personal resume page |
 
---
 
## 4. Locating and Managing Credentials
 
To maintain strict security standards, no hardcoded passwords are present in the source code or Dockerfiles.
 
* **Environment Variables (`srcs/.env`)**: Contains non-sensitive configuration keys such as domain names, database names, and non-admin usernames.
* **Secrets Directory (`secrets/`)**: Sensitive credentials (database root password, database user password, WordPress admin credentials, FTP credentials) are stored in individual plain-text files inside the `secrets/` directory.
### How to Modify Credentials
 
1. Stop the infrastructure (`make clean`).
2. Update the target secret file inside the `secrets/` directory (e.g., `secrets/db_password.txt`).
3. Restart the infrastructure (`make`).
---
 
## 5. Checking Service Health & Status
 
### Check Running Containers
 
Run the following command in your host terminal to verify that all containers are active:
 
```bash
docker compose -f srcs/docker-compose.yml ps
```
 
### Inspect Live Logs
 
To view realtime logs across all services:
 
```bash
docker compose -f srcs/docker-compose.yml logs -f
```
 
To inspect a specific service (e.g., nginx):
 
```bash
docker compose -f srcs/docker-compose.yml logs -f nginx
```
 
### Quick CLI Connection Test
 
You can quickly check if HTTPS endpoints are responding using `curl`:
 
```bash
curl -k https://adjelili.42.fr/
curl -k https://adjelili.42.fr/adminer/
```
 
(The `-k` flag ignores warnings caused by the self-signed SSL/TLS certificate).
