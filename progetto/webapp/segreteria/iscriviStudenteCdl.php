<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['codice_cdl'])) {

    $id_studente = $_POST['id_studente'];
    $codice_cdl = $_POST['codice_cdl'];
    
    $query_subsribe_to_cdl = "CALL universal.subsribe_to_cdl($1, $2)";
    $result_subsribe_to_cdl = pg_query_params($conn, $query_subsribe_to_cdl, array($id_studente, $codice_cdl));

    if ($result_subsribe_to_cdl) {
        echo '<script type="text/javascript">alert("Studente iscritto correttamente"); window.location = "./index.php";</script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nella iscrizione dello studente"); window.location = "./index.php";</script>';
    }

}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Iscrivi A CdL</title>
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
            <div class="titolo"><h1>Iscrivi A CdL</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Tipo</th>
                        <th>Descrizione</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    $query_get_all_cdl = "SELECT * FROM universal.get_all_cdl()";
                    $result_get_all_cdl = pg_query($conn, $query_get_all_cdl);

                    if ($result_get_all_cdl && pg_num_rows($result_get_all_cdl) > 0) {

                        while ($row_get_all_cdl = pg_fetch_assoc($result_get_all_cdl)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_cdl['nome'] . "</td>";
                            echo "<td>" . $row_get_all_cdl['tipo'] . "</td>";
                            echo "<td>" . $row_get_all_cdl['descrizione'] . "</td>";
                            echo "<td>
                            <form method='post' action=''>
                                <input type='hidden' name='id_studente' value='" . $_POST['id_studente'] . "' />
                                <input type='hidden' name='codice_cdl' value='" . $row_get_all_cdl['codice']. "' />
                                <button type='submit'>Iscrivi</button>
                            </form>
                            </td>";
                            
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='4'>Nessun CdL disponibile al momento.</td></tr>";
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
