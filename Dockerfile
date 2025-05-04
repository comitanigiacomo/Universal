FROM php:8.4-apache

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pgsql pdo pdo_pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY webapp/ /var/www/html/

RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]