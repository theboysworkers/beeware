<?php
header('Content-Type: application/json; charset=utf-8');
error_reporting(0);

// --- CONNESSIONE AL DATABASE ---
$host = "localhost";
$user = "zen";
$pass = "zen";
$dbname = "zendb";

$conn = new mysqli($host, $user, $pass, $dbname);

if ($conn->connect_error) {
    echo json_encode(["error" => "Connessione al DB fallita"]);
    exit;
}

// --- FUNZIONE DI PULIZIA OUTPUT ---
function clean($s) {
    return htmlspecialchars(trim($s), ENT_QUOTES, 'UTF-8');
}

// --- RICHIESTA CATEGORIE ---
if (isset($_GET['action']) && $_GET['action'] === 'categories') {
    $result = $conn->query("SELECT nome FROM categorie ORDER BY nome ASC");
    $categories = [];
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row['nome'];
    }
    echo json_encode($categories);
    $conn->close();
    exit;
}

// --- RICHIESTA PAROLE PER CATEGORIA ---
if (isset($_GET['categoria'])) {
    $categoria = clean($_GET['categoria']);

    $sql = "SELECT p.id, p.italiano, p.inglese, p.esempi, 
                   c.id AS categoria_id, c.nome AS categoria_nome,
                   t.nome AS tipo
            FROM parole p
            INNER JOIN categorie c ON p.categoria_id = c.id
            INNER JOIN tipi t ON p.tipo_id = t.id
            WHERE c.nome = ?
            ORDER BY RAND()";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $categoria);
    $stmt->execute();
    $res = $stmt->get_result();

    $words = [];
    while ($row = $res->fetch_assoc()) {
        // esempi separati da ';'
        $esempi = [];
        if (!empty($row['esempi'])) {
            if ($row['esempi'][0] === '[') {
                // formato JSON
                $esempi = json_decode($row['esempi'], true);
            } else {
                $esempi = array_map('trim', explode(';', $row['esempi']));
            }
        }

        $words[] = [
            "id" => (int)$row['id'],
            "italiano" => $row['italiano'],
            "inglese" => $row['inglese'],
            "tipo" => $row['tipo'],
            "categoria_id" => (int)$row['categoria_id'],
            "categoria_nome" => $row['categoria_nome'],
            "esempi" => $esempi,
            "sinonimi" => [] // opzionale, puoi aggiungere colonna in futuro
        ];
    }

    echo json_encode($words);
    $stmt->close();
    $conn->close();
    exit;
}

// --- NESSUNA AZIONE RICONOSCIUTA ---
echo json_encode(["error" => "Richiesta non valida"]);
$conn->close();
exit;
