<?php


namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);


class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */



public function boot(): void
{
    // إجبار تشغيل الـ HTTPS لو كان الموقع مرفوعاً على سيرفر حقيقي
    if (config('app.env') === 'production' || env('APP_ENV') === 'production' || env('APP_URL') !== 'http://localhost') {
        URL::forceScheme('https');
    }
}
}
