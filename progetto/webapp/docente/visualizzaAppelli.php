<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}
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
                    // Recupera il parametro codice_insegnamento dalla URL
                    $codice_insegnamento = $_GET['codice_insegnamento'];

                    // Esegui la query per ottenere gli appelli degli esami per l'insegnamento specificato
                    $query_get_exam_sessions = "SELECT * FROM universal.get_exam_sessions($1)";
                    $result_get_exam_sessions = pg_query_params($conn, $query_get_exam_sessions, array($codice_insegnamento));

                    // Verifica se ci sono risultati
                    if ($result_get_exam_sessions && pg_num_rows($result_get_exam_sessions) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_exam_sessions = pg_fetch_assoc($result_get_exam_sessions)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_exam_sessions['data'] . "</td>";
                            echo "<td>" . $row_get_exam_sessions['luogo'] . "</td>";
                            echo "<td>" . $row_get_exam_sessions['nome'] . "</td>";
                            echo "<td>" . $row_get_exam_sessions['corso_di_laurea'] . "</td>";
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
