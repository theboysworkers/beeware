<?php
require_once __DIR__.'/lib/auth.php';
require_login();

header('Content-Type: application/json; charset=utf-8');

$action = $_POST['action'] ?? '';
$path = $_POST['path'] ?? '';
$lines = intval($_POST['lines'] ?? 100);
if($lines<1) $lines=1;
if($lines>MAX_TAIL) $lines=MAX_TAIL;

$real = realpath($path);
$root = realpath(BASE_FILE_ROOT);
if(!$real || !$root || strpos($real,$root)!==0 || !is_file($real) || !is_readable($real)){
    echo json_encode(['ok'=>false,'error'=>'path_not_allowed']);
    exit;
}

if($action==='tail'){
    $out = shell_exec("tail -n ".escapeshellarg($lines)." ".escapeshellarg($real)." 2>&1");
    echo json_encode(['ok'=>true,'output'=>$out]);
    exit;
}

if($action==='download'){
    $url = $_SERVER['REQUEST_SCHEME'].'://'.$_SERVER['HTTP_HOST']
         .dirname($_SERVER['REQUEST_URI']).'/'.basename($real);
    echo json_encode(['ok'=>true,'url'=>$url]);
    exit;
}

echo json_encode(['ok'=>false,'error'=>'unknown_action']);
