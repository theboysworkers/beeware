<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();

// 🔹 Se è già loggato → rimanda alla home
if (isset($_SESSION['user_id'])) {
  header("Location: index.php");
  exit;
}

$errore = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  // Connessione DB
  $conn = new mysqli('localhost', 'zen', 'zen', 'zendb');
  if ($conn->connect_error) {
    die('Errore di connessione al database');
  }

  $username = trim($_POST['username']);
  $password = trim($_POST['password']);

  // Prepara query sicura
  $stmt = $conn->prepare("SELECT id, password FROM utente WHERE username = ?");
  $stmt->bind_param("s", $username);
  $stmt->execute();
  $result = $stmt->get_result();

  // // Query vulnerabile - NON USARE IN PRODUZIONE
  // $query = "SELECT id, password FROM utente WHERE username = '$username'";
  // $result = $conn->query($query);
  // echo $result;


  if ($result && $result->num_rows > 0) {
    $user = $result->fetch_assoc();

    if (password_verify($password, $user['password'])) {
      $_SESSION['user_id'] = $user['id'];
      $_SESSION['username'] = $username;

      // Redirect a index.php
      header("Location: index.php");
      exit;
    } else {
      $errore = "❌ Password errata.";
    }
  } else {
    $errore = "⚠️ Utente non trovato.";
  }

  $stmt->close();
}
?>
<!doctype html>
<html lang="it">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Zenglish - Login</title>
  <link rel="stylesheet" href="assets/css/style.css">
  <link rel="shortcut icon" href="assets/favicon.ico" type="image/x-icon">
</head>
<body>
  <form class="login-box" method="POST">
    <h2>🔐 Zenglish - Login</h2>

    <?php if ($errore): ?>
      <div class="error"><?= htmlspecialchars($errore) ?></div>
    <?php endif; ?>

    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <button type="submit">Accedi</button>

    <div class="link">
      Non hai un account?
      <a href="register.php">Registrati</a>
    </div>
  </form>
</body>
</html>
