<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('index');
});

Route::get('/debug-log', function () {
    $logPath = storage_path('logs/laravel.log');
    if (file_exists($logPath)) {
        return response(file_get_contents($logPath), 200)
            ->header('Content-Type', 'text/plain');
    }
    return 'Log file does not exist yet.';
});
