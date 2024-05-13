<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}



if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["voto"])) {
    // Recupera i dati dalla richiesta POST
    $id_studente = $_POST['_id'];
    $id_docente = $_SESSION['id'];
    $codice_appello = $_POST['codice_appello'];
    $voto = $_POST['voto'];
    
    // Esegui la chiamata alla procedura di inserimento della valutazione
    $query_insert_grade = "CALL universal.insert_grade($1, $2, $3, $4)";
    $result_insert_grade = pg_query_params($conn, $query_insert_grade, array($id_studente, $id_docente, $codice_appello, $voto));

    // Verifica se la procedura è stata eseguita con successo
    if ($result_insert_grade) {
        echo '<script type="text/javascript">alert("Valutazione inserita correttamente"); window.location = "./index.php";</script>';
    } else {
        echo '<script type="text/javascript">alert("Errore durante l\'inserimento della valutazione"); window.location = "./index.php";</script>';
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Iscritti All'appello</title>
    <link rel="stylesheet" type="text/css" href="./style.css">
</head>
<body>
    <div class="sfondo">
        <div class="contenitore">
            <div class="logo">
                <a class="nav-link" id="uni" aria-current="page" href="../login.php">Universal</a>
                <br><br>
                <a class="nav-link" id="home" aria-current="page" href="./index.php">Home</a>
            </div>
            <br>
            <br>
            <div class="titolo"><h1>Iscritti All'appello</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Cognome</th>
                        <th>Email</th>
                        <th>Matricola</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    $codice_appello = $_POST['codice_appello'];

                    // Esegui la query per ottenere gli iscritti all'appello specificato
                    $query_get_exam_enrollments = "SELECT * FROM universal.get_exam_enrollments($1)";
                    $result_get_exam_enrollments = pg_query_params($conn, $query_get_exam_enrollments, array($codice_appello));

                    // Verifica se ci sono risultati
                    if ($result_get_exam_enrollments && pg_num_rows($result_get_exam_enrollments) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_exam_enrollments = pg_fetch_assoc($result_get_exam_enrollments)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_exam_enrollments['nome'] . "</td>";
                            echo "<td>" . $row_get_exam_enrollments['cognome'] . "</td>";
                            echo "<td>" . $row_get_exam_enrollments['email'] . "</td>";
                            echo "<td>" . $row_get_exam_enrollments['matricola'] . "</td>";
                            echo "<td>
                                <form method='post' action='".$_SERVER['PHP_SELF']."'>
                                    <input type='hidden' name='codice_appello' value='" . $codice_appello . "' />
                                    <input type='hidden' name='_id' value='" . $row_get_exam_enrollments['_id'] . "' />
                                    <input type='hidden' name='id_docente' value='" . $_SESSION['id'] . "' />
                                    <input type='text' name='voto' placeholder='Inserisci il voto' required />
                                    <button type='submit'>Inserisci Valutazione</button>
                                </form>
                            </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>Nessun iscritto all'appello.</td></tr>";
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
