FROM php:8.2-apache

RUN apt-get update && apt-get install -y libzip-dev unzip zip curl git ca-certificates \
    && docker-php-ext-install zip pdo_mysql

# Node.js & npm (indien nodig)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html
COPY . .

RUN composer install --no-interaction --prefer-dist --optimize-autoloader
RUN npm install && npm run build

COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

COPY .env.example .env
RUN php artisan key:generate

RUN touch database/database.sqlite
RUN php artisan migrate:fresh --seed

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

CMD ["apache2-foreground"]
