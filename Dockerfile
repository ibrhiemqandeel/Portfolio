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

# 4. نسخ ملفات المشروع بالكامل (مرة واحدة وبشكل صحيح)
COPY . .

# 5. تثبيت مكتبات Composer للـ Production
RUN composer install --no-dev --optimize-autoloader

# 6. إعطاء الصلاحيات الكاملة والمطلقة للمجلدات الحيوية لمنع الـ 500
RUN chmod -R 777 storage bootstrap/cache

EXPOSE 10000

# 7. أمر التشغيل المؤتمت: إنشاء المجلد وقاعدة البيانات، منحها صلاحيات 777، ثم تشغيل الميجريشن والإقلاع
CMD mkdir -p database && \
    touch database/database.sqlite && \
    chmod -R 777 database storage bootstrap/cache && \
    php artisan migrate --force && \
    php artisan optimize && \
    php artisan serve --host=0.0.0.0 --port=10000
