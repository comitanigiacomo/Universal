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
    <title>Valutazioni assegnate</title>
    <link rel="stylesheet" type="text/css" href="../studente/iscrizioni.css">
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
            <div class="titolo"><h1>valutazioni assegnate</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Cognome</th>
                        <th>Matricola</th>
                        <th>Data</th>
                        <th>Luogo</th>
                        <th>Insegnamento</th>
                        <th>Voto</th>
                    </tr>
                    <?php
                    $query_get_teacher_grades = "SELECT * FROM universal.get_teacher_grades($1)";
                    $result_get_teacher_grades = pg_query_params($conn, $query_get_teacher_grades, array($_SESSION['id']));

                    // Verifica se ci sono risultati
                    if ($result_get_teacher_grades && pg_num_rows($result_get_teacher_grades) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_teacher_grades = pg_fetch_assoc($result_get_teacher_grades)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_teacher_grades['nome'] . "</td>";
                            echo "<td>" . $row_get_teacher_grades['cognome'] . "</td>";
                            echo "<td>" . $row_get_teacher_grades['matricola'] . "</td>";
                            echo "<td>" . $row_get_teacher_grades['data'] . "</td>";
                            echo "<td>" . $row_get_teacher_grades['luogo'] . "</td>";
                            echo "<td>" . $row_get_teacher_grades['insegnamento'] . "</td>";
                            echo "<td>" . $row_get_teacher_grades['voto'] . "</td>";  
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='7'>Nessuna valutazione assegnata.</td></tr>";
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
