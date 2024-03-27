<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

// Recupera il parametro codice_insegnamento dalla URL

$codice_insegnamento = $_GET['codice_insegnamento'];

// Variabili per memorizzare i valori predefiniti per nome e corso di laurea
$nome = ""; // Inizializza vuoto per evitare errori
$corso_di_laurea = ""; // Inizializza vuoto per evitare errori

// Se il modulo di creazione di un nuovo appello è stato inviato
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["crea_appello"])) {
    // Recupera i dati dal form
    $data = $_POST['data'];
    $luogo = $_POST['luogo'];

    // Chiamata alla procedura per creare un nuovo appello
    // Chiamata alla procedura per creare un nuovo appello
    $query_create_exam_session = "CALL universal.create_exam_session($1, $2, $3, $4)";
    $result_create_exam_session = pg_query_params($conn, $query_create_exam_session, array($_SESSION['id'], $data, $luogo, $codice_insegnamento ));

    if ($result_create_exam_session) {
        // Appello creato con successo
        // Esegui le azioni necessarie, ad esempio reindirizzamento o visualizzazione di un messaggio di successo
        echo '<script>alert("Nuovo appello creato con successo!");</script>';
        header("Location: ./index.php");
        exit();
    } else {
        // Errore durante la creazione dell'appello
        echo '<script>alert("Errore nella creazione dell `\'appello");</script>';
    }
}

// Esegui la query per ottenere gli appelli degli esami per l'insegnamento specificato
$query_get_exam_sessions = "SELECT * FROM universal.get_exam_sessions($1)";
$result_get_exam_sessions = pg_query_params($conn, $query_get_exam_sessions, array($codice_insegnamento));

?>

<!DOCTYPE html>
<html>
<head>
    <title>Appelli Di Cui Sei Responsabile</title>
    <link rel="stylesheet" type="text/css" href="./style.css">
</head>
<body>
    <div class="sfondo">
        <div class="contenitore">
            <div class="logo">
                <a class="nav-link" id="uni" aria-current="page" href="/login.php">Universal</a>
                <br><br>
            </div>
            <br>
            <br>
            <div class="titolo"><h1>Appelli Di Cui Sei Responsabile</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Data</th>
                        <th>Luogo</th>
                        <th>Nome</th>
                        <th>Corso di laurea</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    // Verifica se ci sono risultati
                    if ($result_get_exam_sessions && pg_num_rows($result_get_exam_sessions) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_exam_sessions = pg_fetch_assoc($result_get_exam_sessions)) {
                            // Assegna i valori alle variabili
                            $nome = $row_get_exam_sessions['nome'];
                            $corso_di_laurea = $row_get_exam_sessions['corso_di_laurea'];

                            echo "<tr>";
                            echo "<td>" . $row_get_exam_sessions['data'] . "</td>";
                            echo "<td>" . $row_get_exam_sessions['luogo'] . "</td>";
                            echo "<td>" . $nome . "</td>";
                            echo "<td>" . $corso_di_laurea . "</td>";
                            echo "<td>
                                <form method='get' action='./visualizzaIscritti.php'>
                                    <input type='hidden' name='codice_appello' value='" . $row_get_exam_sessions['codice_appello'] . "' />
                                    <button type='submit'>Visualizza Iscritti</button>
                                </form>
                            </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='4'>Nessun appello disponibile al momento.</td></tr>";
                    }
                    ?>

                    <tr>
                        <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                            <td><input type="date" name="data" required></td>
                            <td><input type="text" name="luogo" placeholder="Luogo" required></td>
                            <td><?php echo $nome; ?></td>
                            <td><?php echo $corso_di_laurea; ?></td> 
                            <td><button type="submit" name="crea_appello">Crea Nuovo Appello</button></td>
                        </form>
                    </tr>
                </table>
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
