<?php
require_once __DIR__.'/lib/auth.php';
require_login();

header('Content-Type: application/json; charset=utf-8');

$stats = [];
$stats['uptime'] = trim(shell_exec('uptime -p 2>/dev/null || uptime 2>/dev/null'));
$stats['load'] = trim(shell_exec('cat /proc/loadavg 2>/dev/null || echo "n/a"'));
$stats['memory'] = trim(shell_exec('free -m 2>/dev/null || echo "n/a"'));
$stats['disk'] = trim(shell_exec('df -h --total 2>/dev/null || df -h 2>/dev/null'));
$stats['top_cpu'] = trim(shell_exec("ps aux --sort=-%cpu | head -n 6 2>/dev/null"));
$stats['top_mem'] = trim(shell_exec("ps aux --sort=-%mem | head -n 6 2>/dev/null"));
$stats['net'] = trim(shell_exec('ip -br addr 2>/dev/null || ifconfig 2>/dev/null'));

echo json_encode(['ok'=>true,'stats'=>$stats]);
