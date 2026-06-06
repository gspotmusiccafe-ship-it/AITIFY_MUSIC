FROM php:8.2-apache

# Install dependencies for Composer and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    && docker-php-ext-install curl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy your project files
COPY . .

# THIS IS THE CRITICAL STEP: Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Permissions for Apache
RUN chown -R www-data:www-data /var/www/html

# Enable rewrite module
RUN a2enmod rewrite
