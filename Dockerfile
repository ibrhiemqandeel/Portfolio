FROM php:8.2-cli

# تثبيت الإضافات والمكتبات اللازمة لـ Laravel و SQLite
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libsqlite3-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_sqlite

# نسخ الـ Composer من الحاوية الرسمية
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# نسخ ملفات المشروع
COPY . .

# تثبيت مكتبات Composer للـ Production وتوليد الأوتولودر النظيف
RUN composer install --no-dev --optimize-autoloader

# تهيئة مجلد قاعدة البيانات ومنح الصلاحيات المطلقة أثناء البناء
RUN mkdir -p /app/database && \
    touch /app/database/database.sqlite && \
    chmod -R 777 /app/database storage bootstrap/cache

# إعداد متغيرات البيئة الأساسية إجبارياً داخل الحاوية لمنع الـ 500
ENV APP_ENV=production
ENV APP_DEBUG=true
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/app/database/database.sqlite

EXPOSE 10000

# أمر الإقلاع القياسي السريع والمستقر عبر سيرفر PHP المدمج الموجه للـ index مباشرة
CMD php artisan migrate --force && php -S 0.0.0.0:10000 public/index.php
