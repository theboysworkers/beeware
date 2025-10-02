<?php
include 'db.php';

if(isset($_POST['id'])) {
    $id = $_POST['id'];
    $stato = 'Chiuso';
    $data_chiusura = date('Y-m-d H:i:s');

    $stmt = $pdo->prepare("UPDATE ticket SET stato = ?, data_chiusura = ? WHERE id = ?");
    $stmt->execute([$stato, $data_chiusura, $id]);

    echo "ok";
}
?>
