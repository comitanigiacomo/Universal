<!DOCTYPE html>
<html>

<head>
    <title>Autenticazione</title>
    <link rel="stylesheet" type="text/css" href="login.css">
    <meta charset="utf-8">
</head>


<body >
    <header class="header" role="banner">
    </header>

    <div class = "contenitore">
        <div class = "rettangolo-centrale">
        <div class = "logo">
            <a class="nav-link" id="uni" aria-current="page" href="/login.php">Universal</a>
        </div>
            <form method="POST" action= /progetto/webapp/scripts/rightConnection.php>
                        <div class="form-group" >
                            Inserisci le tue credenziali per accedere ai servizi dell&#39;Università degli
                            Studi di universal. Tutti i campi sono obbligatori.
                            <br>
                            <br>
                            <br>
                            <input id="email"  class="form-control input-lg typeahead top-buffer-s" name="email" type="email" class="form-control bg-transparent rounded-0 my-4" placeholder = "nome.cognome@studenti.universal.it" 
                                aria-label="Email" value="" aria-describedby="basic-addon1">
                            <br>
                            <input id="password" class="form-control input-lg pass" name="password" type="password" class="form-control  bg-transparent rounded-0 my-4" 
                                placeholder="Password" aria-label="Username" aria-describedby="basic-addon1" value="">
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