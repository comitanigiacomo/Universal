<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}


?>

<!DOCTYPE html>
<html>
<head>
    <title>Carriera</title>
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
        <div class="titolo"><h1>Carriera</h1></div>
        <div class="tabella">
            <table>
                <tr>
                    <th>Nome</th>
                    <th>Descrizione</th>
                    <th>Anno</th>
                    <th>Data</th>
                    <th>Docente Responsabile</th>
                    <th>Corso Di Laurea</th>
                    <th>Voto</th>
                </tr>
                <?php
                // Esegui la query per ottenere gli appelli degli esami a cui lo studente è attualmente iscritto
                $query_get_partial_carrer = "SELECT * FROM universal.get_partial_carrer($1)";
                $result_get_partial_carrer = pg_query_params($conn, $query_get_partial_carrer, array($_SESSION['id']));

                // Itera sui risultati e stampa le righe della tabella
                while ($row_get_partial_carrer = pg_fetch_assoc($result_get_partial_carrer)) {
                    echo "<tr>";
                    echo "<td>" . $row_get_partial_carrer['nome'] . "</td>";
                    echo "<td>" . $row_get_partial_carrer['descrizione'] . "</td>";
                    echo "<td>" . $row_get_partial_carrer['anno'] . "</td>";
                    echo "<td>" . $row_get_partial_carrer['data'] . "</td>";
                    echo "<td>" . $row_get_partial_carrer['docente_responsabile'] . "</td>";
                    echo "<td>" . $row_get_partial_carrer['corso_di_laurea'] . "</td>";
                    echo "<td>" . $row_get_partial_carrer['voto'] . "</td>";
                    echo "</tr>";
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
            <a href="https://letmegooglethat.com/?q=cerca+qui+i+tuoi+problemi%2C+grazie">Assistenza Universal</a>
            <br>
        </div>
    </footer>

    

</body>
</html>
