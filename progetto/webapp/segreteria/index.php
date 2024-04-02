<?php

include '../scripts/db_connection.php';

session_start();


// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

$query_get_secretary = "SELECT * FROM universal.get_secretary($1)";
$result_get_secretary = pg_query_params($conn, $query_get_secretary, array($_SESSION['id']));
$row_get_secretary = pg_fetch_assoc($result_get_secretary);


$nome = $row_get_secretary['nome'];
$cognome = $row_get_secretary['cognome'];
$sede = $row_get_secretary['sede'];

?>

<!DOCTYPE html>
<html>
<head>
    <title>Area Personale</title>
    <link rel="stylesheet" type="text/css" href="./studente.css">
    <meta charset="utf-8">
</head>
<body>
    <div class='sfondo'>
        <div class="contenitore">
        <div class="benvenuto">
            <h2>Segretari Universal</h2>
        </div>
        <div class="spiegazione">
            <p>Qui puoi gestire gli utenti e i docenti.</p>
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
                <label for="sede">Sede:</label>
                <span id="sede"><?php echo $sede; ?></span>
            </div>

        </div>
        <div class="funzioni">

            <button onclick="window.location.href='./modificaPassword.php'">Modifica Password</button>
            <button onclick="window.location.href='./visualizzaCorsiDiLaurea.php'">Visualizza Tutti I Corsi Di Laurea</button>
            <button onclick="window.location.href='./visualizzaDocenti.php'">Visualizza Tutti I Docenti</button>
            <button onclick="window.location.href='./visualizzaStudenti.php'">Visualizza Tutti Gli Studenti</button>
            <button onclick="window.location.href='./visualizzaExStudenti.php'">Visualizza Tutti Gli Ex Studenti</button>
            <button onclick="window.location.href='./visualizzaSegretari.php'">Visualizza Tutti I Segretari</button>
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
