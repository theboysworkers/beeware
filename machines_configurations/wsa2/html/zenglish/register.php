<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Se già loggato, reindirizza a index.php
if (isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit;
}

$msg = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $conn = new mysqli('localhost', 'zen', 'zen', 'zendb');
    if ($conn->connect_error) die('DB error: '.$conn->connect_error);

    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    // Controlla se l'utente esiste già
    $stmt = $conn->prepare("SELECT id FROM utente WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $res = $stmt->get_result();

    if ($res->num_rows > 0) {
        $msg = "Errore: nome utente già in uso.";
    } else {
        $passwordHashed = password_hash($password, PASSWORD_BCRYPT);
        $stmt = $conn->prepare("INSERT INTO utente (username, password) VALUES (?, ?)");
        $stmt->bind_param("ss", $username, $passwordHashed);
        if ($stmt->execute()) {
            $msg = "Registrazione completata! Ora puoi <a href='login.php'>accedere</a>.";
        } else {
            $msg = "Errore durante la registrazione.";
        }
    }
}
?>
<!doctype html>
<html lang="it">
<head>
  <meta charset="utf-8" />
  <link rel="stylesheet" href="assets/css/style.css">
  <link rel="shortcut icon" href="assets/favicon.ico" type="image/x-icon">
  <title>Zenglish - Registrazione</title>
</head>
<body>
  <form class="register-box" method="POST">
    <h2>📝 Registrazione</h2>
    <?php if($msg): ?><div class="error"><?= $msg ?></div><?php endif; ?>
    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <button type="submit">Crea account</button>
    <div class="link">Hai già un account? <a href="login.php">Accedi</a></div>
  </form>
</body>
</html>
