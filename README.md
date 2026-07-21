*This project has been created as part of the 42 curriculum by adjelili.*

# Inception - System Administration with Docker

## Description

This project aims to broaden knowledge in system administration by designing and deploying a multi-container web infrastructure using **Docker Compose**. Entirely hosted inside a dedicated Virtual Machine, the infrastructure isolates every service in its own container, built strictly from custom Dockerfiles based on Debian Bookworm.

### Mandatory Services

* **NGINX**: Acts as the sole entry point to the infrastructure via HTTPS (Port 443) using TLSv1.2/TLSv1.3 protocols.
* **WordPress + PHP-FPM**: A content management system (CMS) executing PHP code via PHP-FPM, isolated from NGINX.
* **MariaDB**: A relational database management system used to store WordPress structured data.

### Bonus Services

* **Redis**: In-memory data store used as an object cache for WordPress to accelerate response times and reduce database queries.
* **FTP Server**: File Transfer Protocol server providing direct access to WordPress files for remote file management.
* **Adminer**: A lightweight database management GUI accessible via web interface.
* **Static Website**: A responsive HTML/CSS personal resume showcase page.
* **Portainer**: A management web GUI providing an overview of containers, images, volumes, and network metrics.

---

## Instructions

### Prerequisites

* Docker & Docker Compose installed on your Virtual Machine.
* `make` utility installed.
* `adjelili.42.fr` domain configured in your `/etc/hosts` file pointing to `127.0.0.1`.

### Setup & Launch

1. **Clone the repository:**

   ```bash
   git clone <repository_url> inception && cd inception
   ```

2. **Configure Environment and Secrets:**

   Create a `srcs/.env` file with environment variables (domain name, database name, non-sensitive usernames) and populate the `secrets/` directory with required password files.

3. **Build and start the infrastructure:**

   ```bash
   make
   ```

   (or `make build`)

### Accessing Services

* **WordPress Website**: https://adjelili.42.fr/
* **Adminer (Database GUI)**: https://adjelili.42.fr/adminer/
* **Portainer (Docker Management)**: https://adjelili.42.fr/portainer/
* **Static Resume**: https://adjelili.42.fr/cv/

### Shutdown & Cleanup

* **Stop containers:**

  ```bash
  make clean
  ```

* **Stop containers and remove volumes (destroys persistent data):**

  ```bash
  make fclean
  ```

---

## Resources

* Official Docker Documentation
* Official Docker Compose Documentation
* Grademe Inception Guide

### AI Usage Disclosure

Generative AI (Gemini) was utilized during this project as an educational assistant to:

* Clarify Docker architecture concepts (PID 1, network isolation, bind mounts vs named volumes).
* Assist in writing and optimizing lightweight Dockerfiles and NGINX reverse-proxy configuration directives.
* Troubleshoot container interactions and review technical comparisons for documentation purposes.

---

## Project Description & Architectural Choices

### Architectural Choices

* **Container Isolation**: Every service runs inside a dedicated container to guarantee modularity, easy debugging, independent scaling, and tight security scope.
* **Single Entry Point Routing**: Instead of exposing multiple public ports, NGINX acts as a reverse-proxy routing requests (`/adminer/`, `/cv/`, `/portainer/`) internally over the isolated Docker network via Port 443.

### Technical Comparisons

#### Virtual Machines vs Docker Containers

* **Virtual Machines**: Hypervisor-based virtualization running a complete guest operating system with its own kernel. Highly isolated but resource-heavy.
* **Docker Containers**: OS-level virtualization sharing the host kernel while isolating user space. Extremely lightweight, fast startup time, and lower memory footprint.

#### Secrets vs Environment Variables

* **Environment Variables (`.env`)**: Global configurations stored in plain text. Ideal for non-sensitive data like domain names or service ports.
* **Secrets**: Sensitive credentials (passwords, private keys) mounted as temporary in-memory files (`/run/secrets/`), preventing leaks in image layers or environment logs.

#### Docker Network vs Host Network

* **Docker Network (Bridge)**: A private, isolated virtual network created by Docker Compose. Containers communicate securely using service names as hostname aliases without exposing internal ports to the host.
* **Host Network**: Bypasses Docker network isolation, placing the container directly on the host's network interface. Insecure for multi-tenant environments and forbidden by the subject.

#### Docker Volumes vs Bind Mounts

* **Docker Volumes**: Persistent storage managed entirely by Docker inside the host filesystem (`/var/lib/docker/volumes/` or `/home/login/data`). High performance, isolated from host modifications, and persistent across container lifecycles.
* **Bind Mounts**: Maps a specific directory from the host filesystem directly into a container. Useful during development for live code reloading, but tightly coupled to host path structures.