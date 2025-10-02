<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}
?>


<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome = $_POST['nome'];
    $email = $_POST['email'];
    $messaggio = $_POST['messaggio'];

    $stmt = $pdo->prepare("INSERT INTO ticket (nome, email, messaggio) VALUES (?, ?, ?)");
    $stmt->execute([$nome, $email, $messaggio]);
    header("Location: index.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Nuovo Ticket</title>
    <link rel="stylesheet" href="style.css">
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
</head>
<body>
    <form method="POST">
        <h2 style="text-align:center;color:#1a73e8;">Crea Nuovo Ticket</h2>
        <input type="text" name="nome" placeholder="Nome" required>
        <input type="email" name="email" placeholder="Email" required>
        <textarea name="messaggio" placeholder="Messaggio" required></textarea>
        <button type="submit">Invia Ticket</button>
    </form>
    <a href="index.php" class="btn" style="display:block;text-align:center;margin:10px auto;width:200px;">Torna alla lista</a>
</body>
</html>
