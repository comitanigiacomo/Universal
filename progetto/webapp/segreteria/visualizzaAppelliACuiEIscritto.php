<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["codice_appello"])) {
    // Recupera i dati dalla richiesta POST
    $id_studente = $_POST['id_studente2'];
    $codice_appello = $_POST['codice_appello'];
    
    // Esegui la chiamata alla procedura di inserimento della valutazione
    $query_unsubscribe_from_exam_appointment = "CALL universal.unsubscribe_from_exam_appointment($1, $2)";
    $result_unsubscribe_from_exam_appointment = pg_query_params($conn, $query_unsubscribe_from_exam_appointment, array($id_studente, $codice_appello));

    // Verifica se la procedura è stata eseguita con successo
    if ($result_unsubscribe_from_exam_appointment) {
        echo '<script type="text/javascript">alert("Studente disiscritto correttamente"); window.location = "./index.php";</script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nella disiscrizione dello studente); window.location = "./index.php";</script>';
    }

}

?>

<!DOCTYPE html>
<html>
<head>
    <title>Appelli A Cui È Iscritto</title>
    <link rel="stylesheet" type="text/css" href="style.css">
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
            <div class="titolo"><h1>Appelli A Cui È Iscritto</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Data</th>
                        <th>Luogo</th>
                        <th>Nome</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    // Esegui la query per ottenere gli appelli degli esami
                    $query_get_student_exam_enrollments = "SELECT * FROM universal.get_student_exam_enrollments($1)";
                    $result_get_student_exam_enrollments = pg_query_params($conn, $query_get_student_exam_enrollments, array($_POST['id_studente']));

                    // Verifica se ci sono risultati
                    if ($result_get_student_exam_enrollments && pg_num_rows($result_get_student_exam_enrollments) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_student_exam_enrollments = pg_fetch_assoc($result_get_student_exam_enrollments)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_student_exam_enrollments['data'] . "</td>";
                            echo "<td>" . $row_get_student_exam_enrollments['luogo'] . "</td>";
                            echo "<td>" . $row_get_student_exam_enrollments['nome_insegnamento'] . "</td>";
                            echo "<td>
                            <form method='post' action=''>
                                <input type='hidden' name='id_studente2' value='" . $_POST['id_studente2'] . "' />
                                <input type='hidden' name='codice_appello' value='" . $row_get_student_exam_enrollments['codice'] . "' />
                                <button type='submit'>Disiscrivi</button>
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
            <a href="https://google.com/">Assistenza Universal</a>
            <br>
        </div>
    </footer>
</body>
</html>
