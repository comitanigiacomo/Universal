<?php
    // Apre la connessione giusta in base al tipo di utente
    if (session_id() == '' || !isset($_SESSION)) {
        session_start();
    }

    $conn = pg_connect("host=localhost port=5432 dbname=universal user=giacomo password=giacomo");

    function Get_type($email) {
        $parts = explode('@', $email);
        $domain_part = $parts[1];
        $domain_parts = explode('.', $domain_part);
        $type = $domain_parts[0];
  
        if ($type == 'studenti' || $type == 'docenti' || $type == 'segretari' || $type == 'exstudenti') {
            return $type;
        } else {
            print("Tipo non riconosciuto");
        }
    }

    if(isset($_POST["email"]) && isset($_POST["password"])) {
        $email = $_POST["email"];
        $password = $_POST["password"];
        $_SESSION['email'] = $email;
        
        // Esegui la query per controllare le credenziali dell'utente
        $result = pg_query_params($conn, 'SELECT * FROM universal.utenti WHERE email = $1 AND password = crypt($2, password)', array($email, $password));

        // Verifica se la query ha restituito una riga
        if (pg_num_rows($result) == 1) {
            $query_get_id = "SELECT * FROM universal.get_id($1)";
            $result_get_id = pg_query_params($conn, $query_get_id, array($_SESSION['email']));
            $row_get_id = pg_fetch_assoc($result_get_id);
            $_SESSION['id'] = $row_get_id['id'];
            // L'utente è autorizzato, reindirizzalo alla pagina corretta
            $type = Get_type($email);
            switch ($type){
                case "studenti":
                    header("Location: /progetto/webapp/studente/index.php");
                    exit();
                case "exstudenti":
                    header("Location: /progetto/webapp/ex_studente/index.php");
                    exit();
                case "docenti":
                    header("Location: /progetto/webapp/docente/index.php");
                    exit();
                case "segreteria":
                    header("Location: /progetto/webapp/segreteria/index.php");
                    exit();
            }
        } else {
            // Le credenziali sono errate, mostra un messaggio di errore utilizzando JavaScript e reinderizza alla pagina di login
            echo '<script type="text/javascript">alert("Error: Credenziali errate!");</script>';
        }
    }
?>



<!DOCTYPE html>
<html>
<head>
    <title>Autenticazione</title>
    <link rel="stylesheet" type="text/css" href="login.css">
    <meta charset="utf-8">
</head>
<body>

    <header class="header" role="banner"></header>
    <div class="contenitore">
        <div class="rettangolo-centrale">
            <div class="logo">
                <a class="nav-link" id="uni" aria-current="page" href="/login.php">Universal</a>
                <br><br>
            </div>
            <form method="POST" action="">
                <div class="form-group">
                    <div class="informazioni">Inserisci le tue credenziali per accedere ai servizi dell'Università degli Studi di universal. Tutti i campi sono obbligatori.</div>
                    <input id="email" class="form-control input-lg typeahead top-buffer-s" name="email" type="email" class="form-control bg-transparent rounded-0 my-4" placeholder="nome.cognome@studenti.universal.it" aria-label="Email" value="" aria-describedby="basic-addon1">
                    <br>
                    <input id="password" class="form-control input-lg pass" name="password" type="password" class="form-control  bg-transparent rounded-0 my-4" placeholder="Password" aria-label="Username" aria-describedby="basic-addon1" value="">
                    <br>
                    <button type="submit" class="btn btn-primary btn-lg btn-block">Accedi</button>
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
            <a href="https://letmegooglethat.com/?q=cerca+qui+i+tuoi+problemi%2C+grazie">Assistenza Universal</a>
            <br>
        </div>
    </footer>
    <script>
        var possibleEmails = [
            "nome.cognome@docenti.universal.it",
            "nome.cognome@segretari.universal.it",
            "nome.cognome@studenti.universal.it"
        ];

        // Funzione per aggiornare il valore predefinito dell'input
        function updateDefaultEmail() {
            var emailInput = document.getElementById("email");
            var index = 0;

            function updateEmail() {
                emailInput.placeholder = possibleEmails[index];
                index = (index + 1) % possibleEmails.length;
            }

            setInterval(updateEmail, 2000);
        }

        updateDefaultEmail();
    </script>
</body>
</html>
