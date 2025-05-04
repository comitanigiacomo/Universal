FROM php:8.1-apache-bullseye-slim

RUN docker-php-ext-install pgsql pdo pdo_pgsql

COPY . /var/www/html/

COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]
