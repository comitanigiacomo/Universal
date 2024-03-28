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
                    // Esegui la query per ottenere gli appelli degli esami
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
                            <form method='post' action=''>
                                <input type='hidden' name='codice_appello' value='' />
                                <button type='submit'>VisualizzaCarriera.php</button>
                            </form>
                            <form method='post' action='./visualizzaCarrieraCompleta.php.php'>
                                <input type='hidden' name='codice_appello' value='' />
                                <button type='submit'>Visualizza Carriera Completa</button>
                            </form>
                            </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='4'>Nessun appello disponibile al momento.</td></tr>";
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
