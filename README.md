# test_web


docker compose down -v
docker compose up -d --build


------------------------
convert

convert input.png -background white -alpha remove -alpha off -quality 85 output.jpg


------------------------------


делаем «чистый старт» всего стека — так, будто ты только что развернул проект.

⚠️ Это удалит ВСЕ данные БД (том db_data). Если нужно — заранее сделай дамп:

docker compose exec db mariadb-dump -uroot -ppassword psyaid > backup.sql

Полный ресет и развёртывание
# 1) Остановить и удалить контейнеры + тома (очистит БД)
docker compose down -v

# 2) (необязательно) подчистить висячие образы/кэш
docker system prune -f

# 3) Убедиться, что init-файлы есть:
ls -l api_sql_init/
# → 001_init.sql  (схема + EN сиды + зеркалирование в translations EN)
# → 002_translations.sql  (RU/HY переводы — если уже добавил)

# 4) Поднять всё заново с пересборкой
docker compose up -d --build

# 5) Подождать, пока БД станет healthy
docker inspect --format='{{.State.Health.Status}}' $(docker compose ps -q db)
# → должно быть "healthy"

# 6) Проверка, что таблицы и сиды залились
docker compose exec db mariadb -upsyaid -ppsyaidpass -e "
  USE psyaid;
  SHOW TABLES;
  SELECT COUNT(*) AS specialists FROM specialists;
  SELECT COUNT(*) AS t_en FROM specialist_translations WHERE lang='en';
  SELECT COUNT(*) AS t_ru FROM specialist_translations WHERE lang='ru';
  SELECT COUNT(*) AS t_hy FROM specialist_translations WHERE lang='hy';
"


Если t_ru/t_hy = 0, значит 002_translations.sql отсутствует или не выполнился (например, файл добавили после старта). В этом случае просто применяем вручную:

docker compose exec -T db mariadb -upsyaid -ppsyaidpass psyaid < api_sql_init/002_translations.sql

Перезапуск отдельных сервисов (на будущее)
# перезапустить всё, без удаления данных
docker compose restart

# только nginx (после правок конфигов)
docker compose restart nginx

# только php (после правок PHP)
docker compose restart php

# смотреть логи
docker compose logs -f db
docker compose logs -f php
docker compose logs -f nginx
docker compose logs -f node

Проверки после старта
# API — EN (работает сразу из 001_init.sql)
curl -s "http://localhost/api/specialists.php?tlang=en&q=psych" | head

# API — RU/HY (требуют переводы в specialist_translations)
curl -s "http://localhost/api/specialists.php?tlang=ru&q=псих" | head
curl -s "http://localhost/api/specialists.php?tlang=hy&q=թեր" | head


Открой в браузере:

/ — index автоматически отправит на /en///ru///hy/ (сначала по языку браузера, потом по сохранённому выбору).

/en/specialists.html, /ru/specialists.html, /hy/specialists.html.

Если ты в Codespaces — используй «Forwarded Port 80» URL.

Важно: очистка локального выбора языка

Твой index.html запоминает язык в localStorage:

localStorage.removeItem('PsyAid_lang')
sessionStorage.removeItem('lang_auto_once')



------------------
# 1) Stop and remove containers + volumes (wipes DB)
docker compose down -v

# 2) (optional) cleanup dangling images/cache
docker system prune -f

# 3) Rebuild and start
docker compose up -d --build

# 4) Wait for DB to become healthy (should print 'healthy')
docker inspect --format='{{.State.Health.Status}}' $(docker compose ps -q db)

# 5) Quick sanity checks
docker compose exec db mariadb -upsyaid -ppsyaidpass -e "USE psyaid; SHOW TABLES; SELECT COUNT(*) AS specialists FROM specialists; SELECT COUNT(*) AS t_ru FROM specialist_translations WHERE lang='ru'; SELECT COUNT(*) AS t_hy FROM specialist_translations WHERE lang='hy';"

Makefile shortcuts:
- make restart        # полный ресет: down -v, prune, up --build, ожидание БД, проверки
- make restart-soft   # мягкий рестарт всех сервисов (без удаления томов)

## Optional: локальный превью без Docker (Node)
Node‑сервер вынесен в `tools/node-static/` и не используется контейнерами. Это только для локального превью статики.

Команды (через Makefile):
- make node-install
- make node-start
- PORT=4000 make node-start
- make node-dev
- make node-clean

Примечания:
- Сервер слушает 0.0.0.0; в Codespaces используйте Forwarded Port 3000 URL.
- Основной флоу — Docker (Nginx+PHP+DB). Node — опционально.


-------------------------------
## Security note: SQL dumps
- Не храниw дампы БД (`*.sql`) в `public/` — это может случайно раскрыть данные.  `
- Не коммит экспорты БД в корень репозитория. Добавлен `.gitignore`, который игнорирует `*.sql`, кроме инициализационных скриптов в `api_sql_init/`.

## Local development without Docker (Node static server)
Для локального запуска статики через Node.js добавлен `Makefile`.






Быстрый старт:

1) Установить зависимости
  make install

2) Запустить
  make start

Опции:
- Порт настраивается переменной окружения `PORT` (по умолчанию 3000)
  PORT=4000 make start

- Режим разработки с авто‑перезапуском (nodemon):
  make dev

- Очистить зависимости:
  make clean

Заметки:
- Локальная папка `node_modules/` игнорируется в git и не нужна Docker‑сборкам.
- В docker-compose сейчас нет Node‑сервиса: Nginx раздаёт `public/`, а `api/*.php` обслуживает PHP‑FPM. Node полезен только для локальной статики и быстрых экспериментов.


------------------
# 1) Stop and remove containers + volumes (wipes DB)
docker compose down -v

# 2) (optional) cleanup dangling images/cache
docker system prune -f

# 3) Rebuild and start
docker compose up -d --build

# 4) Wait for DB to become healthy (should print 'healthy')
docker inspect --format='{{.State.Health.Status}}' $(docker compose ps -q db)

# 5) Quick sanity checks
docker compose exec db mariadb -upsyaid -ppsyaidpass -e "USE psyaid; SHOW TABLES; SELECT COUNT(*) AS specialists FROM specialists; SELECT COUNT(*) AS t_ru FROM specialist_translations WHERE lang='ru'; SELECT COUNT(*) AS t_hy FROM specialist_translations WHERE lang='hy';"