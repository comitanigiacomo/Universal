<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

// Controlla se il form è stato inviato
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $nome = $_POST['nome'];
    $cognome = $_POST['cognome'];
    $tipo_utente = $_POST['tipo_utente'];
    $password = $_POST['password'];

    $query_insert_utente = "CALL universal.insert_utente($1, $2, $3, $4)";
    $result_insert_utente = pg_query_params($conn, $query_insert_utente, array($nome, $cognome, $tipo_utente, $password));

    if (!$result_insert_utente) {
        $error_message = pg_last_error($conn);
        echo '<script type="text/javascript">alert("Errore durante la creazione dell\'utente: ' . $error_message . '"); window.location = "./index.php";</script>';
    } else {
        echo '<script type="text/javascript">alert("Utente creato con successo"); window.location = "./index.php"; </script>';
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Inserisci Utente</title>
    <link rel="stylesheet" type="text/css" href="./changePassword.css">
</head>
<body>
    <div class="sfondo">
        <div class="contenitore">
            <div class="logo">
                <a class="nav-link" id="uni" aria-current="page" href="/login.php">Universal</a>
                <br>
                <br>
                <br>
            </div>
            <br>
            <br>
            <div class="home">
                    <a class="nav-link" id="home" aria-current="page" href="./index.php">Home</a>
            </div>
            <div class="titolo"><h3>Crea Utente</h3></div>
            <div class="modifica">
                <form method="POST" action="">
                    <div class="form-group">
                        <input id="nome" class="form-control input-lg typeahead top-buffer-s" name="nome" type="text" class="form-control bg-transparent rounded-0 my-4" placeholder="Nome" aria-label="Email" aria-describedby="basic-addon1">
                        <br>
                        <input id="cognome" class="form-control input-lg pass" name="cognome" type="text" class="form-control  bg-transparent rounded-0 my-4" placeholder="Cognome" aria-label="Username" aria-describedby="basic-addon1">
                        <br>
                        <select id="tipo_utente" class="form-control input-lg pass" name="tipo_utente">
                            <option value="studente">Studente</option>
                            <option value="docente">Docente</option>
                            <option value="segretario">Segretario</option>
                        </select>
                        <br>
                        <input id="password" class="form-control input-lg pass" name="password" type="password" class="form-control  bg-transparent rounded-0 my-4" placeholder="Password" aria-label="Username" aria-describedby="basic-addon1">
                        <br>
                        <button type="submit" class="btn btn-primary btn-lg btn-block">Create</button>
                    </div>
                </form> 
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
            <a href="https://google.com">Assistenza Universal</a>
            <br>
        </div>
    </footer>
</body>
</html>
