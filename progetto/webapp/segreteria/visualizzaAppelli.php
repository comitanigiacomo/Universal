<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: ../login.php");
    exit();
}


$codice_insegnamento = $_POST['codice'];

$nome = "";
$corso_di_laurea = ""; 

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["crea_appello"])) {
    $data = $_POST['data'];
    $luogo = $_POST['luogo'];
    $codice_insegnamento = $_POST['codice_insegnamento'];
    $responsabile = $_POST['responsabile'];

    $query_create_exam_session = "CALL universal.create_exam_session($1, $2, $3, $4)";
    $result_create_exam_session = pg_query_params($conn, $query_create_exam_session, array($responsabile, $data, $luogo, $codice_insegnamento));

    if ($result_create_exam_session) {
        echo '<script>alert("Nuovo appello creato con successo!"); window.location = "./index.php"</script>';
    } else {
         echo '<script>alert("Errore nella creazione dell\'appello!"); window.location = "./index.php"</script>';
    }
}

$query_get_exam_sessions = "SELECT * FROM universal.get_exam_sessions($1)";
$result_get_exam_sessions = pg_query_params($conn, $query_get_exam_sessions, array($codice_insegnamento));

?>

<!DOCTYPE html>
<html>
<head>
    <title>Appelli Dell'insegnamento</title>
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
            <div class="home">
                    <a class="nav-link" id="home" aria-current="page" href="./index.php">Home</a>
            </div>
            <div class="titolo"><h1>Appelli Dell'insegnamento</h1></div>
            <div class="tabella">
                <table>
                    <tr>
                        <th>Data</th>
                        <th>Luogo</th>
                        <th>Nome</th>
                        <th>Corso di laurea</th>
                        <th>Azioni</th>
                    </tr>
                    <?php
                    if ($result_get_exam_sessions && pg_num_rows($result_get_exam_sessions) > 0) {
                        while ($row_get_exam_sessions = pg_fetch_assoc($result_get_exam_sessions)) {
                            $nome = $row_get_exam_sessions['nome'];
                            $corso_di_laurea = $row_get_exam_sessions['corso_di_laurea'];

                            echo "<tr>";
                            echo "<td>" . $row_get_exam_sessions['data'] . "</td>";
                            echo "<td>" . $row_get_exam_sessions['luogo'] . "</td>";
                            echo "<td>" . $nome . "</td>";
                            echo "<td>" . $corso_di_laurea . "</td>";
                            echo "<td>
                                <form method='post' action='./visualizzaIscritti.php'>
                                    <input type='hidden' name='codice_appello' value='" . $row_get_exam_sessions['codice_appello'] . "' />
                                    <input type='hidden' name='codice_cdl' value='" . $row_get_exam_sessions['corso_di_laurea'] . "' />
                                    <input type='hidden' name='id_docente' value='" . $row_get_exam_sessions['id_docente'] . "' />
                                    <button type='submit'>Visualizza Iscritti</button>
                                </form>
                            </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='5'>Nessun appello disponibile al momento.</td></tr>";
                    }
                    ?>

                </table>
                <table>

                    <tr>
                        <form method="post" action="">
                            <td><input type="date" name="data" required></td>
                            <td><input type="text" name="luogo" placeholder="Luogo" required></td>
                            <input type='hidden' name='codice_insegnamento' value= <?php echo $codice_insegnamento?>>
                            <td><?php echo $nome; ?></td>
                            <td><button type="submit" name="crea_appello">Crea Nuovo Appello</button></td>
                        </form>
                    </tr>
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
            <a href="https://google.com">Assistenza Universal</a>
            <br>
        </div>
    </footer>
</body>
</html>
