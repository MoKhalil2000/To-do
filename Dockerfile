FROM php:8.2-apache

# Installeer vereiste PHP-extensies
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    unzip \
    zip \
    curl \
    && docker-php-ext-install pdo pdo_mysql zip

# Installeer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Kopieer apache config naar juiste locatie
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Zet werkmap
WORKDIR /var/www/html

# Kopieer Laravel-project
COPY . .

# Laravel directory rechten
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Zet mod_rewrite aan en herstart Apache
RUN a2enmod rewrite \
    && service apache2 restart
