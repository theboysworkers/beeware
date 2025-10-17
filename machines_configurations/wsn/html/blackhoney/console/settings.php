<?php
require_once __DIR__.'/lib/auth.php';
require_login();
header('Content-Type: application/json; charset=utf-8');

echo json_encode([
    'ok'=>true,
    'base_root'=>BASE_FILE_ROOT,
    'max_tail'=>MAX_TAIL,
    'user'=>$_SESSION['user'] ?? 'admin'
]);
