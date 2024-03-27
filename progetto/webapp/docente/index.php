<?php

include '../scripts/db_connection.php';

session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

// Ottieni le informazioni del docente utilizzando la funzione SQL universal.get_teacher
$query_get_teacher = "SELECT * FROM universal.get_teacher($1)";
$result_get_teacher = pg_query_params($conn, $query_get_teacher, array($_SESSION['id']));
$row_get_teacher = pg_fetch_assoc($result_get_teacher);

// Assegna le informazioni del docente alle variabili
$nome = $row_get_teacher['nome'];
$cognome = $row_get_teacher['cognome'];
$ufficio = $row_get_teacher['ufficio'];

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
            <h2>Docenti Universal</h2>
        </div>
        <div class="spiegazione">
            <p>Qui puoi creare e gestire il calendario degli esami dei tuoi insegnamenti e registrare gli esiti degli esami degli studenti.</p>
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
                <label for="ufficio">Ufficio:</label>
                <span id="ufficio"><?php echo $ufficio; ?></span>
            </div>
        </div>
        <div class="funzioni">
            <button onclick="window.location.href='./modificaPassword.php'">Modifica Password</button>
            <button onclick="window.location.href='./visualizzaInsegnamenti.php'">Visualizza i tuoi insegnamenti</button>
            <button onclick="window.location.href='./visualizzaValutazioniAssegnate.php'">Visualizza le valutazioni assegnate</button>
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
