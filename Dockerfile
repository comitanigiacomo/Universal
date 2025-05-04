FROM php:8.4-apache

RUN docker-php-ext-install pgsql pdo pdo_pgsql

COPY . /var/www/html/

RUN a2enmod rewrite

EXPOSE 80

CMD ["apache2-foreground"]