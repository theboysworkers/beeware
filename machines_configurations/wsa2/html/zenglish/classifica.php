<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();

// Connessione DB
$conn = new mysqli('localhost', 'zen', 'zen', 'zendb');
if ($conn->connect_error) {
    die('Errore di connessione al database');
}

// Inizializza variabili
$utenti = [];
$top = '';
// 🔹 Se è presente il parametro search, cerca un utente specifico per username
if (isset($_GET['search']) && $_GET['search'] !== '') {
    $username = $_GET['search']; // nessuna sanitizzazione (vulnerabile, voluto)
    $query = "SELECT id, username, livello, punteggio FROM utente WHERE username = '$username';";
}
// 🔹 Altrimenti mostra la classifica standard con parametro 'top'
else {
    $top = isset($_GET['top']) ? intval($_GET['top']) : 20;
    $query = "SELECT username, livello, punteggio FROM utente ORDER BY punteggio DESC LIMIT $top;";
}

// Esegui la query
if ($conn->multi_query($query)) {
    do {
        if ($result = $conn->store_result()) {
            while ($row = $result->fetch_assoc()) {
                $utenti[] = $row;
            }
            $result->free();
        }
    } while ($conn->more_results() && $conn->next_result());
} else {
    die("Errore nella query: " . $conn->error);
}




$conn->close();

// Gestione colonne
if (!empty($utenti)) {
    $columns = array_keys($utenti[0]);
} else {
    $columns = ['username', 'livello', 'punteggio'];
}
?>


<!doctype html>
<html lang="it">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Zenglish - Classifica</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
  <div class="app">
    <div class="leaderboard-box">
      <h2>Classifica Utenti</h2>

      <!-- 🔍 Campo di ricerca -->
      <form method="GET" action="">
        <label for="search">Cerca utente per username:</label>
        <input class="search-input" type="text" name="search" id="search" placeholder="username" />
        <button type="submit">Cerca</button>
      </form>

      <!-- 🔸 Selezione TOP -->
      <form method="GET" action="">
        <label for="top">Mostra Top:</label>
        <select name="top" id="top" onchange="this.form.submit()">
          <?php 
            $options = [5, 10, 15, 20, 30, 50, 100];
            foreach ($options as $value): 
          ?>
            <option value="<?= $value ?>" <?= ($value == $top) ? 'selected' : '' ?>>
              <?= $value ?>
            </option>
          <?php endforeach; ?>
        </select>
      </form>

      <table>
        <thead>
          <tr>
            <th>#</th>
            <?php foreach ($columns as $colname): ?>
              <th><?= htmlspecialchars($colname) ?></th>
            <?php endforeach; ?>
          </tr>
        </thead>
        <tbody>
          <?php if ($utenti): ?>
            <?php $rank = 1; ?>
            <?php foreach ($utenti as $utente): ?>
              <tr>
                <td class="rank"><?= $rank ?></td>
                <?php foreach ($columns as $colname): ?>
                  <td><?= htmlspecialchars($utente[$colname] ?? '') ?></td>
                <?php endforeach; ?>
              </tr>
              <?php $rank++; ?>
            <?php endforeach; ?>
          <?php else: ?>
            <tr><td colspan="<?= count($columns)+1 ?>">Nessun utente trovato.</td></tr>
          <?php endif; ?>
        </tbody>
      </table>
    </div>
  </div>
</body>
</html>
