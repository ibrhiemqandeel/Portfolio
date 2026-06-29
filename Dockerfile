FROM php:8.2-cli

# تثبيت الإضافات والمكتبات اللازمة لـ Laravel و SQLite
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libsqlite3-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_sqlite

# نسخ الـ Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# نسخ ملفات المشروع
COPY . .

# تثبيت مكتبات Composer للـ Production
RUN composer install --no-dev --optimize-autoloader

# إعطاء الصلاحيات للمجلدات (يجب أن تكون قبل الـ CMD)
RUN chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

EXPOSE 10000

# أمر التشغيل (تم حذف سطور الـ env والـ key:generate لكي يقرأ من الـ Secret Files في Render)
CMD php artisan optimize && php artisan serve --host=0.0.0.0 --port=10000
