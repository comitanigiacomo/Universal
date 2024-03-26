<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["appelloId"])) {
    // Ottieni l'ID dell'appello e dell'utente
    $appelloId = $_POST["appelloId"];
    $userId = $_SESSION['id'];
    print_r($appelloId, $userId);
    
    // Eseguire la chiamata alla procedura di iscrizione
    $query_subscribe = "CALL universal.subscription($1, $2)";
    $result_subscribe = pg_query_params($conn, $query_subscribe, array($userId, $appelloId));

    if ($result_subscribe) {
        echo '<script type="text/javascript">alert("Iscrizione effettuata con successo"); window.location = "./index.php";</script>';
    } else {
        echo '<script type="text/javascript">alert("Errore durante l\'iscrizione"); window.location = "./index.php";</script>';
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Appelli Del Corso</title>
    <link rel="stylesheet" type="text/css" href="./iscrizioni.css">
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
            <div class="titolo"><h1>Appelli Di Universal</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Data</th>
                        <th>Luogo</th>
                        <th>Insegnamento</th>
                        <th>Corso di laurea</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    // Esegui la query per ottenere gli appelli degli esami
                    $query_get_all_exam_sessions = "SELECT * FROM universal.get_all_exam_sessions()";
                    $result_get_all_exam_sessions = pg_query($conn, $query_get_all_exam_sessions);

                    // Verifica se ci sono risultati
                    if ($result_get_all_exam_sessions && pg_num_rows($result_get_all_exam_sessions) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_all_exam_sessions = pg_fetch_assoc($result_get_all_exam_sessions)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_exam_sessions['data'] . "</td>";
                            echo "<td>" . $row_get_all_exam_sessions['luogo'] . "</td>";
                            echo "<td>" . $row_get_all_exam_sessions['nome'] . "</td>";
                            echo "<td>" . $row_get_all_exam_sessions['corso_di_laurea'] . "</td>";
                            echo "<td>
                                    <form method='post' action=''>
                                        <input type='hidden' name='appelloId' value='".$row_get_all_exam_sessions['codice']."' />
                                        <button type='submit'>Iscriviti</button>
                                    </form>
                                </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='4'>Nessun appello disponibile al momento.</td></tr>";
                    }
                    ?>
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
