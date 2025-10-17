<?php
require_once __DIR__.'/lib/auth.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['user'] ?? '';
    $pass = $_POST['pass'] ?? '';
    header('Content-Type: application/json; charset=utf-8');
    if ($user === APP_USER && $pass === APP_PASS) {
        session_regenerate_id(true);
        $_SESSION['logged_in'] = true;
        $_SESSION['user'] = $user;
        echo json_encode(['ok'=>true]);
    } else {
        echo json_encode(['ok'=>false,'error'=>'Credenziali errate']);
    }
    exit;
}
?>
<!doctype html>
<html lang="it">
<head>
<meta charset="utf-8">
<title>Login Admin</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="wrap">
<h1>Admin Shell</h1>
<p class="note">Accedi con le credenziali.</p>
<form id="loginForm">
  <input name="user" placeholder="Username" value="<?=htmlspecialchars(APP_USER)?>">
  <input name="pass" type="password" placeholder="Password">
  <button type="submit">Accedi</button>
</form>
<p class="note" style="margin-top:12px">Questo pannello permette di eseguire comandi shell.</p>
</div>
<script>
document.getElementById('loginForm').addEventListener('submit', async e=>{
    e.preventDefault();
    const fd = new FormData(e.target);
    const res = await fetch('login.php',{method:'POST',body:fd});
    const json = await res.json();
    if(json.ok){ location.href='index.php'; }
    else alert('Login fallito: '+(json.error||''));
});
</script>
</body>
</html>
