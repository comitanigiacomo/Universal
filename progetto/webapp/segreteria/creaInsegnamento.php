<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['nome'])) {

    $nome = $_POST['nome'];
    $descrizione = $_POST['descrizione'];
    $anno = $_POST['anno'];
    $docente_responsabile = $_POST['docente_responsabile'];
    $cdl = $_POST['codice_CdL'];
    $propedeutici = $_POST['propedeutici']; // Aggiunto per gestire le propedeuticità multiple
    $codice_ins = $_POST['codice_ins'];

    // Chiamata alla procedura per inserire l'insegnamento del corso
    $query_insert_teaching = "CALL universal.insert_teaching($1, $2, $3, $4, $5)";
    $result_insert_teaching = pg_query_params($conn, $query_insert_teaching, array($nome, $descrizione, $anno, $docente_responsabile, $cdl));

    // Controllo del risultato della query
    if (!$result_insert_teaching) {
        echo '<script type="text/javascript">alert("Errore durante la creazione dell\'insegnamento");</script>';
        exit;
    }

    echo '<script type="text/javascript">alert("Insegnamento creato con successo"); </script>';
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Crea Insegnamento Del CdL</title>
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
            <div class="titolo"><h1>Crea Insegnamento del CdL</h1></div>
            <form method="post" action="">
                <input type='hidden' name='codice_CdL' value='<?php echo $_POST['cdl']; ?>' />
                <div class="tabella">
                    <table>
                        <tr>
                            <th>Nome</th>
                            <th>Descrizione</th>
                            <th>Anno</th>
                            <th>Docente responsabile</th>
                            <th>Azioni</th>
                        </tr>
                        <tr>
                            <td>
                                <input type="text" name="nome" placeholder="Nome" required>
                            </td>
                            <td>
                                <input type="text" name="descrizione" placeholder="Descrizione" required>
                            </td>
                            <td>
                                <input type="integer" name="anno" placeholder="Anno" required>
                            </td>
                            <td>
                                <select name="docente_responsabile" required>
                                    <?php
                                    $query_get_all_teachers = "SELECT * FROM universal.get_all_teachers()";
                                    $result_get_all_teachers = pg_query($conn, $query_get_all_teachers);
                                    if ($result_get_all_teachers && pg_num_rows($result_get_all_teachers) > 0) {
                                        while ($row_get_all_teachers = pg_fetch_assoc($result_get_all_teachers)) {
                                            echo "<option value='" . $row_get_all_teachers['id'] . "'>" . $row_get_all_teachers['nome'] . " " . $row_get_all_teachers['cognome'] . "</option>";
                                        }
                                    }
                                    ?>
                                </select>
                            </td>
                            <td>
                                <button type="submit">Aggiungi Insegnamento</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </form>
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

