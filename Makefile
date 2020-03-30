.PHONY: down
down:
	docker-compose down --remove-orphans

.PHONY: up
up:
	docker-compose up db app

.PHONY: test
test:
	docker-compose build
	docker-compose up -d app db1
	docker-compose exec app sh -c "mix test"
	docker-compose down -v --remove-orphans