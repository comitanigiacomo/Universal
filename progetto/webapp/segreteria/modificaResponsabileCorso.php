<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["id_docente"])) {

    $id_docente = $_POST['id_docente'];
    $codice_insegnamento = $_POST['codice_insegnamento'];
    print_r($codice_insegnamento);
    
    $query_change_course_responsible_teacher = "CALL universal.change_course_responsible_teacher($1, $2)";
    $result_change_course_responsible_teacher = pg_query_params($conn, $query_change_course_responsible_teacher, array($id_docente, $codice_insegnamento));

    if ($result_change_course_responsible_teacher) {
        echo '<script type="text/javascript">alert("Responsabile cambiato correttamente");  window.location = "./index.php"; </script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nel cambio del responsabile);  window.location = "./index.php"; </script>';
    }

}

?>

<!DOCTYPE html>
<html>
<head>
    <title>Docenti di Universal</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    <div class="sfondo">
        <div class="contenitore">
            <div class="logo">
                <a class="nav-link" id="uni" aria-current="page" href="../login.php">Universal</a>
                <br><br>
            </div>
            <br>
            <br>
            <div class="home">
                    <a class="nav-link" id="home" aria-current="page" href="./index.php">Home</a>
            </div>
            <div class="titolo"><h1>Docenti di Universal</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Cognome</th>
                        <th>Email</th>
                        <th>Ufficio</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    // Esegui la query per ottenere gli appelli degli esami
                    $query_get_all_teachers_for_change_responsibility = "SELECT * FROM universal.get_all_teachers_for_change_responsibility($1)";
                    $result_get_all_teachers_for_change_responsibility = pg_query_params($conn, $query_get_all_teachers_for_change_responsibility, array($_POST['responsabile']));

                    // Verifica se ci sono risultati
                    if ($result_get_all_teachers_for_change_responsibility && pg_num_rows($result_get_all_teachers_for_change_responsibility) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_all_teachers_for_change_responsibility = pg_fetch_assoc($result_get_all_teachers_for_change_responsibility)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_teachers_for_change_responsibility['nome'] . "</td>";
                            echo "<td>" . $row_get_all_teachers_for_change_responsibility['cognome'] . "</td>";
                            echo "<td>" . $row_get_all_teachers_for_change_responsibility['email'] . "</td>";
                            echo "<td>" . $row_get_all_teachers_for_change_responsibility['ufficio'] . "</td>";
                            echo "<td>
                            <form method='post' action=''>
                                <input type='hidden' name='id_docente' value='" . $row_get_all_teachers_for_change_responsibility['id'] . "' />
                                <input type='hidden' name='codice_insegnamento' value='" . $_POST['codice_insegnamento'] . "' />
                                <button type='submit'>Assegna Come Nuovo Responsabile</button>
                            </form>
                            </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>Nessun docente disponibile al momento.</td></tr>";
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
