<?php
require_once __DIR__.'/lib/auth.php';
require_login();

header('Content-Type: application/json; charset=utf-8');

$path = $_POST['path'] ?? BASE_FILE_ROOT;
$real = realpath($path);
$root = realpath(BASE_FILE_ROOT);

if(!$real || !$root || strpos($real,$root)!==0){
    echo json_encode(['ok'=>false,'error'=>'path_not_allowed']);
    exit;
}

$items = array_values(array_diff(scandir($real),['.','..']));
echo json_encode(['ok'=>true,'items'=>$items]);
