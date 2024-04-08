<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

$nome = $_POST['nome'];
$cognome = $_POST['cognome'];
$email = $_POST['email'];
$matricola = $_POST['matricola'];
$corso_di_laurea = $_POST['corso_di_laurea'];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["id_studente_per_disiscrizione"])) {
    // Recupera i dati dalla richiesta POST
    $id_studente = $_POST['id_studente_per_disiscrizione'];
    $motivo = $_POST['motivo'];
    print_r($motivo);
    
    // Esegui la chiamata alla procedura di inserimento della valutazione
    $query_studentToExStudent = "CALL universal.studentToExStudent($1, $2)";
    $result_studentToExStudent = pg_query_params($conn, $query_studentToExStudent, array($id_studente, $motivo));

    // Verifica se la procedura è stata eseguita con successo
    if ($result_studentToExStudent) {
        echo '<script type="text/javascript">alert("Studente Disiscritto Correttamente"); </script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nella disiscrizione dello studente); </script>';
    }

}

?>

<!DOCTYPE html>
<html>
<head>
    <title>Studenti Universal</title>
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
                <p>Qui puoi gestire lo studente.</p>
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
                    <label for="email">Email:</label>
                    <span id="email"><?php echo $email; ?></span>
                </div>
                <div>
                    <label for="corso_di_laurea">Corso di Laurea:</label>
                    <span id="corso_di_laurea"><?php echo $corso_di_laurea; ?></span>
                </div>
            </div>
            <div class="funzioni">
                <form method='post' action='./visualizzaCarriera.php'>
                    <input type='hidden' name='id_studente' value='<?php echo $_POST['id_studente']; ?>' />
                    <button type='submit'>Visualizza Carriera</button>
                </form>
                <form method='post' action='./visualizzaCarrieraCompleta.php'>
                    <input type='hidden' name='id_studente' value='<?php echo $_POST['id_studente']; ?>' />
                    <button type='submit'>Visualizza Carriera Completa</button>
                </form>
                <form method='post' action='./visualizzaAppelliACuiEIscritto.php'>
                    <input type='hidden' name='id_studente' value='<?php echo $_POST['id_studente']; ?>' />
                    <button type='submit'>Visualizza Appelli a cui è iscritto</button>
                </form>
                <form method='post' action=''>
                    <input type='hidden' name='id_studente_per_disiscrizione' value='<?php echo $_POST['id_studente']; ?>' />
                    <select name='motivo'>
                        <option value='laureato'>Laureato</option>
                        <option value='rinuncia'>Rinuncia</option>
                    </select>
                    <button type='submit'>Disiscrivi</button>
                </form>
                <form method='post' action='./iscriviStudenteCdl.php'>
                    <input type='hidden' name='id_studente' value='<?php echo $_POST['id_studente']; ?>' />
                    <button type='submit'>Iscrivi Ad Un CdL</button>
                </form>
                <form method='post' action='./visualizzaEsamiMancanti.php'>
                    <input type='hidden' name='id_studente' value='<?php echo $_POST['id_studente']; ?>' />
                    <button type='submit'>Visualizza Esami Mancanti Alla Laurea</button>
                </form>
                <form method='post' action='./modificaPasswordUtente.php'>
                    <input type='hidden' name='id_utente' value='<?php echo $_POST['id_studente']; ?>' />
                    <button type='submit'>Modifica Password</button>
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
            <a href="https://letmegooglethat.com/?q=cerca+qui+i+tuoi+problemi%2C+grazie">Assistenza Universal</a>
            <br>
        </div>
    </footer>

</body>
</html>
