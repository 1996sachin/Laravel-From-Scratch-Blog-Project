# Use PHP image
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip default-mysql-client \
    && docker-php-ext-install pdo_mysql

# Install Composer globally for runtime
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

WORKDIR /var/www/html

# Copy application code
COPY . .

# Fix permissions
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Install PHP dependencies during build (optional)
RUN composer install --no-dev --optimize-autoloader

# Generate app key (ignore if already exists)
RUN php artisan key:generate || true

CMD ["php-fpm"]
