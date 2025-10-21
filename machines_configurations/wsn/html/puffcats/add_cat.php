<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Ottieni i dati dal modulo
    $name = $_POST['name'];
    $desc = $_POST['desc'];
    $tags = explode(',', $_POST['tags']); // Dividi i tag in un array

    // Gestisci il caricamento dell'immagine
    $imgTmpPath = $_FILES['img']['tmp_name'];
    $imgName = basename($_FILES['img']['name']);

    // Imposta il percorso di destinazione
    $uploadPath = 'assets/img/' . $imgName;

    // Sposta il file caricato nella cartella
    if (!move_uploaded_file($imgTmpPath, $uploadPath)) {
        die("Errore nel caricamento dell'immagine.");
    }

    // Carica il file esistente
    $dataFile = 'assets/data.json';
    $data = json_decode(file_get_contents($dataFile), true); // Decodifica JSON in array associativo

    // Crea un nuovo gatto
    $newCat = [
        'name' => $name,
        'desc' => $desc,
        'tags' => array_map('trim', $tags), // Rimuovi spazi vuoti dai tag
        'img' => $uploadPath // Salva il percorso dell'immagine
    ];

    // Aggiungi il nuovo gatto all'array esistente
    $data['kittens'][] = $newCat;

    // Salva di nuovo i dati nel file
    file_put_contents($dataFile, json_encode($data, JSON_PRETTY_PRINT));

    // Reindirizza indietro alla pagina principale (facoltativo)
    header('Location: index.html'); // Assicurati che il nome del file HTML sia corretto
    exit();
}
?>
