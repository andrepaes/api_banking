.PHONY: down
down:
	docker-compose down -v --remove-orphans

.PHONY: up
up:
	docker-compose up app db

.PHONY: up-iterative
up-iterative:
	docker-compose up -d
	docker exec -it app bash

.PHONY: test
test:
	docker-compose -f docker-compose-test.yml run --rm app
	docker-compose down -v --remove-orphans