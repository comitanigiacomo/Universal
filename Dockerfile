FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo_pgsql pgsql

COPY . /var/www/html/

RUN a2enmod rewrite

WORKDIR /var/www/html/

# Espone la porta 80
EXPOSE 80
