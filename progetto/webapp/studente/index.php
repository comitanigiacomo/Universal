<!DOCTYPE html>
<html>
<head>
    <title>Area Personale</title>
    <link rel="stylesheet" type="text/css" href="/progetto/webapp/studente/studente.css">
    <meta charset="utf-8">
</head>
<body>
    <div class='sfondo'>
        <div class="contenitore">
        <div class="benvenuto">
            <h2>Studenti Universal</h2>
        </div>
        <div class="spiegazione">
            <p>Qui puoi visualizzare il tuo programma di studi, iscriverti agli esami e consultare i risultati.</p>
        </div>
        <div class="informazioni">
            <?php include 'studente.php'; ?>
            <div>
                <label for="nome">Nome:</label>
                <span id="nome"><?php echo $nome; ?></span>
            </div>
            <div>
                <label for="cognome">Cognome:</label>
                <span id="cognome"><?php echo $cognome; ?></span>
            </div>
            <div>
                <label for="matricola">Matricola:</label>
                <span id="matricola"><?php echo $matricola; ?></span>
            </div>
            <div>
                <label for="corso_di_laurea">Corso di Laurea:</label>
                <span id="corso_di_laurea"><?php echo $corso_di_laurea; ?></span>
            </div>
            <div>
                <label for="media">Media:</label>
                <span id="media"><?php echo $media; ?></span>
            </div>
        </div>
        <div class="funzioni">

            <button onclick="window.location.href='./modificaPassword.php'">Modifica Password</button>
            <button onclick="window.location.href='/carriera.php'">Visualizza Tutti Gli Appelli Del Tuo Corso</button>
            <button onclick="window.location.href='/carriera.php'">Visualizza Tutti Gli Appelli</button>
            <button onclick="window.location.href='/carriera.php'">Visualizza Tutti I Corsi Di Laurea</button>
            <button onclick="window.location.href='/carriera.php'">Visualizza Gli Esami Mancanti Alla Laurea</button>

        </div>

        <div class="iscrizioni">

        <button onclick="window.location.href='./iscrizioni.php'">Visualizza Iscrizioni</button>
        </div>
        <div class="carriera">
            <button onclick="window.location.href='/carriera.php'">Visualizza Carriera</button>
            <button onclick="window.location.href='/carriera_completa.php'">Visualizza Carriera Completa</button>
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
