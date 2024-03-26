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

<!DOCTYPE html>
<html>
<head>
    <title>Area Personale</title>
    <link rel="stylesheet" type="text/css" href="/progetto/webapp/studente/studente.css">
    <meta charset="utf-8">
</head>
<body>
    <div class='sfondo'>
        <div class="contenitore">
        <div class="benvenuto">
            <h2>Studenti Universal</h2>
        </div>
        <div class="spiegazione">
            <p>Qui puoi visualizzare il tuo programma di studi, iscriverti agli esami e consultare i risultati.</p>
        </div>
        <div class="informazioni">
          
            <div>
                <label for="nome">Nome:</label>
                <span id="nome"><?php echo $nome; ?></span>
            </div>
            <div>
                <label for="cognome">Cognome:</label>
                <span id="cognome"><?php echo $cognome; ?></span>
            </div>
            <div>
                <label for="matricola">Matricola:</label>
                <span id="matricola"><?php echo $matricola; ?></span>
            </div>
            <div>
                <label for="corso_di_laurea">Corso di Laurea:</label>
                <span id="corso_di_laurea"><?php echo $corso_di_laurea; ?></span>
            </div>
            <div>
                <label for="media">Media:</label>
                <span id="media"><?php echo $media; ?></span>
            </div>
        </div>
        <div class="funzioni">

            <button onclick="window.location.href='./modificaPassword.php'">Modifica Password</button>
            <button onclick="window.location.href='./visualizzaAppelliCorso.php'">Visualizza Tutti Gli Appelli Del Tuo Corso</button>
            <button onclick="window.location.href='./visualizzaAppelli.php'">Visualizza Tutti Gli Appelli</button>
            <button onclick="window.location.href='./visualizzaCorsiDiLaurea.php'">Visualizza Tutti I Corsi Di Laurea</button>
            <button onclick="window.location.href='./visualizzaEsamiMancanti.php'">Visualizza Gli Esami Mancanti Alla Laurea</button>
            <button onclick="window.location.href='./iscrizioni.php'">Visualizza Iscrizioni</button>
            <button onclick="window.location.href='./visualizzaCarriera.php'">Visualizza Carriera</button>
            <button onclick="window.location.href='./visualizzaCarrieraCompleta.php'">Visualizza Carriera Completa</button>

        </div>
    </div>
    </div>
    

    <footer>
        <div>
            Università degli studi di Universal
        </div>
        <div>
            Made by Jack during the small hours
        </div>
        <div>
            <a href="https://letmegooglethat.com/?q=cerca+qui+i+tuoi+problemi%2C+grazie">Assistenza Universal</a>
            <br>
        </div>
    </footer>

</body>

</html>
