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
                    $query_get_all_exstudents = "SELECT * FROM universal.get_all_exstudents()";
                    $result_get_all_exstudents = pg_query($conn, $query_get_all_exstudents);

                    // Verifica se ci sono risultati
                    if ($result_get_all_exstudents && pg_num_rows($result_get_all_exstudents) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_all_exstudents = pg_fetch_assoc($result_get_all_exstudents)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_exstudents['nome'] . "</td>";
                            echo "<td>" . $row_get_all_exstudents['cognome'] . "</td>";
                            echo "<td>" . $row_get_all_exstudents['email'] . "</td>";
                            echo "<td>" . $row_get_all_exstudents['matricola'] . "</td>";
                            echo "<td>" . $row_get_all_exstudents['corso_di_laurea'] . "</td>";
                            echo "<td>
                            <form method='post' action='visualizzaCarriera.php'>
                                <input type='hidden' name='id_studente' value='" . $row_get_all_exstudents['id'] . "' />
                                <button type='submit'>VisualizzaCarriera.php</button>
                            </form>
                            <form method='post' action='./visualizzaCarrieraCompleta.php'>
                                <input type='hidden' name='id_studente' value='" . $row_get_all_exstudents['id'] . "' />
                                <button type='submit'>Visualizza Carriera Completa</button>
                            </form>
                            <form method='post' action='./modificaPasswordUtente.php'>
                                <input type='hidden' name='id_utente' value='" . $row_get_all_exstudents['id'] . "' />
                                <button type='submit'>Modifica Password</button>
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
