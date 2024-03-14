<!DOCTYPE html>
<html>

<head>
    <title>Autenticazione</title>
    <link href="" rel="stylesheet">
    <meta charset="utf-8">
</head>


<body >
    <header class="header" role="banner">
        <div class="logo-container container-fluid">
            <div>
                <a class="nav-link active" id="uni" aria-current="page" href="/">Uni<span id="euro">versal</span></a>
            </div>
        </div>
    </header>
    
    <div class="row">
        <div class="col-lg-4 col-md-4 col-sm-6 col-md-offset-4 col-sm-offset-3 col-lg-offset-4 colonna-centrale"
            role="main">
            <h1 class="content-block-title clearfix" id="main-content">
                Autenticazione</h1>
            <br>
                <form method="POST" action= /progetto/webapp/scripts/rightConnection.php>
                    <div class="form-group" >
                        Inserisci le tue credenziali per accedere ai servizi dell&#39;Università degli
                        Studi di universal. Tutti i campi sono obbligatori.
                        <input id="email"  class="form-control input-lg typeahead top-buffer-s" name="email" type="email" class="form-control bg-transparent rounded-0 my-4" placeholder="nome.cognome@tipo.universal.it" 
                            aria-label="Email" value="nome.cognome@studenti.universal.it" aria-describedby="basic-addon1">
                        <br>
                        <input id="password" class="form-control input-lg pass" name="password" type="password" class="form-control  bg-transparent rounded-0 my-4" 
                            placeholder="Password" aria-label="Username" aria-describedby="basic-addon1" value="password">
                        <br>
                        <button type="submit" class="btn btn-primary btn-lg btn-block">Accedi</button>
                    </div>
                </form>
        </div>
    </div>

    
    <footer id="footer" class="container footer text-center top-buffer-s" >
        <nav>
            <ul>
                <li>
                    <a href="#">Dichiarazione di accessibilità</a>
                </li>
                <li>
                    <a href="#">Privacy e cookie</a>
                </li>
            </ul>
        </nav>
        <p class="firma">Università degli studi di Informatica</p>
        <p>
            <a href="#">Assistenza Universal</a>
        </p>
    </footer>
</body>

</html>