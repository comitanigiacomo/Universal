<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["appelloId"])) {
    // Ottieni l'ID dell'appello e dell'utente
    $appelloId = $_POST["appelloId"];
    $userId = $_SESSION['id'];
    
    // Eseguire la chiamata alla procedura di iscrizione
    $query_subscribe = "CALL universal.subscription($1, $2)";
    $result_subscribe = pg_query_params($conn, $query_subscribe, array($userId, $appelloId));

    if ($result_subscribe) {
        echo '<script type="text/javascript">alert("Iscrizione effettuata con successo"); window.location = "./visualizzaAppelliCorso.php";</script>';
    } else {
        echo '<script type="text/javascript">alert("Errore durante l\'iscrizione"); window.location = "./visualizzaAppelliCorso.php";</script>';
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
                <a class="nav-link" id="uni" aria-current="page" href="../login.php">Universal</a>
                <br><br>
                <a class="nav-link" id="home" aria-current="page" href="./index.php">Home</a>
            </div>
            <br>
            <br>
            <div class="titolo"><h1>Appelli Del Corso</h1></div>
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
                    $query_get_appointments = "SELECT * FROM universal.get_all_teaching_appointments_for_student_degree($1)";
                    $result_get_appointments = pg_query_params($conn, $query_get_appointments, array($_SESSION['id']));

                    // Verifica se ci sono risultati
                    if ($result_get_appointments && pg_num_rows($result_get_appointments) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_appointment = pg_fetch_assoc($result_get_appointments)) {
                            echo "<tr>";
                            echo "<td>" . $row_appointment['data'] . "</td>";
                            echo "<td>" . $row_appointment['luogo'] . "</td>";
                            echo "<td>" . $row_appointment['insegnamento'] . "</td>";
                            echo "<td>
                                    <form method='post' action=''>
                                        <input type='hidden' name='appelloId' value='".$row_appointment['codice']."' />
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
