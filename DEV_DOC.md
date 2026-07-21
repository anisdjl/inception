# Developer Documentation
 
This documentation is intended for developers maintaining or extending the **Inception** multi-container infrastructure. It details the setup process, architecture design, build execution, and data persistence management.
 
---
 
## 1. Setting Up the Environment from Scratch
 
### Prerequisites
 
Ensure the host machine (Debian/Ubuntu Virtual Machine) has the following tools installed:
 
* **GNU Make** (`make`)
* **Docker Engine** (v24.0+ recommended)
* **Docker Compose Plugin** (`docker compose` v2.0+)
* **Git**
Ensure your current user is added to the `docker` group to execute commands without `sudo`:
 
```bash
sudo usermod -aG docker $USER && newgrp docker
```
 
Configure your host `/etc/hosts` file to resolve the domain name locally:
 
```bash
echo "127.0.0.1 adjelili.42.fr" | sudo tee -a /etc/hosts
```
 
### Configuration Files & Secrets Setup
 
The repository architecture follows strict separation between code, public configuration variables, and private secrets.
 
#### 1. Directory Tree Overview
 
```
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/                # Ignored by Git (contains credentials)
│   ├── db_password.txt
│   ├── db_root_password.txt
│   └── wp_admin_password.txt
└── srcs/
    ├── .env                # Non-sensitive environment variables
    ├── docker-compose.yml
    └── requirements/
        ├── bonus/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```
 
#### 2. Environment Variables (`srcs/.env`)
 
Create `srcs/.env` with non-sensitive runtime parameters:
 
```
DOMAIN_NAME=adjelili.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
WP_ADMIN_USER=site_admin
WP_ADMIN_EMAIL=admin@adjelili.42.fr
WP_TITLE=Inception
```
 
#### 3. Docker Secrets (`secrets/`)
 
Create the `secrets/` directory and generate plain-text files containing raw passwords without newlines:
 
```bash
mkdir -p secrets
echo -n "user_password_here" > secrets/db_password.txt
echo -n "root_password_here" > secrets/db_root_password.txt
echo -n "admin_password_here" > secrets/wp_admin_password.txt
```
 
---
 
## 2. Building & Launching the Infrastructure
 
The project lifecycle is fully controlled via the root `Makefile`.
 
### Core Build Commands
 
**Build and Start (Default):**
 
```bash
make
```
 
(Triggers `docker compose -f srcs/docker-compose.yml up -d --build`)
 
**Stop Services:**
 
```bash
make stop
```
 
**Clean Containers & Networks:**
 
```bash
make clean
```
 
**Full Reset (Deletes Images, Containers, Networks & Persistent Volumes):**
 
```bash
make fclean
```
 
**Rebuild Everything from Scratch:**
 
```bash
make re
```
 
---
 
## 3. Developer CLI & Container Operations
 
### Inspecting Infrastructure State
 
List active containers:
 
```bash
docker compose -f srcs/docker-compose.yml ps
```
 
Inspect container networks & IP allocation:
 
```bash
docker network inspect srcs_inception_network
```
 
### Live Log Streaming
 
Stream all service logs:
 
```bash
docker compose -f srcs/docker-compose.yml logs -f
```
 
Stream specific container logs (e.g., WordPress or MariaDB):
 
```bash
docker compose -f srcs/docker-compose.yml logs -f wordpress
docker compose -f srcs/docker-compose.yml logs -f mariadb
```
 
### Debugging Inside Containers
 
To open an interactive shell inside a running container:
 
```bash
docker exec -it mariadb bash
# or
docker exec -it wordpress sh
```
 
---
 
## 4. Data Storage & Persistence Mechanism
 
In compliance with the project specifications, persistent storage is handled using Docker Named Volumes mapped to custom host locations under `/home/adjelili/data`.
 
### Persistent Volume Mapping
 
| Volume Name | Target Host Directory | In-Container Mount Point | Purpose |
|---|---|---|---|
| `mariadb_data` | `/home/adjelili/data/mariadb` | `/var/lib/mysql` | MariaDB relational database files |
| `wordpress_data` | `/home/adjelili/data/wordpress` | `/var/www/html` | WordPress core files and user uploads |
| `portainer_data` | `/home/adjelili/data/portainer` | `/data` | Portainer configuration & session state |
 
### Volume Configuration (`docker-compose.yml` snippet)
 
Volumes are declared at the root of `docker-compose.yml` using the `local` driver options:
 
```yaml
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/adjelili/data/mariadb'
 
  wordpress_data:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/adjelili/data/wordpress'
```
 
### Persistence Lifecycle
 
* **Container Recreation**: Running `docker compose down` followed by `docker compose up` destroys and recreates the containers, but the host path `/home/adjelili/data` remains untouched.
* **Initial Population**: On first startup, if the volume directory is empty, Docker automatically copies initial setup files from the container image into the host directory.
* **Data Erasure**: Data is only wiped when explicitly executing `make fclean`, which removes the host volume directories.
 
