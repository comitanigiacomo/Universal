# Gestione profili utente
---

- Segreteria: aggiorna, registra e rimuove studenti e docenti
- Docente: responsabile di al massimo 3 insegnamenti
- Studente: ha una matricola e un insieme di esami da superare

# Gestione corsi di laurea e insegnamenti
---
Governo corso di laurea e insegnamenti, ognuno dei quali ha all'interno del corso di laurea: 
- codice univoco
- nome
- descrizione testuale
- anno in cui è previsto
- docente responsabile

La segreteria puo definire uno o piu corsi di laurea triennali e magistrali  ( insiemi di insegnamenti da superare )

ogni studente è iscritto ad un corso di laurea, e questo assegnamento è gestito dalla segreteria 

Ogni corso puo avere propedeuticita

# Gestione dei calendari degli esami 
---

i docenti possono definire/modificare il calendario degli esami di cui sono responsabili


# Gestione degli esami, istruzione e valutazione
---

Gli studentti possono iscriversi alle prove d'esame per gli insegnamenti previsti dal proprio corso 

Il docente responsabile di un corso puo registrare un voto , sufficiente o insufficiente

esame superato se voto > 18

lo studente puo iscriversi all'esame che ha gia superato e conto il maggiore 

# requisiti della base
---

# Mantenimento delle informazioni e delle carriere di studenti rimossi.
La rimozione di uno studente (ad esempio, in caso di laurea, o di rinuncia agli studi) deve
spostare le informazioni dello studente stesso, e tutta la sua carriera esami, in apposite
tabelle di storico studenti e storico carriera.

# Correttezza delle iscrizioni agli esami.
Ciascuno studente può iscriversi ad un esame
solo se l’insegnamento è previsto dal proprio corso di laurea, e solamente se tutte le pro-
pedeuticità sono rispettate (i.e., solamente se lo stesso studente ha superato gli esami di
tutti gli insegnamenti propedeutici).

# Correttezza del calendario d’esame. 
Non è possibile programmare, nella stessa giornata, appelli per più esami dello stesso anno di un corso di laurea.

# Produzione della carriera completa di uno studente. 
Ciascuno studente può produrre la propria carriera completa (contenente voti e date di tutti gli esami che lo studente
2abbia mai sostenuto, inclusi esami ripetuti ed esami non superati). La segreteria può
produrre la carriera completa di ciascuno studente (presente o rimosso).

# Produzione della carriera valida di uno studente. 
Ciascuno studente può produrre la propria carriera valida (contenente voti e date più recenti di tutti gli esami che lo studente
ha superato (voto ≥ 18). La segreteria può produrre la carriera valida di ciascuno studente
(presente o rimosso).

# Produzione delle informazioni su un corso di laurea. 
Ciascuno studente può produrre le informazioni complete per qualunque corso di laurea, contenenti almeno l’elenco
di tutti i corsi, con le rispettive descrizioni, ed il docente responsabile.

# requisiti web
---
L’applicazione Web deve gestire l’accesso della segreteria, dei docenti, e degli studenti. Si real-
izzino, oltre a quelle richieste dai requisiti illustrati in precedenza, le seguenti funzionalità:
• Segreteria: accede all’applicazione tramite login e password (e può modificare la propria
password); crea e gestisce le utenze per docenti e studenti; inserisce e gestisce corsi di
laurea ed insegnamenti, inserisce e gestisce docenti e studenti.
• Docente: accede all’applicazione tramite login e password (e può modificare la propria
password), crea e gestisce il calendario degli esami dei propri insegnamenti, registra gli
esiti degli esami degli studenti.
• Studente: accede all’applicazione tramite login e password (e può modificare la propria
password), si iscrive agli esami.
