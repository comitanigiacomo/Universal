<?php
// db_connection.php

$db_url = getenv('DATABASE_URL'); 

if ($db_url) {
    $conn = pg_connect($db_url);

    if (!$conn) {
        die("Connessione al database fallita");
    }
} else {
    die("DATABASE_URL non definita come variabile d'ambiente.");
}
?>