<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}

$codice_cdl = $_POST['codice_cdl'];
$codice_corso = $_POST['codice_corso'];

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['codice_prop'])) {

    $codice_corso = $_POST['codice_corso'];
    $codice_prop = $_POST['codice_prop'];

    $query_insert_propaedeutics = "CALL universal.insert_propaedeutics($1, $2)";
    $result_insert_propaedeutics = pg_query_params($conn, $query_insert_propaedeutics, array($codice_corso, $codice_prop));

    if ($result_insert_propaedeutics) {
        echo '<script type="text/javascript">alert("Propedeuticità inserito correttamente");</script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nell\'inserimento della propedeuticità");</script>';
    }

}

?>

<!DOCTYPE html>
<html>
<head>
    <title>Crea Propedeuticità</title>
    <link rel="stylesheet" type="text/css" href="./style.css">
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
            <div class="titolo"><h1>Crea Propedeuticità</h1></div>
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
                    if($codice_cdl !== null) {
                        $query_get_teaching_of_cdl_for_propaedeutics = "SELECT * FROM universal.get_teaching_of_cdl_for_propaedeutics($1, $2)";
                        $result_get_teaching_of_cdl_for_propaedeutics = pg_query_params($conn, $query_get_teaching_of_cdl_for_propaedeutics, array($codice_cdl, $codice_corso));

                        if ($result_get_teaching_of_cdl_for_propaedeutics && pg_num_rows($result_get_teaching_of_cdl_for_propaedeutics) > 0) {
                            while ($row_get_teaching_of_cdl_for_propaedeutics = pg_fetch_assoc($result_get_teaching_of_cdl_for_propaedeutics)) {
                                echo "<tr>";
                                echo "<td>" . $row_get_teaching_of_cdl_for_propaedeutics['nome'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl_for_propaedeutics['descrizione'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl_for_propaedeutics['anno'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl_for_propaedeutics['responsabile'] . "</td>";
                                echo "<td>
                                    <form method='post' action=''>
                                        <input type='hidden' name='codice_prop' value='" . $row_get_teaching_of_cdl_for_propaedeutics['codice'] . "' />
                                        <input type='hidden' name='codice_corso' value='" . $codice_corso. "' />
                                        <button type='submit'>Aggiungi Propedeuticità</button>
                                    </form>
                                </td>";
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='5'>Nessuna propedeuticità disponibile per questo corso.</td></tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>ID CdL non valido.</td></tr>";
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
