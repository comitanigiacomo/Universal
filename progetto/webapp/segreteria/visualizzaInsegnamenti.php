<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

$id_insegnamento = $_GET['id']; // Inizializza l'ID dell'insegnamento a null

// Verifica se è stato inviato il modulo per cambiare il responsabile del corso
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['id_nuovo_docente'])) {
    $id_insegnamento = $_POST['codice']; // Recupera l'ID dell'insegnamento dalla richiesta POST
    $id_nuovo_docente = $_POST['id_nuovo_docente']; // Recupera l'ID del nuovo docente responsabile dalla richiesta POST

    // Chiamata alla procedura change_course_responsible_teacher
    $query_change_responsible_teacher = "CALL universal.change_course_responsible_teacher('$id_nuovo_docente', $id_insegnamento)";
    $result_change_responsible_teacher = pg_query($conn, $query_change_responsible_teacher);

    // Verifica se la procedura è stata eseguita correttamente
    if ($result_change_responsible_teacher) {
        echo "Responsabile del corso cambiato con successo.";
        // Puoi reindirizzare l'utente o eseguire altre azioni qui
    } else {
        echo "Errore durante il cambio del responsabile del corso.";
        // Puoi gestire l'errore in base alle tue esigenze
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Insegnamenti Del Corso</title>
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
            <div class="titolo"><h1>Insegnamenti Del Corso</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Descrizione</th>
                        <th>Anno</th>
                        <th>Docente Responsabile</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    // Esegui la query per ottenere gli insegnamenti del corso specificato
                    if($id_insegnamento !== null) {
                        $query_get_teaching_of_cdl = "SELECT * FROM universal.get_teaching_of_cdl($1)";
                        $result_get_teaching_of_cdl = pg_query_params($conn, $query_get_teaching_of_cdl, array($id_insegnamento));

                        // Verifica se ci sono risultati
                        if ($result_get_teaching_of_cdl && pg_num_rows($result_get_teaching_of_cdl) > 0) {
                            // Itera sui risultati e stampa le righe della tabella
                            while ($row_get_teaching_of_cdl = pg_fetch_assoc($result_get_teaching_of_cdl)) {
                                echo "<tr>";
                                echo "<td>" . $row_get_teaching_of_cdl['nome'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl['descrizione'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl['anno'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl['responsabile'] . "</td>";
                                echo "<td>
                                <form method='post' action='./visualizzaAppelli.php'>
                                    <input type='hidden' name='codice' value='" . $row_get_teaching_of_cdl['codice'] . "' />
                                    <input type='hidden' name='responsabile' value='" .$row_get_teaching_of_cdl['responsabile'] . "' />
                                    <button type='submit'>Visualizza Appelli</button>
                                </form>
                                <form method='post' action=''>
                                    <input type='hidden' name='codice' value='" . $row_get_teaching_of_cdl['codice'] . "' />
                                    <input type='text' name='id_nuovo_docente' placeholder='Inserisci ID del nuovo docente' />
                                    <button type='submit'>Modifica Responsabile Del Corso</button>
                                </form>
                                </td>";
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='5'>Nessun insegnamento disponibile per questo corso.</td></tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>ID insegnamento non valido.</td></tr>";
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
