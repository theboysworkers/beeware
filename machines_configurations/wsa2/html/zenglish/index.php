<?php
session_start();

// se non loggato, reindirizza
if (!isset($_SESSION['user_id'])) {
  header("Location: login.php");
  exit;
}
?>
<!doctype html>
<html lang="it">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Zenglish • Flashcards Italiano → Inglese</title>
  <link rel="stylesheet" href="assets/css/style.css" />
  <link rel="shortcut icon" href="assets/favicon.ico" type="image/x-icon">
</head>
<body>
  <div class="app">
    <header class="topbar">
      <h1>Zenglish</h1>
      <div class="toolbar">
        <select id="category"></select>
        <button id="reset-btn" class="secondary">↻ Reset</button>
        <form action="logout.php" method="post" style="display:inline;">
          <button type="submit" class="secondary">🚪 Logout</button>
        </form>
      </div>
    </header>

    <main class="card-area">
      <div class="flashcard">
        <div id="italian-word" class="word">—</div>
        <div id="word-type" class="word-type">Tipo: —</div>

        <input type="text" id="answer" placeholder="Traduzione in inglese..." />

        <div class="actions">
          <button id="check-btn">Controlla</button>
          <button id="show-btn" class="secondary">Mostra</button>
          <button id="new-btn" class="secondary">Salta</button>
        </div>
      </div>

      <div class="stats">
        <div class="stat">🏆 <span id="score">0</span> punti</div>
        <div class="stat">📚 Rimaste: <span id="remaining">0</span></div>
        <div class="stat" id="accuracy">🎯 0%</div>
      </div>

      <div id="previous" class="previous"></div>
    </main>
  </div>

  <script src="assets/js/script.js"></script>
</body>
</html>
