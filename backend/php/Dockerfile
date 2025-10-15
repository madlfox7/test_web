FROM php:8.2-fpm-alpine

RUN set -eux; \
    apk add --no-cache $PHPIZE_DEPS icu-dev oniguruma-dev mariadb-client; \
    docker-php-ext-install mysqli pdo pdo_mysql intl mbstring

WORKDIR /var/www/html
