NAME = inception

DOCKER_COMPOSE = srcs/docker-compose.yml
DATA_DIR = /home/adjelili/data

all: build

build:
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	docker compose -f $(DOCKER_COMPOSE) up --build -d

down:
	docker compose -f $(DOCKER_COMPOSE) down

clean: down
	docker system prune -a -f

fclean: clean
	docker volume rm $(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf $(DATA_DIR)

re: clean build

.PHONY: all build down clean fclean re