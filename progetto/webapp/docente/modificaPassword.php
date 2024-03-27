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
    // Ottieni le password inserite nel form
    $vecchia_password = $_POST['old_password'];
    $nuova_password = $_POST['new_password'];

    // Chiamata alla procedura per cambiare la password
    $query_change_password = "CALL universal.change_password($1, $2, $3)";
    $result_change_password = pg_query_params($conn, $query_change_password, array($_SESSION['id'], $vecchia_password, $nuova_password));

    // Controllo del risultato della query
    if (!$result_change_password) {
        echo '<script type="text/javascript">alert("Error: Errore durante il cambio password"); window.location = "./index.php";</script>';
        exit();
    }

    echo '<script type="text/javascript">alert("Error: Password cambiata con successo"); window.location = "./index.php";</script>';
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Iscrizioni</title>
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
        <div class="titolo"><h3>Modifica Password</h3></div>
        <div class="modifica">
        <form method="POST" action="">
    <div class="form-group">
        <input id="old_password" class="form-control input-lg typeahead top-buffer-s" name="old_password" type="password" class="form-control bg-transparent rounded-0 my-4" placeholder="Old Password" aria-label="Email" aria-describedby="basic-addon1">
        <br>
        <input id="new_password" class="form-control input-lg pass" name="new_password" type="password" class="form-control  bg-transparent rounded-0 my-4" placeholder="New Password" aria-label="Username" aria-describedby="basic-addon1">
        <br>
        <button type="submit" class="btn btn-primary btn-lg btn-block">Change</button>
    </div>
</form> 
                
    
        </div>
        

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
