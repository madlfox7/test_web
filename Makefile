SHELL := /bin/bash
.ONESHELL:
.DEFAULT_GOAL := help

PORT ?= 3000
NODE_DIR := frontend/tools/node-static

.PHONY: help node-install node-start node-dev node-clean up down restart restart-soft logs seo-set-domain seo-restore seo-clean-backups seo-reset-placeholder seo-restart

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
	@echo "  seo-set-domain   - set your domain in robots.txt and sitemap.xml (use DOMAIN=... or enter interactively)"
	@echo "  seo-restore      - restore robots.txt and sitemap.xml from latest backups (.bak.<timestamp>)"
	@echo "  seo-clean-backups- remove older SEO backups, keep latest N (KEEP=N, default 2)"
	@echo "  seo-reset-placeholder - reset robots.txt and sitemap.xml to placeholder https://example.org"
	@echo "  seo-restart      - restore -> reset to example.org -> apply DOMAIN (wrapper)"

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
	@echo "[reset] Restoring SEO files from backups (if present)"
	$(MAKE) seo-restore || true
	@if [ "$$CLEAN_SEO_BACKUPS" = "1" ]; then \
	  echo "[reset] Cleaning old SEO backups (KEEP=$${KEEP:-2})"; \
	  $(MAKE) seo-clean-backups KEEP=$${KEEP:-2}; \
	fi
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

# Prompt for a domain and replace placeholder example domain in SEO files.
# Usage: make seo-set-domain
seo-set-domain:
	@echo "This will set your site domain in:"
	@echo "  - frontend/public/robots.txt (Sitemap URL)"
	@echo "  - frontend/public/sitemap.xml (all <loc> URLs)"
	@echo "Provide DOMAIN=... or enter when prompted (e.g., example.com or https://example.com). We'll normalize to https://domain and strip trailing slashes."
	@if [ -z "$$DOMAIN" ]; then read -r -p "Domain: " DOMAIN; fi
	if [ -z "$$DOMAIN" ]; then echo "Aborted: empty domain"; exit 1; fi
	# trim spaces
	DOMAIN=$$(echo "$$DOMAIN" | xargs)
	# remove trailing slash(es)
	DOMAIN=$${DOMAIN%/}
	# if no scheme provided, default to https://
	case "$$DOMAIN" in
	  http://*|https://*) ;;
	  *) DOMAIN="https://$$DOMAIN" ;;
	esac
	# keep only scheme://host (drop any path/query if user pasted it)
	BASE=$$(printf '%s\n' "$$DOMAIN" | sed -E 's#^([a-zA-Z][a-zA-Z0-9+.-]*://[^/]+).*#\1#')
	if [ -z "$$BASE" ]; then echo "Aborted: invalid domain"; exit 1; fi
	echo "Using base domain: $$BASE"
	FILES=("frontend/public/robots.txt" "frontend/public/sitemap.xml")
	for f in $${FILES[@]}; do
	  if [ ! -f "$$f" ]; then echo "Warning: $$f not found, skipping"; continue; fi
	  bk="$$f.bak.$$(date +%s)"
	  cp "$$f" "$$bk"
	  # replace common example placeholders (http/https, .com/.org) with provided base
	  sed -i -E "s#https?://example\.(com|org)#$$BASE#g" "$$f"
	  # For sitemap.xml: auto-set <lastmod> to today's date (YYYY-MM-DD)
	  case "$$f" in
	    *sitemap.xml)
	      TODAY=$$(date +%F)
	      if grep -q "<lastmod>" "$$f"; then
	        sed -i -E "s#<lastmod>[^<]+</lastmod>#<lastmod>$$TODAY</lastmod>#g" "$$f"
	      else
	        # If no lastmod present, insert after each <loc> line
	        sed -i -E "/<loc>[^<]+<\\/loc>/a \\ \ \ \ \ <lastmod>$$TODAY<\\/lastmod>" "$$f"
	      fi
	      ;;
	  esac
	  echo "Updated: $$f (backup: $$bk)"
	done
	# show a quick diff-like preview (optional)
	grep -Hn -E "sitemap\.xml|<loc>|<lastmod>|Sitemap:" frontend/public/robots.txt frontend/public/sitemap.xml || true
	echo "Done. Verify: robots.txt and sitemap.xml now use $$BASE."

# Reset robots.txt and sitemap.xml to placeholder example.org safely
seo-reset-placeholder:
	@echo "[seo] Resetting robots.txt and sitemap.xml to placeholder https://example.org"
	FILES=("frontend/public/robots.txt" "frontend/public/sitemap.xml")
	for f in $${FILES[@]}; do
	  if [ ! -f "$$f" ]; then echo "Warning: $$f not found, skipping"; continue; fi
	  bk="$$f.bak.$$(date +%s)"
	  cp "$$f" "$$bk"
	  case "$$f" in
	    *robots.txt)
	      # Force the Sitemap line to placeholder; preserve other lines
	      if grep -qE '^Sitemap:' "$$f"; then
	        sed -i -E 's#^Sitemap:.*#Sitemap: https://example.org/sitemap.xml#' "$$f"
	      else
	        printf '\nSitemap: https://example.org/sitemap.xml\n' >> "$$f"
	      fi
	      ;;
	    *sitemap.xml)
	      # Replace only the host part in <loc> URLs, keep paths
	      sed -i -E 's#(<loc>https?://)[^/]+#\1example.org#g' "$$f"
	      ;;
	  esac
	  echo "[seo] Placeholder set in $$f (backup: $$bk)"
	done

# Wrapper: restore -> reset placeholder -> set domain
# Usage: make seo-restart [DOMAIN=https://your.domain]
seo-restart:
	@echo "[seo] restore -> reset placeholder -> apply DOMAIN"
	$(MAKE) seo-restore || true
	$(MAKE) seo-reset-placeholder
	$(MAKE) seo-set-domain DOMAIN="$$DOMAIN"

# Restore robots.txt and sitemap.xml from the most recent backups created by seo-set-domain
seo-restore:
	@set -e
	FILES=("frontend/public/robots.txt" "frontend/public/sitemap.xml")
	for f in $${FILES[@]}; do
	  latest=$$(ls -1t "$$f".bak.* 2>/dev/null | head -n1 || true)
	  if [ -z "$$latest" ]; then
	    echo "No backup found for $$f; skipping"
	    continue
	  fi
	  curbk="$$f.curr.bak.$$(date +%s)"
	  cp "$$f" "$$curbk" 2>/dev/null || true
	  cp "$$latest" "$$f"
	  echo "Restored: $$f from $$latest (current saved: $$curbk)"
	done

# Remove older backup files for SEO artifacts, keeping the latest N per file.
# Usage: make seo-clean-backups [KEEP=2]
seo-clean-backups:
	@KEEP=$${KEEP:-2}
	TARGETS=("frontend/public/robots.txt" "frontend/public/sitemap.xml")
	for base in $${TARGETS[@]}; do
	  for kind in bak curr.bak; do
	    # List sorted by mtime (newest first)
	    files=$$(ls -1t "$$base.$$kind."* 2>/dev/null || true)
	    [ -z "$$files" ] && continue
	    idx=0
	    for f in $$files; do
	      idx=$$((idx+1))
	      if [ $$idx -le $$KEEP ]; then
	        echo "Keeping: $$f"
	      else
	        rm -f "$$f" && echo "Removed: $$f"
	      fi
	    done
	  done
	done
