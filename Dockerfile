FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev

RUN docker-php-ext-install \
    zip \
    pdo \
    pdo_mysql \
    bcmath \
    gd \
    mbstring \
    xml

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-dev --optimize-autoloader

EXPOSE 10000

CMD touch database/database.sqlite && php artisan config:clear && php artisan cache:clear && php artisan view:clear && php artisan route:clear && php artisan migrate --force && php artisan storage:link && php artisan serve --host=0.0.0.0 --port=10000
