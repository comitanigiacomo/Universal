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
                                <button onclick=\"window.location.href='./visualizzaInsegnamenti.php?id=" . $row_get_all_cdl['codice'] . "'\">Visualizza Insegnamenti Del Corso</button>
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
