.PHONY: down
down:
	docker-compose down --remove-orphans

.PHONY: up
up:
	docker-compose up db app

.PHONY: test
test:
	docker-compose -f docker-compose-test.yml run --rm app
	docker-compose down -v --remove-orphans