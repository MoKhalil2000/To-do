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

# Laravel directory rechten
RUN chown -R www-data:www-data /var/www && a2enmod rewrite

# Zet werkmap
WORKDIR /var/www/html

# Kopieer Laravel-project
COPY . .

# Laravel rechten fix
RUN chmod -R 755 /var/www/html && chown -R www-data:www-data /var/www/html
