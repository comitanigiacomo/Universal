<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["id_studente"])) {

    $id_studente = $_POST['id_studente'];
    $motivo = $_POST['motivo'];

    $query_studentToExStudent = "CALL universal.studentToExStudent($1, $2)";
    $result_studentToExStudent = pg_query_params($conn, $query_studentToExStudent, array($id_studente, $motivo));

    if ($result_studentToExStudent) {
        echo '<script type="text/javascript">alert("Studente disiscritto correttamente"); </script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nella disiscrizione dello studente"); </script>';
    } 
}

?>

<!DOCTYPE html>
<html>
<head>
    <title>Studenti di Universal</title>
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
            <div class="titolo"><h1>Studenti di Universal</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Cognome</th>
                        <th>Email</th>
                        <th>Matricola</th>
                        <th>Corso Di Laurea</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    $query_get_all_students = "SELECT * FROM universal.get_all_students()";
                    $result_get_all_students = pg_query($conn, $query_get_all_students);

                    if ($result_get_all_students && pg_num_rows($result_get_all_students) > 0) {
                        while ($row_get_all_students = pg_fetch_assoc($result_get_all_students)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_students['nome'] . "</td>";
                            echo "<td>" . $row_get_all_students['cognome'] . "</td>";
                            echo "<td>" . $row_get_all_students['email'] . "</td>";
                            echo "<td>" . $row_get_all_students['matricola'] . "</td>";
                            echo "<td>" . $row_get_all_students['corso_di_laurea'] . "</td>";
                            echo "<td>
                            <form method='post' action='./gestisciStudente.php'>
                                <input type='hidden' name='id_studente' value='" . $row_get_all_students['id'] . "' />
                                <input type='hidden' name='nome' value='" . $row_get_all_students['nome']  . "' />
                                <input type='hidden' name='cognome' value='" . $row_get_all_students['cognome']  . "' />
                                <input type='hidden' name='email' value='" . $row_get_all_students['email'] . "' />
                                <input type='hidden' name='matricola' value='" . $row_get_all_students['matricola'] . "' />
                                <input type='hidden' name='corso_di_laurea' value='" .  $row_get_all_students['corso_di_laurea']  . "' />
                                <button type='submit'>Gestisci Studente</button>
                            </form>
                            </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='6'>Nessuno studente disponibile al momento.</td></tr>";
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
