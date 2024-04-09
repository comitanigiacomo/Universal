<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

$id_insegnamento =$_POST['codice'];

?>

<!DOCTYPE html>
<html>
<head>
    <title>Insegnamenti Del Corso</title>
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
                    if($id_insegnamento !== null) {
                        $query_get_propaedeutics = "SELECT * FROM universal.get_propaedeutics($1)";
                        $result_get_propaedeutics = pg_query_params($conn, $query_get_propaedeutics, array($id_insegnamento));

                        if ($result_get_propaedeutics && pg_num_rows($result_get_propaedeutics) > 0) {
                            while ($row_get_propaedeutics = pg_fetch_assoc($result_get_propaedeutics)) {
                                echo "<tr>";
                                echo "<td>" . $row_get_propaedeutics['nome'] . "</td>";
                                echo "<td>" . $row_get_propaedeutics['descrizione'] . "</td>";
                                echo "<td>" . $row_get_propaedeutics['anno'] . "</td>";
                                echo "<td>" . $row_get_propaedeutics['docente_responsabile'] . "</td>";
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='5'>Nessuna propedeuticità disponibile per questo corso.</td></tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>ID insegnamento non valido.</td></tr>";
                    }
                    ?>
                </table>
            </div>

            <div class="crea-prop">
                <form method="post" action="./creaPropedeuticità.php">
                    <input type='hidden' name='codice_corso' value='<?php echo $id_insegnamento; ?>' />
                    <input type='hidden' name='codice_cdl' value='<?php echo $_POST['codice_cdl']; ?>' />
                    <button type="submit">Crea Nuova Propedeuticità Del Corso</button>
                </form>
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
