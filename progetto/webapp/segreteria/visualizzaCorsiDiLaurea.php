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
    <title>Corsi Di Universal</title>
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
            <div class="titolo"><h1>Corsi Di Universal</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Tipo</th>
                        <th>Descrizione</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    // Esegui la query per ottenere gli appelli degli esami
                    $query_get_all_cdl = "SELECT * FROM universal.get_all_cdl()";
                    $result_get_all_cdl = pg_query($conn, $query_get_all_cdl);

                    // Verifica se ci sono risultati
                    if ($result_get_all_cdl && pg_num_rows($result_get_all_cdl) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_all_cdl = pg_fetch_assoc($result_get_all_cdl)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_all_cdl['nome'] . "</td>";
                            echo "<td>" . $row_get_all_cdl['tipo'] . "</td>";
                            echo "<td>" . $row_get_all_cdl['descrizione'] . "</td>";
                            echo "<td>
                            <form method='post' action='./visualizzaInsegnamenti.php'>
                                <input type='hidden' name='codice_CdL' value='" . $row_get_all_cdl['codice']. "' />
                                <input type='hidden' name='codice_CdL2' value='" . $row_get_all_cdl['codice']. "' />
                                <button type='submit'>Visualizza Insegnamenti Del Corso</button>
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
            <div class="crea-corso">
                <form method="post" action="./creaCorsoDiLaurea.php">
                    <button type="submit">Crea Nuovo Corso di Laurea</button>
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
