# Manuale Utente

Per lanciare `Universal` è necessario avere sul proprio dispositivo: 

- PostgreSQL
- PHP
- Un web server

Per creare e popolare il database è necessario utilizzare lo script `dump.sql` presente nella cartella `database` presente all'interno del repo. In alternativa si può utilizzare lo script `cleanDump.sql` in caso si vogliano inserire a paritire da zero, gli utenti, corsi di laurea e in generale le altre informazioni del database (escludendo un utente di default di segreteria, sempre presente in ogni caso).

In ogni caso sarà sempre presente un utente segretario avente le seguenti credenziali: 

- `email` : giacomo.comitani@segretari.universal.it
- `password` : passwor! (comune a tutti gli utenti)
