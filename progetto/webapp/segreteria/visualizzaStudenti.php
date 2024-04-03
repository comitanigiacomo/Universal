<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["id_studente"])) {
    // Recupera i dati dalla richiesta POST
    $id_studente = $_POST['id_studente'];
    $motivo = $_POST['motivo'];
    
    // Esegui la chiamata alla procedura di disiscrizione dello studente
    $query_studentToExStudent = "CALL universal.studentToExStudent($1, $2)";
    $result_studentToExStudent = pg_query_params($conn, $query_studentToExStudent, array($id_studente, $motivo));

    if (!$result_studentToExStudent) {
        $error_message = pg_last_error($conn);
        echo '<script type="text/javascript">alert("Errore nella disiscrizione dello studente: ' . $error_message . '"); </script>';
    }

    // Verifica se la procedura è stata eseguita con successo
    if ($result_studentToExStudent) {
        echo '<script type="text/javascript">alert("Studente disiscritto correttamente"); </script>';
    } else {
        echo '<script type="text/javascript">alert("Errore nella disiscrizione dello studente"); </script>';
    } // Termina lo script dopo il reindirizzamento
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
                <a class="nav-link" id="uni" aria-current="page" href="/login.php">Universal</a>
                <br><br>
            </div>
            <br>
            <br>
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
                    // Esegui la query per ottenere gli studenti
                    $query_get_all_students = "SELECT * FROM universal.get_all_students()";
                    $result_get_all_students = pg_query($conn, $query_get_all_students);

                    // Verifica se ci sono risultati
                    if ($result_get_all_students && pg_num_rows($result_get_all_students) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_all_students = pg_fetch_assoc($result_get_all_students)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_students['nome'] . "</td>";
                            echo "<td>" . $row_get_all_students['cognome'] . "</td>";
                            echo "<td>" . $row_get_all_students['email'] . "</td>";
                            echo "<td>" . $row_get_all_students['matricola'] . "</td>";
                            echo "<td>" . $row_get_all_students['corso_di_laurea'] . "</td>";
                            echo "<td>
                            <form method='post' action='./visualizzaCarriera.php'>
                                <input type='hidden' name='id_studente' value='" . $row_get_all_students['id'] . "' />
                                <button type='submit'>Visualizza Carriera</button>
                            </form>
                            <form method='post' action='./visualizzaCarrieraCompleta.php'>
                                <input type='hidden' name='id_studente' value='" . $row_get_all_students['id'] . "' />
                                <button type='submit'>Visualizza Carriera Completa</button>
                            </form>
                            <form method='post' action='./visualizzaAppelliACuiEIscritto.php'>
                                <input type='hidden' name='id_studente' value='" . $row_get_all_students['id'] . "' />
                                <button type='submit'>Visualizza Appelli a cui è iscritto</button>
                            </form>
                            <form method='post' action=''>
                                <input type='hidden' name='id_studente' value='" . $row_get_all_students['id'] . "' />
                                <select name='motivo'>
                                    <option value='laureato'>Laureato</option>
                                    <option value='rinuncia'>Rinuncia</option>
                                </select>
                                <br>
                                <button type='submit'>Disiscrivi</button>
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
