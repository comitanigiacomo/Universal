<?php

include '../scripts/db_connection.php';

session_start();


// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

// Ottieni le informazioni dello studente utilizzando la funzione SQL universal.get_student
$query_get_student = "SELECT * FROM universal.get_student($1)";
$result_get_student = pg_query_params($conn, $query_get_student, array($_SESSION['id']));
$row_get_student = pg_fetch_assoc($result_get_student);

// Ottieni la media dello studente
$query_get_average = "SELECT * FROM universal.get_student_average($1)";
$result_get_average = pg_query_params($conn, $query_get_average, array($_SESSION['id']));
$row_get_average = pg_fetch_assoc($result_get_average);


// Assegna le informazioni dello studente alle variabili
$nome = $row_get_student['nome'];
$cognome = $row_get_student['cognome'];
$matricola = $row_get_student['matricola'];
$corso_di_laurea = $row_get_student['corso_di_laurea'];
$media = $row_get_average['media'];

// Esegui la query per ottenere gli appelli degli esami a cui lo studente è attualmente iscritto
$query_get_appointments = "SELECT * FROM universal.get_all_teaching_appointments_for_student_degree($1)";
$result_get_appointments = pg_query_params($conn, $query_get_appointments, array($_SESSION['id']));
?>