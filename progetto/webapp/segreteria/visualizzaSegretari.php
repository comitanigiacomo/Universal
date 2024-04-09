<?php
include '../scripts/db_connection.php';
session_start();

// Controlla se l'utente è loggato, altrimenti reindirizza alla pagina di login
if (!isset($_SESSION['email'])) {
    header("Location: /login.php");
    exit();
}

if (isset($_POST["id_segretario"]) && $_SERVER["REQUEST_METHOD"] == "POST" ) {
    $id_segretario = $_POST['id_segretario'];
    $nuova_sede = $_POST['nuova_sede'];

    
    $query_change_secretary_office = "CALL universal.change_secretary_office($1, $2)";
    $result_change_secretary_office = pg_query_params($conn, $query_change_secretary_office, array($id_segretario, $nuova_sede));

    if ($result_change_secretary_office) {
        echo '<script type="text/javascript">alert("Sede cambiata correttamente"); </script>';
    } else {
        echo '<script type="text/javascript">alert("Errore durante Il cambio sede")</script>';
    }

} else if (isset($_POST["id_segretario2"]) && $_SERVER["REQUEST_METHOD"] == "POST") {
    $id_segretario2 = $_POST['id_segretario2'];
    print_r($_id_segretario2);

    
    $query_delete_secretary = "CALL universal.delete_secretary($1)";
    $result_delete_secretary = pg_query_params($conn, $query_delete_secretary, array($id_segretario2));

    if ($result_delete_secretary) {
        echo '<script type="text/javascript">alert("Segretario eliminato correttamente"); </script>';
    } else {
        echo '<script type="text/javascript">alert("Errore durante l\'eliminazione")</script>';
    }

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
                        <th>Azioni</th>
                    </tr>
                    <?php
                    $query_get_secretaries = "SELECT * FROM universal.get_secretaries()";
                    $result_get_secretaries = pg_query($conn, $query_get_secretaries);

                    if ($result_get_secretaries && pg_num_rows($result_get_secretaries) > 0) {
                        while ($row_get_secretaries = pg_fetch_assoc($result_get_secretaries)) {
                            echo "<tr>";
                            echo "<td>" . $row_get_secretaries['nome'] . "</td>";
                            echo "<td>" . $row_get_secretaries['cognome'] . "</td>";
                            echo "<td>" . $row_get_secretaries['email'] . "</td>";
                            echo "<td>" . $row_get_secretaries['sede'] . "</td>";
                            echo "<td>
                                <form method='post' action=''>
                                    <input type='hidden' name='id_segretario' value='" . $row_get_secretaries['id']   . "' />
                                    <input type='text' name='nuova_sede' placeholder='Inserisci la nuova sede' required />
                                    <button type='submit'>Cambia Sede</button>
                                </form>
                                <form method='post' action=''>
                                    <input type='hidden' name='id_segretario2' value='" . $row_get_secretaries['id']   . "' />
                                    <button type='submit'>Elimina Segretario</button>
                                </form>
                                <form method='post' action='modificaPasswordUtente.php'>
                                <input type='hidden' name='id_utente' value='" . $row_get_secretaries['id']   . "' />
                                <button type='submit'>Modifica Password</button>
                            </form>
                            </td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='6'>Nessun segretario disponibile al momento.</td></tr>";
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
