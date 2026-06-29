FROM php:8.2-cli

RUN apt-get update && apt-get install -y git curl zip unzip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

RUN composer install --no-dev --optimize-autoloader

RUN cp .env.example .env || true
RUN php artisan key:generate || true

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000

RUN chmod -R 777 storage bootstrap/cache
