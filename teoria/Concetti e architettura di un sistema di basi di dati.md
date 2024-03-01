<span style="color:orange">Base di dati</span>: fornisce un livello di astrazione ai dati, nascondendo nascondendo dettagli su  essi che non interessano agli utenti

<span style="color:orange">Astrazione dei dati</span>: eliminazione dei dettagli come organizzazione e memorizzazione degli stessi, per mettere in risalto le caratteristiche essenziali e facilitarne la comprensione

<span style="color:orange">Struttura di una base di dati</span>: tipi di dati, relazioni, vincoli che valgono su di essi

Esistono molti modelli di dati, tra i quali: 

- <span style="color:orange">Modelli dei dati di alto livello/concettuali</span>: forniscono concetti vicino agli utenti
- <span style="color:orange">Modelli dei dati implementabili</span>: Forniscono concetti comprensibili agli utenti finali, ma non troppo lontani dal modo in cui sono organizzati sul calcolatore
- <span style="color:orange">Modelli dei dati a basso livello/fisici</span>: forniscono concetti che descrivono i dettagli sul modo in cui i dati sono organizzati sul calcolatore

Nei modelli dei dati concettuali sono utilizzati i seguenti concetti: 

- <span style="color:orange">Entità</span>: oggetto del mondo reale che viene descritto nella base di dati (persona)
- <span style="color:orange">Attributo</span>: una proprietà di un entità (nome)
- <span style="color:orange">Relazione</span>: legame tra le entità

I modelli dei dati implementabili, i più utilizzati nel DBMS, includono il <span style="color:orange">Modello dei dati relazionale</span>  e il <span style="color:orange">Modello gerarchico</span> 

Quale che sia il modello di dati considerato, bisogna distinguere i seguenti concetti: 

- <span style="color:orange">Schema del database</span>: è la descrizione, specificata durante la progettazione, ci si aspetta non cambi 
- <span style="color:orange">Base di dati</span>: vera collezione dei dati 

I dati all'interno del database possono invece cambiare frequentemente, viene definito dunque <span style="color:orange">Stato della base di dati</span> i dati al suo interno ad un certo istante di tempo 

# Architettura a tre livelli 

---

È un architettura per sistemi di basi di dati che ha l'obiettivo di <span style="color:orange">separare le applicazioni utente dalla base di dati fisica</span>. In essa sono definiti tre livelli: 

- <span style="color:orange">Livello interno</span>: ha uno schema interno che descrive la struttura di memorizzazione fisica della base di dati, nel dettaglio 
- <span style="color:orange">Livello concettuale</span>: ha uno schema concettuale, che descrive la struttura della base per una comunità di utenti descrivendo entità, tipi, relazioni, vincoli.
- <span style="color:orange">Livello esterno/di vista</span>: comprende un certo numero di schemi interni, ciascuno dei quali descrive la parte della base di dati a cui è interessato un gruppo di utenti

L'architettura è importante poichè definisce una separazione tra il livello esterno dell'utente, il livello concettuale del sistema e il livello interno di archiviazione

I tre schemi sono solamente <span style="color:orange">descrizione dei dati</span>, essi infatti sono realmente contenuti solo a livello fisico 

In un DBMS basato su questa architettura a tre livelli ogni utente fa riferimento solamente al proprio schema esterno: per questo il DBMS deve trasformare una richiesta specificata su uno schema esterno  in una verso lo schema concettuale, poi verso lo schema interno. 

Di conseguenza i dati devono poi essere riformattati per accordarsi con la vista esterna dell'utente. 

Questi processi di trasformazione tra livelli vengono detti <span style="color:orange">Mapping</span>. Poiché dispendiosi, alcuni database non supportano viste esterne 

![[Pasted image 20240229114431.png]]

# Indipendenza dei dati 

---

L' <span style="color:orange">Indipendenza dei dati</span> può essere definita come la capacità di cambiare uno schema ad un certo livello della base di dati, senza dover cambiare lo schema al livello immediatamente superiore 

