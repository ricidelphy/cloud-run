FROM composer:1.9.0 as build
WORKDIR /app
COPY . /app
RUN composer global require hirak/prestissimo && composer install

FROM php:7.4.1-fpm-alpine
RUN apk --no-cache add nginx supervisor && docker-php-ext-install pdo pdo_mysql

# Configure nginx
RUN mkdir -p /run/nginx
COPY docker/laravel.conf /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY docker/custom-php-fpm.conf /etc/php7/php-fpm.d/custom-php-fpm.conf
COPY docker/php.ini /etc/php7/conf.d/php.ini

# Configure supervisord
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set up project
WORKDIR /var/www/app/
COPY --from=build /app .
COPY .env.example .env
COPY docker/entrypoint.sh entrypoint.sh
RUN chmod 777 -R storage && php artisan key:generate

EXPOSE 8080
ENTRYPOINT ["sh", "entrypoint.sh"]
