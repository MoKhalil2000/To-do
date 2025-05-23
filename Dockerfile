FROM php:8.2-apache

# Installeer vereiste packages en PHP-extensies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    zip \
    curl \
    git \
    && docker-php-ext-install zip

# Installeer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Kopieer Apache config naar juiste locatie
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Zet werkmap
WORKDIR /var/www/html

# Kopieer Laravel-project
COPY . .

# Laravel directory rechten
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html



