<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

$id_insegnamento =$_POST['codice_CdL'];

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
                        <th>Azioni</th>
                    </tr>
                    <?php
                    // Esegui la query per ottenere gli insegnamenti del corso specificato
                    if($id_insegnamento !== null) {
                        $query_get_teaching_of_cdl = "SELECT * FROM universal.get_teaching_of_cdl($1)";
                        $result_get_teaching_of_cdl = pg_query_params($conn, $query_get_teaching_of_cdl, array($id_insegnamento));

                        // Verifica se ci sono risultati
                        if ($result_get_teaching_of_cdl && pg_num_rows($result_get_teaching_of_cdl) > 0) {
                            // Itera sui risultati e stampa le righe della tabella
                            while ($row_get_teaching_of_cdl = pg_fetch_assoc($result_get_teaching_of_cdl)) {
                                echo "<tr>";
                                echo "<td>" . $row_get_teaching_of_cdl['nome'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl['descrizione'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl['anno'] . "</td>";
                                echo "<td>" . $row_get_teaching_of_cdl['responsabile'] . "</td>";
                                echo "<td>
                                <form method='post' action='./visualizzaAppelli.php'>
                                    <input type='hidden' name='codice' value='" . $row_get_teaching_of_cdl['codice'] . "' />
                                    <input type='hidden' name='responsabile' value='" .$row_get_teaching_of_cdl['responsabile'] . "' />
                                    <button type='submit'>Visualizza Appelli</button>
                                </form>
                                <form method='post' action='./modificaResponsabileCorso.php'>
                                    <input type='hidden' name='codice_insegnamento' value='" . $row_get_teaching_of_cdl['codice'] . "' />
                                    <button type='submit'>Modifica Responsabile Del Corso</button>
                                </form>
                                </td>";
                                echo "</tr>";
                            }
                        } else {
                            echo "<tr><td colspan='5'>Nessun insegnamento disponibile per questo corso.</td></tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>ID insegnamento non valido.</td></tr>";
                    }
                    ?>
                </table>
            </div>

            <div class="crea-corso">
                <form method="post" action="./creaInsegnamento.php">
                    <input type='hidden' name='cdl' value='<?php echo $_POST['codice_CdL2']; ?>' />
                    <button type="submit">Crea Nuovo Insegnamento Del CdL</button>
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
