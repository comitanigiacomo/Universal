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
    <title>Insegnamenti Di Cui Il Docente è Responsabile</title>
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
            <div class="home">
                    <a class="nav-link" id="home" aria-current="page" href="./index.php">Home</a>
            </div>
            <div class="titolo"><h1>Insegnamenti Di Cui Il Docente è Responsabile</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Descrizione</th>
                        <th>Anno</th>
                        <th>Corso Di Laurea</th>
                    </tr>
                    <?php
                   
                        $query_get_teaching_activity_of_professor = "SELECT * FROM universal.get_teaching_activity_of_professor($1)";
                        $result_get_teaching_activity_of_professor = pg_query_params($conn, $query_get_teaching_activity_of_professor, array($_POST['id_docente']));

                        if ($result_get_teaching_activity_of_professor && pg_num_rows($result_get_teaching_activity_of_professor) > 0) {
                            while ($row_get_teaching_activity_of_professor = pg_fetch_assoc($result_get_teaching_activity_of_professor)) {
                                echo "<tr>";
                                echo "<td>" . $row_get_teaching_activity_of_professor['nome'] . "</td>";
                                echo "<td>" . $row_get_teaching_activity_of_professor['descrizione'] . "</td>";
                                echo "<td>" . $row_get_teaching_activity_of_professor['anno'] . "</td>";
                                echo "<td>" . $row_get_teaching_activity_of_professor['nome_cdl'] . "</td>";
                    echo "</tr>";
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='4'>Il docente non è responsabile di nessun corso</td></tr>";
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
