<?php

include '../scripts/db_connection.php';

session_start();


// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}

// Ottieni le informazioni dello studente utilizzando la funzione SQL universal.get_student
$query_get_ex_student = "SELECT * FROM universal.get_ex_student($1)";
$result_get_ex_student = pg_query_params($conn, $query_get_ex_student, array($_SESSION['id']));
$row_get_ex_student = pg_fetch_assoc($result_get_ex_student);

// Ottieni la media dello studente
$query_get_average = "SELECT * FROM universal.get_student_average($1)";
$result_get_average = pg_query_params($conn, $query_get_average, array($_SESSION['id']));
$row_get_average = pg_fetch_assoc($result_get_average);


// Assegna le informazioni dello studente alle variabili
$nome = $row_get_ex_student['nome'];
$cognome = $row_get_ex_student['cognome'];
$matricola = $row_get_ex_student['matricola'];

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
        <div class="logo">
                <a class="nav-link" id="uni" aria-current="page" href="../login.php">Universal</a>
                <br><br>
            </div>
        <div class="benvenuto">
            <h2>Ex Studenti Universal</h2>
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
        </div>
        <div class="funzioni">

            <button onclick="window.location.href='./modificaPassword.php'">Modifica Password</button>
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
