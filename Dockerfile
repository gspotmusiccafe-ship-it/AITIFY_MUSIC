FROM php:8.2-apache

# Install system dependencies
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

# Create missing directories so Composer doesn't crash during scan
RUN mkdir -p common/foundation/database/seeders

# Install dependencies and generate the autoloader
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Permissions for Apache
RUN chown -R www-data:www-data /var/www/html

# Enable rewrite module
RUN a2enmod rewrite
