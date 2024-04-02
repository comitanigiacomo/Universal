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
    <title>Segretari di Universal</title>
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
            <div class="titolo"><h1>Segretari di Universal</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Nome</th>
                        <th>Cognome</th>
                        <th>Email</th>
                        <th>Sede</th>
                    </tr>
                    <?php
                    // Esegui la query per ottenere gli appelli degli esami
                    $query_get_secretaries = "SELECT * FROM universal.get_secretaries()";
                    $result_get_secretaries = pg_query($conn, $query_get_secretaries);

                    // Verifica se ci sono risultati
                    if ($result_get_secretaries && pg_num_rows($result_get_secretaries) > 0) {
                        // Itera sui risultati e stampa le righe della tabella
                        while ($row_get_secretaries = pg_fetch_assoc($result_get_secretaries)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_secretaries['nome'] . "</td>";
                            echo "<td>" . $row_get_secretaries['cognome'] . "</td>";
                            echo "<td>" . $row_get_secretaries['email'] . "</td>";
                            echo "<td>" . $row_get_secretaries['sede'] . "</td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='6'>Nessun appello disponibile al momento.</td></tr>";
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
