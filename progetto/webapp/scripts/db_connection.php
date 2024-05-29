<?php
// db_connection.php

$conn = pg_connect("host=127.0.0.1 port=5432 dbname=universal user=giacomo password=giacomo");

if (!$conn) {
    die("Connessione al database fallita");
}

?>