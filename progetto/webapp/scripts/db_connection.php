<?php
// db_connection.php

$conn = pg_connect("host=localhost port=5432 dbname=universal user=giacomo password=giacomo");

if (!$conn) {
    die("Connessione al database fallita");
}

?>