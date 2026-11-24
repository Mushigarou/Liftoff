DOCKER_EXEC=docker compose exec
NGINX_CONTAINER=nginx

# ****************** DOCKER *********************
up:
	docker compose up -d

ls:
	@echo '************  Images ************\n\n'
	@docker image ls
	@echo '\n'

	@echo '************  Volumes ************\n\n'
	@docker volume ls
	@echo '\n'

	@echo '************  Network ************\n\n'
	@docker network ls
	@echo '\n'

down:
	@docker compose down -v --remove-orphans

# ****************** NGINX *********************
n-bash:
	${DOCKER_EXEC} -it ${NGINX_CONTAINER} bash

n-reload:
	${DOCKER_EXEC} ${NGINX_CONTAINER} nginx -s reload

n-reopen:
	${DOCKER_EXEC} ${NGINX_CONTAINER} nginx -s reopen

n-quit:
	${DOCKER_EXEC} ${NGINX_CONTAINER} nginx -s quit

n-stop:
	${DOCKER_EXEC} ${NGINX_CONTAINER} nginx -s stop
