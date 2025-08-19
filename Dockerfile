# Use PHP image
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip default-mysql-client \
    && docker-php-ext-install pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . .

# Fix permissions
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Optional: install PHP dependencies at build time (can be skipped if handled via Jenkins)
#RUN composer install --no-dev --optimize-autoloader

# Generate app key (ignore if already exists)
RUN php artisan key:generate || true

# Expose port 9000 (default for php-fpm)
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
