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
    <title>Esami Mancanti</title>
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
        <div class="titolo"><h1>Esami Mancanti Al Conseguimento Della Laurea</h1></div>
        <div class="tabella">
            <table>
                <tr>
                    <th>Nome</th>
                    <th>Descrizione</th>
                    <th>Anno</th>
                    <th>Docente</th>
                    <th>Codice</th>
                </tr>
                <?php
 
                $query_get_missing_exams_for_graduation = "SELECT * FROM universal.get_missing_exams_for_graduation($1)";
                $result_get_missing_exams_for_graduation = pg_query_params($conn, $query_get_missing_exams_for_graduation, array($_POST['id_studente']));

                while ($row_get_missing_exams_for_graduation = pg_fetch_assoc($result_get_missing_exams_for_graduation)) {
                    echo "<tr>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['nome'] . "</td>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['descrizione'] . "</td>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['anno'] . "</td>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['docente_responsabile'] . "</td>";
                    echo "<td>" . $row_get_missing_exams_for_graduation['corso_di_laurea'] . "</td>";
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
            <a href="https://google.com">Assistenza Universal</a>
            <br>
        </div>
    </footer>

    

</body>
</html>
