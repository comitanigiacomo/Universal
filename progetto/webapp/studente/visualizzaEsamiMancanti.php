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
        <div class="titolo"><h1>Appelli Del Corso</h1></div>
        <div class="tabella">
            <table>
                <tr>
                    <th>Nome</th>
                    <th>Descrizione</th>
                    <th>Anno</th>
                    <th>Docente</th>
                </tr>
                <?php
                // Esegui la query per ottenere gli appelli degli esami a cui lo studente è attualmente iscritto
                $query_get_missing_exams_for_graduation = "SELECT * FROM universal.get_missing_exams_for_graduation($1)";
                $result_get_missing_exams_for_graduation = pg_query_params($conn, $query_get_missing_exams_for_graduation, array($_SESSION['id']));

                // Itera sui risultati e stampa le righe della tabella
                while ($row_get_missing_exams_for_graduation = pg_fetch_assoc($result_get_missing_exams_for_graduation)) {
                    echo "<tr>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['nome'] . "</td>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['descrizione'] . "</td>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['anno'] . "</td>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['docente_responsabile'] . "</td>";
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
