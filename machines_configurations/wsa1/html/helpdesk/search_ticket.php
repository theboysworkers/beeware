<?php
include 'db.php';

$search = $_GET['q'] ?? '';
$status = $_GET['status'] ?? '';

$sql = "SELECT * FROM ticket WHERE 1=1";
$params = [];

if($search) {
    $sql .= " AND (nome LIKE ? OR email LIKE ? OR messaggio LIKE ?)";
    $params = ["%$search%", "%$search%", "%$search%"];
}
if($status) {
    $sql .= " AND stato = ?";
    $params[] = $status;
}

$sql .= " ORDER BY data_apertura DESC";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$tickets = $stmt->fetchAll();

foreach($tickets as $ticket) {
    echo "<tr>
        <td>{$ticket['id']}</td>
        <td>".htmlspecialchars($ticket['nome'])."</td>
        <td>".htmlspecialchars($ticket['email'])."</td>
        <td>".htmlspecialchars($ticket['messaggio'])."</td>
        <td data-stato='{$ticket['stato']}'>{$ticket['stato']}</td>
        <td>{$ticket['data_apertura']}</td>
        <td>".($ticket['data_chiusura'] ?? '-')."</td>
        <td>";
    if($ticket['stato'] === 'Aperto') {
        echo "<button class='btn closeBtn' data-id='{$ticket['id']}'>Chiudi</button>";
    } else {
        echo "<span style='color:#dc3545;font-weight:500;'>Chiuso</span>";
    }
    echo "</td></tr>";
}
?>
