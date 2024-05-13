# Manuale Utente

Per lanciare `Universal` è necessario avere sul proprio dispositivo: 

- PostgreSQL
- PHP
- Un web server

Inizialmente il database sarà popolato con i seguenti utenti: 

| Nome   | Cognome | Email      | Password |
|--------|---------|------------|----------|
|giacomo | comitani|giacomo.comitani@segretari.universal.it|passwor!|
|michele | bolis|michele.bolis@docenti.universal.it|passwor!|
|luca | favini|luca.favini@studenti.universal.it|passwor!|
|luca | corradini|luca.corradini@studenti.universal.it|passwor!|
|mattia | delledonne|mattia.delledonne@studenti.universal.it|passwor!|
|daniele | deluca|daniele.deluca@docenti.universal.it|passwor!|
|alice | guizzardi|alice.guizzardi@docenti.universal.it|passwor!|
|sara | quartieri|sara.quartieri@docenti.universal.it|passwor!|
|axel | toscano|axel .toscano@studenti.universal.it|passwor!|
|riccardo | totaro|riccardo.totaro@studenti.universal.it|passwor!|
|marica | muolo|marica.muolo@studenti.universal.it|passwor!|
|ludovica | porro|ludovica.porro@studenti.universal.it|passwor!|
|alessandro | dino|alessandro.dino@studenti.universal.it|passwor!|
|alice | annoni|alice.annoni@studenti.universal.it|passwor!|
|simone | monesi|simone.monesi@studenti.universal.it|passwor!|
|davide | dellefave|davide.dellefave@studenti.universal.it|passwor!|
|christian | morelli |christian.morelli@studenti.universal.it|passwor!|
|denise | caria|denise.caria@studenti.universal.it|passwor!|
|silvia | colombo|silvia.colombo@studenti.universal.it|passwor!|
|sofia | comitani|sofia.comitani@studenti.universal.it|passwor!|
|raoul | torri|raoul.torri@exstudenti.universal.it|passwor!|
|andrea | galliano|andrea.galliano@exstudenti.universal.it|passwor!|

È possibile quindi accedere al sistema mediante uno di questi qualsiasi utenti.

Per creare e popolare il database è necessario utilizzare lo script 'DatabaseUni.sql' presente nella cartella 'database'
presente all'interno del repo. In alternativa si può utilizzare lo scipt 'databaseUni_emptyDump.sql' in caso si vogliano inserire
a paritire da zero, gli utenti, corsi di laurea e in generale le altre informazioni del database (escludendo un utente di default di segreteria, sempre presente in ogni caso).
