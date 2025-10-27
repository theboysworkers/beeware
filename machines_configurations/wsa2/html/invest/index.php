<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Consulenza Investimenti - Home</title>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="css/style.css" />
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
</head>
<body>
  <header>
    <nav class="navbar">
      <div class="logo">Invest</div>
      <ul class="nav-links">
        <li><a href="index.php" class="active">Home</a></li>
        <li><a href="prezzi.html">Prezzi in tempo reale</a></li>
        <li><a href="#servizi">Servizi</a></li>
        <li><a href="#contatti">Contatti</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <section class="hero">
      <h1>Consulenza di Investimento su misura</h1>
      <p>Massimizza i tuoi profitti con strategie personalizzate e dati in tempo reale.</p>
      <a href="prezzi.php" class="btn-primary">Scopri i Prezzi in Tempo Reale</a>
    </section>

    <section id="servizi" class="servizi">
      <h2>I nostri servizi</h2>
      <div class="cards-container">
        <div class="card">
          <h3>Consulenza Personalizzata</h3>
          <p>Strategie di investimento create su misura per i tuoi obiettivi finanziari.</p>
        </div>
        <div class="card">
          <h3>Analisi di Mercato</h3>
          <p>Dati aggiornati e approfondimenti per prendere decisioni informate.</p>
        </div>
        <div class="card">
          <h3>Gestione Portafoglio</h3>
          <p>Monitoraggio continuo e ottimizzazione del tuo portafoglio investimenti.</p>
        </div>
      </div>
    </section>

    <section id="contatti" class="contatti">
      <h2>Contattaci</h2>
      <p>Per una consulenza gratuita o maggiori informazioni, scrivici!</p>
      <form class="contact-form" method="get" action="">
        <input type="text" name="nome" placeholder="Nome" required />
        <input type="email" name="email" placeholder="Email" required />
        <textarea name="messaggio" placeholder="Messaggio" rows="4" required></textarea>
        <button type="submit" class="btn-primary">Invia</button>
      </form>

      <?php
      if (isset($_GET['nome']) && isset($_GET['email']) && isset($_GET['messaggio'])) {
          $nome = $_GET['nome'];
          $email = $_GET['email'];
          $messaggio = $_GET['messaggio'];
          echo '<div style="margin-top:20px; border:1px solid #ccc; padding:10px; border-radius:5px; background:#f9f9f9;">';
          echo '<h3>Riepilogo del messaggio inviato:</h3>';
          echo '<p><strong>Nome:</strong> '.$nome.'</p>';
          echo '<p><strong>Email:</strong> '.$email.'</p>';
          echo '<p><strong>Messaggio:</strong> '.$messaggio.'</p>';
          echo '</div>';
      }
      ?>
    </section>
  </main>

  <footer>
<p>© <span id="current-year"></span> Invest - Consulenza Investimenti</p>  </footer>
</body>
</html>