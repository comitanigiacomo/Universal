FROM php:8.4-apache

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pgsql pdo pdo_pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copia tutto il progetto (incluso webapp/, database/, ecc.)
COPY . /var/www/html/progetto/webapp

# Abilita mod_rewrite
RUN a2enmod rewrite

# Imposta la directory di lavoro
WORKDIR /var/www/html/webapp

# Espone la porta 80
EXPOSE 80

# Avvia Apache
CMD ["apache2-foreground"]