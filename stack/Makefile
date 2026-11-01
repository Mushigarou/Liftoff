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
