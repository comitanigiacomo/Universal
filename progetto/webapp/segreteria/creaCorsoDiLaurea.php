<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['nome'])) {
    // Ottieni le password inserite nel form
    $nome = $_POST['nome'];
    $tipo = $_POST['tipo'];
    $descrizione = $_POST['descrizione'];

    // Chiamata alla procedura per inserire il corso di laurea
    $query_insert_degree_course = "CALL universal.insert_degree_course($1, $2, $3)";
    $result_insert_degree_course = pg_query_params($conn, $query_insert_degree_course, array($nome, $tipo, $descrizione));

    // Controllo del risultato della query
    if (!$result_insert_degree_course) {
        echo '<script type="text/javascript">alert("Errore durante la creazione del CdL");</script>';
        exit;
    }

    echo '<script type="text/javascript">alert("CdL creato con successo"); </script>';
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Crea Corso Di Universal</title>
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
            <div class="titolo"><h1>Crea Corso Di Universal</h1></div>
                    <form method="post" action="">
                        <div class="tabella">
                            <table>
                                <tr>
                                    <th>Nome</th>
                                    <th>Tipo</th>
                                    <th>Descrizione</th>
                                    <th>Azioni</th>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="text" name="nome" placeholder="Nome" required>
                                    </td>
                                    <td>
                                        <select name="tipo" required>
                                            <option value="3">Triennale</option>
                                            <option value="2">Magistrale</option>
                                            <option value="5">Ciclo Unico</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" name="descrizione" placeholder="Descrizione" required>
                                    </td>
                                    <td>
                                        <button type="submit" name="submit" value="crea_corso">Crea Corso</button>
                                    </td>
                                </tr>
                            </table>
                        </div>
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
