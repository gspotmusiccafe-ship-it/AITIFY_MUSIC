FROM php:8.2-apache

# Install system dependencies for PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libgd-dev \
    libzip-dev \
    && docker-php-ext-install curl gd zip pcntl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install dependencies (ignoring platform requirements to ensure build success)
# Replace line 24 (the RUN composer install... line) with this:
RUN composer install --no-dev --no-autoloader --no-scripts --ignore-platform-reqs && \
    composer dump-autoload --optimize

# Permissions for Apache
RUN chown -R www-data:www-data /var/www/html

# Enable rewrite module
RUN a2enmod rewrite