Se ne possono definire due tipi: 

- <span style="color:orange">Indipendenza logica dei dati</span>: capacità di cambiare lo schema concettuale senza dover cambiare gli schemi esterni
- <span style="color:orange">Indipendenza fisica dei dati</span>: capacità di cambiare lo schema interno senza dover cambiare lo schema concettuale. 

Nella maggior parte delle basi di dati si verifica <span style="color:orange">l'indipendenza fisica dei dati</span>. I dettagli del posizionamento su disco del file o dettagli hw circa la memorizzazione vengono nascosti all'utente, le applicazioni possono ignorare. L'indipendenza logica è invece difficile: incidere sui vincoli, sulle relazioni, sulla struttura dei dati senza incidere sulle applicazioni è complicato. 

In un DBMS a più livelli, il suo <span style="color:orange">catalogo viene ampliato per aggiungere informazioni su come mappare le richieste tra i vari livelli</span>. Questo perchè grazie all'indipendenza dei dati, quando lo schema cambia ad un certo livello, basta andare a modificare il mapping delle richieste che vanno da quel livello a quello immediatamente superiore, e ho fatto. Lo schema superiore è rimasto intatto, quindi i programmi applicativi che fanno riferimento allo schema superiore non hanno bisogno di subire modifiche 

# Linguaggi dei DBMS

---

Nei DBMS in cui non c'è una separazione netta tra i livelli, per definire lo schema concettuale e quello interno  viene utilizzato un solo linguaggio chiamato <span style="color:orange">DDL</span>: ( _data definition language_)

Nei DBMS in cui invece si ha una separazione netta tra livelli, il DDL è usato per specificare lo schema concettuale. Per specificare lo schema interno viene utilizzato il <span style="color:orange">SDL</span> (_storage definition language_). Per specificare il mapping tra questi livelli posso usare uno dei due linguaggi 

Per un architettura a tre livelli si avrà bisogno quindi del linguaggio di definizione delle viste <span style="color:orange">VDL</span> (_view definition language_), per specificare viste utente e mapping nello schema concettuale. Nonostante questo nella maggior parte dei casi viene usato il DDL per descrivere sia lo schema concettuale che quello esterno 

Infine, una volta definiti gli schemi, gli utenti hanno bisogno di un linguaggio per manipolare la base di dati, il <span style="color:orange">DML</span> (_data manipulation language_). 


# Ambiente di un sistema di base di dati 
---

![[Pasted image 20240229120953.png]]

Possiamo dividere i componenti di un DBMS in due: 

- Parte superiore: tipologie di utente di un sistema di basi di dati e rispettive interfacce 
- Parte inferiore: componenti interni di un DBMS responsabili  di memorizzare i dati e eseguire le transazioni 

<span style="color:orange">La base di dati e il catalogo sono memorizzati su disco</span> , il cui accesso è controllato dal sistema operativo. 

 Il catalogo include informazioni come i nomi e le dimensioni dei file, i nomi e i tipi di dato delle voci, i dettagli di memorizzazione di ciascun file, informazioni sul mapping tra i vari schemi e vincoli, oltre a molti altri tipi di informazioni necessari ai moduli del DBMS

# Programmi di utilità di un sistema di basi di dati 

---

La maggior parte dei DBMS dispone di <span style="color:orange">
programmi di utilità per basi di dati</span> che aiutano il DBA a gestire il sistema di basi di dati.

Questi programmi svolgono le seguenti attività : 

- <span style="color:orange">Caricamento</span>: caricare file di dati già esistenti, nella base di dati 
- <span style="color:orange">Backup</span>: crea un backup dell'intera base riversando le informazioni su nastro 
- <span style="color:orange">Monitoraggio delle prestazioni</span>: Controlla sistematicamente la base di dati fornendo statistiche al DBA
- <span style="color:orange">Riorganizzazione dello spazio di archiviazione della base di dati</span>: cambio l'organizzazione dei file 