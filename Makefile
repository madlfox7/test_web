SHELL := /bin/bash
.DEFAULT_GOAL := help

PORT ?= 3000
NODE_DIR := tools/node-static

.PHONY: help node-install node-start node-dev node-clean up down restart restart-soft logs

help:
	@echo "Targets:"
	@echo "  node-install     - npm install in $(NODE_DIR)"
	@echo "  node-start       - start local static server (PORT=$(PORT))"
	@echo "  node-dev         - start with nodemon"
	@echo "  node-clean       - remove $(NODE_DIR)/node_modules"
	@echo "  up               - docker compose up -d --build"
	@echo "  down             - docker compose down"
	@echo "  restart          - FULL reset: down -v, prune, up --build, wait db healthy, sanity checks"
	@echo "  restart-soft     - soft restart all services (docker compose restart)"
	@echo "  logs             - docker compose logs -f"

node-install:
	@cd $(NODE_DIR) && if [ -f package-lock.json ]; then npm ci; else npm install; fi

node-start:
	@echo "Starting on http://localhost:$(PORT)"
	@cd $(NODE_DIR) && PORT=$(PORT) npm start

node-dev:
	@echo "Starting dev server with nodemon on http://localhost:$(PORT)"
	@cd $(NODE_DIR) && PORT=$(PORT) npm run dev

node-clean:
	rm -rf $(NODE_DIR)/node_modules

up:
	docker compose up -d --build

down:
	docker compose down

restart:
	@echo "[reset] Full reset: down -v, prune, up --build"
	docker compose down -v
	# Optional cleanup of dangling images/cache
	docker system prune -f
	docker compose up -d --build
	@echo "[reset] Waiting for DB to become healthy..."
	@for i in {1..60}; do \
		ID=$$(docker compose ps -q db); \
		STATUS=$$(docker inspect --format='{{.State.Health.Status}}' $$ID 2>/dev/null || echo "starting"); \
		echo "db health: $$STATUS"; \
		if [ "$$STATUS" = "healthy" ]; then break; fi; \
		sleep 2; \
	done
	@echo "[reset] Sanity checks:" 
	docker compose exec db mariadb -upsyaid -ppsyaidpass -e "USE psyaid; SHOW TABLES; SELECT COUNT(*) AS specialists FROM specialists; SELECT COUNT(*) AS t_ru FROM specialist_translations WHERE lang='ru'; SELECT COUNT(*) AS t_hy FROM specialist_translations WHERE lang='hy';"

restart-soft:
	docker compose restart

logs:
	docker compose logs -f
