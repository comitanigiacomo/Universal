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
    
    // Esegui la chiamata alla procedura di disiscrizione
    $query_unsubscribe = "CALL universal.unsubscribe_from_exam_appointment($1, $2)";
    $result_unsubscribe = pg_query_params($conn, $query_unsubscribe, array($userId, $appelloId));

    if ($result_unsubscribe) {
        echo '<script type="text/javascript">alert("Disiscrizione effettuata con successo"); window.location = "./index.php";</script>';
    } else {
        echo '<script type="text/javascript">alert("Errore durante la disiscrizione"); window.location = "./index.php";</script>';
    }

}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Iscrizioni</title>
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
        <div class="titolo"><h1>Iscrizioni confermate</h1></div>
        <div class="tabella">
            <table>
                <tr>
                    <th>Data</th>
                    <th>Luogo</th>
                    <th>Insegnamento</th>
                    <th>Azioni</th>
                </tr>
                <?php
                // Esegui la query per ottenere gli appelli degli esami a cui lo studente è attualmente iscritto
                $query_get_enrollments = "SELECT * FROM universal.get_student_exam_enrollments($1)";
                $result_get_enrollments = pg_query_params($conn, $query_get_enrollments, array($_SESSION['id']));

                // Itera sui risultati e stampa le righe della tabella
                while ($row_enrollments = pg_fetch_assoc($result_get_enrollments)) {
                    echo "<tr>";
                    echo "<td>" . $row_enrollments['data'] . "</td>";
                    echo "<td>" . $row_enrollments['luogo'] . "</td>";
                    echo "<td>" . $row_enrollments['nome_insegnamento'] . "</td>";
                    // Form per la disiscrizione
                    echo "<td>
                            <form method='post' action='".$_SERVER['PHP_SELF']."'>
                                <input type='hidden' name='appelloId' value='".$row_enrollments['codice']."' />
                                <button type='submit'>Disiscriviti</button>
                            </form>
                        </td>";
                    echo "</tr>";
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
