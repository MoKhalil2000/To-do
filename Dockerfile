FROM php:8.2-apache

# Installeer vereiste packages en PHP-extensies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    zip \
    curl \
    git \
    ca-certificates \
    && docker-php-ext-install

# Installeer Node.js (LTS) en npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Installeer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Zet werkmap
WORKDIR /var/www/html

# Kopieer Laravel-projectbestanden
COPY . .

# Zet bestandsrechten
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Installeer PHP/Laravel-afhankelijkheden
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Installeer JS-afhankelijkheden
RUN npm install && npm run build



