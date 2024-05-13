<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["id_docente2"])) {

    $id_docente2 = $_POST['id_docente2'];

        $query_delete_teacher = "CALL universal.delete_teacher($1)";
        $result_delete_teacher = pg_query_params($conn, $query_delete_teacher, array($id_docente2));

        if ($result_delete_teacher) {
            echo '<script type="text/javascript">alert("Docente eliminato correttamente"); </script>';
        } else {
            echo '<script type="text/javascript">alert("Il docente è responsabile di almeno un insegnamento");</script>';
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
                    $query_get_all_teachers = "SELECT * FROM universal.get_all_teachers()";
                    $result_get_all_teachers = pg_query($conn, $query_get_all_teachers);

                    // Verifica se ci sono risultati
                    if ($result_get_all_teachers && pg_num_rows($result_get_all_teachers) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_all_teachers = pg_fetch_assoc($result_get_all_teachers)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_teachers['nome'] . "</td>";
                            echo "<td>" . $row_get_all_teachers['cognome'] . "</td>";
                            echo "<td>" . $row_get_all_teachers['email'] . "</td>";
                            echo "<td>" . $row_get_all_teachers['ufficio'] . "</td>";
                            echo "<td>
                            <form method='post' action='./visualizzaInsegnamentiDelDocente.php'>
                                <input type='hidden' name='id_docente' value='" . $row_get_all_teachers['id'] . "' />
                                <button type='submit'>Visualizza Corsi Di Cui È Responsabile</button>
                            </form>
                            <form method='post' action='./visualizzaValutazioniDate.php'>
                                <input type='hidden' name='id_docente' value='" . $row_get_all_teachers['id'] . "' />
                                <button type='submit'>Visualizza Valutazioni Assegnate</button>
                            </form>
                            <form method='post' action=''>
                                <input type='hidden' name='id_docente2' value='" . $row_get_all_teachers['id'] . "' />
                                <button type='submit'>Elimina Docente</button>
                            </form>
                            <form method='post' action='modificaPasswordUtente.php'>
                                <input type='hidden' name='id_utente' value='" . $row_get_all_teachers['id'] . "' />
                                <button type='submit'>Modifica Password</button>
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
