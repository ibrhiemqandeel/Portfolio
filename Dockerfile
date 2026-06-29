FROM php:8.2-cli

# 1. تثبيت الإضافات والمكتبات اللازمة لـ Laravel و SQLite
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libsqlite3-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_sqlite

# 2. نسخ الـ Composer من الحاوية الرسمية
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 3. تحديد مجلد العمل الرئيسي داخل الحاوية
WORKDIR /app

# 4. نسخ ملفات المشروع بالكامل
COPY . .

# 5. تثبيت مكتبات Composer للـ Production
RUN composer install --no-dev --optimize-autoloader

# 6. تهيئة مجلد قاعدة البيانات ومنح الصلاحيات أثناء البناء لضمان الاستقرار
RUN mkdir -p /app/database && \
    touch /app/database/database.sqlite && \
    chmod -R 777 /app/database storage bootstrap/cache

EXPOSE 10000

CMD mkdir -p /app/database && \
    touch /app/database/database.sqlite && \
    chmod -R 777 /app/database storage bootstrap/cache && \
    php artisan config:clear && \
    php artisan migrate --force && \
    php -S 0.0.0.0:10000 -t public
