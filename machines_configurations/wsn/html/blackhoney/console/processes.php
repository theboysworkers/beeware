<?php
require_once __DIR__.'/lib/auth.php';
require_login();

header('Content-Type: application/json; charset=utf-8');

$n = intval($_POST['n'] ?? 15);
if ($n<1) $n=15;
if ($n>200) $n=200;

$sort = $_POST['sort'] ?? 'cpu';
$cmd = ($sort==='mem') ? "ps aux --sort=-%mem" : "ps aux --sort=-%cpu";

$out = shell_exec($cmd . " | head -n ".($n+1)." 2>/dev/null");

echo json_encode(['ok'=>true,'output'=>$out]);
