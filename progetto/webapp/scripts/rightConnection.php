<?php

// Apre la connessione giusta in base al tipo di utente

// TO DO: splitto la mail inserita per dedurne il tipo di utente, e da li implemento il riderect.

// le possibili mail sono: 

// nome.cognome@studenti.universal.it
// nome.cognome@docenti.universal.it
// nome.cognome@segreteria.universal.it

// Da decidere: creo la mail dinamicamente a partire dal tipo, o inserisco la mail e ricavo il tipo?

// opzione carina:? ricavo la mail dinamicamente dal tipo e la prima volta appare un pop-up per 5 secondi dove la faccio visualizzare e dico di salvarla, o che la ho slavata in un file 

// La mail per gli studenti e per gli ex studenti cambia? se la mail non cambia e non ho l'attributo tipo in utente, come la differenzio?

    if (session_id() == '' || !isset($_SESSION)) {
        session_start();
    }

    pg_connect("host=localhost port=5432 dbname=unimia user=postgres password=pangolino");

    function Redirect($url, $permanent = false) {
        header("Location: $url", true, $permanent ? 301 : 302);
        exit();
    }

    function Get_type($email) {
  
      $parts = explode('@', $email);
      $domain_part = $parts[1];
      $domain_parts = explode('.', $domain_part);
      $type = $domain_parts[0];
  
      if ($type == 'studenti' || $type == 'docenti' || $type == 'segreteria' || $type == 'exstudenti') {
          return $type;
      } else {
          print("Tipo non riconosciuto");
      }
    }

    if(isset($_POST["email"])) {
        $email = $_POST["email"];
        $type = Get_type($email);
        switch ($type){
          case "studenti":
            Redirect("../studente/index.php");
          case "exstudenti":
            Redirect("../ex_studente/index.php");
          case "docenti":
            Redirect("../docente/index.php");
          case "segreteria":
            Redirect("../segreteria/index.php");
          }
    }



   

?>



