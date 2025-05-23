FROM php:8.2-apache

# Installeer vereiste OS packages en PHP-extensies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    zip \
    curl \
    git \
    ca-certificates \
    && docker-php-ext-install zip

# Installeer Node.js (LTS v18) en npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Installeer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Zet Apache werkmap
WORKDIR /var/www/html

# Kopieer Laravel-projectbestanden naar container
COPY . .

# Zorg dat de juiste permissies ingesteld zijn
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Installeer Composer-afhankelijkheden (ook van GitHub of andere repos)
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Installeer NPM-afhankelijkheden en build assets
RUN npm install && npm run build


