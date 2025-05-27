FROM php:8.2-apache

# Installeer zip en andere tools
RUN apt-get update && apt-get install -y \
    libzip-dev unzip zip curl git ca-certificates \
    && docker-php-ext-install zip

# Installeer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installeer Node.js (optioneel)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# Werkdirectory
WORKDIR /var/www/html

# Kopieer Laravel-project
COPY . .

# Zorg dat Laravel directories correct zijn
RUN mkdir -p storage/framework/{sessions,views,cache} bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data storage bootstrap/cache

# Installeer PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Optioneel: JS build
RUN npm install && npm run build || true

# Apache configuratie
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

CMD ["apache2-foreground"]
