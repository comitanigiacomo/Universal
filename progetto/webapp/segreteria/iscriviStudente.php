<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}


if (isset($_POST['id_studente'])) {

    $id_studente = $_POST['id_studente'];
    $codice_appello = $_POST['codice_appello'];

    $query_subscription = "CALL universal.subscription($1, $2)";
    $result_subscription = pg_query_params($conn, $query_subscription, array($id_studente, $codice_appello));

    if ($result_subscription) {
        echo '<script type="text/javascript">alert("Studente iscritto correttamente");  window.location = "./index.php"; </script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nell\'iscrizione dello studente");  window.location = "./index.php";  </script>';
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
                    $query_get_all_students_of_cdl = "SELECT * FROM universal.get_all_students_of_cdl($1)";
                    $result_get_all_students_of_cdl = pg_query_params($conn, $query_get_all_students_of_cdl, array($_POST['codice_cdl']));

                    if ($result_get_all_students_of_cdl && pg_num_rows($result_get_all_students_of_cdl) > 0) {

                        while ($row_get_all_students_of_cdl = pg_fetch_assoc($result_get_all_students_of_cdl)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_students_of_cdl['nome'] . "</td>";
                            echo "<td>" . $row_get_all_students_of_cdl['cognome'] . "</td>";
                            echo "<td>" . $row_get_all_students_of_cdl['email'] . "</td>";
                            echo "<td>" . $row_get_all_students_of_cdl['matricola'] . "</td>";
                            echo "<td>" . $row_get_all_students_of_cdl['cdl'] . "</td>";
                            echo "<td>
                            <form method='post' action=''>
                                <input type='hidden' name='id_studente' value='" .  $row_get_all_students_of_cdl['id']  . "' />
                                <input type='hidden' name='codice_appello' value='" .  $_POST['codice_appello']  . "' />
                                <button type='submit'>Iscrivi Studente</button>
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
