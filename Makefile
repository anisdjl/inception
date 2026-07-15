NAME = inception

DOCKER_COMPOSE = requirements/docker-compose.yml
DATA_DIR = /home/adjelili/data

all: build

build:
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	docker compose -f $(DOCKER_COMPOSE) up --build -d