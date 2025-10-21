<?php
session_start();

define('APP_USER', 'admin');
// Cambia la password qui con password sicura
define('APP_PASS', 'admin');
define('BASE_FILE_ROOT', '/var/log');
define('MAX_TAIL', 1000);

function logged_in() {
    return !empty($_SESSION['logged_in']) && $_SESSION['logged_in'] === true;
}

function require_login() {
    if (!logged_in()) {
        http_response_code(401);
        echo json_encode(['ok'=>false,'error'=>'unauthenticated']);
        exit;
    }
}
