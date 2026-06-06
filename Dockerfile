FROM php:8.2-apache
RUN apt-get update && apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev
RUN docker-php-ext-install curl
COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html
