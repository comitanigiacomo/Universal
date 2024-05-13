<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}

$id_insegnamento = null; // Inizializza l'ID dell'insegnamento a null

if(isset($_GET['id'])) {
    // Recupera e sanifica l'ID dell'insegnamento
    $id_insegnamento = filter_var($_GET['id'], FILTER_SANITIZE_NUMBER_INT);
}

?>

<!DOCTYPE html>
<html>
<head>
    <title>Insegnamenti Del Corso</title>
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
            <div class="titolo"><h1>Insegnamenti Del Corso</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Descrizione</th>
                        <th>Anno</th>
                        <th>Docente Responsabile</th>
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
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='4'>Nessun insegnamento disponibile per questo corso.</td></tr>";
                        }
                    } else {
                        echo "<tr><td colspan='4'>ID insegnamento non valido.</td></tr>";
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
