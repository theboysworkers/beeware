<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit;
}

?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Helpdesk</title>
    <link rel="stylesheet" href="style.css">
    <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
</head>
<body>
    <header>
        <img src="favicon.ico" alt="Logo Helpdesk" id="logo">
        <h1>Helpdesk Tickets</h1>
    </header>
    <a href="logout.php" class="btn">Logout</a>
    <a href="add_ticket.php" class="btn">Nuovo Ticket</a>

    <div class="filters">
        <input type="text" id="search" placeholder="Cerca per nome, email o messaggio">
        <select id="filterStatus">
            <option value="">Tutti</option>
            <option value="Aperto">Aperto</option>
            <option value="Chiuso">Chiuso</option>
        </select>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Email</th>
                <th>Messaggio</th>
                <th>Stato</th>
                <th>Data Apertura</th>
                <th>Data Chiusura</th>
                <th>Azioni</th>
            </tr>
        </thead>
        <tbody id="ticketBody">
            <!-- Ticket caricati dinamicamente -->
        </tbody>
    </table>

    <script src="script.js"></script>
</body>
</html>
