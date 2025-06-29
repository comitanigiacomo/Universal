# **Universal**

## **Progetto per il corso di `Basi di Dati`**
Anno scolastico 2023/2024.

Il progetto `Universal` è un'applicazione destinata alla gestione degli esami universitari. Fornisce funzionalità per studenti, docenti e la segreteria, con un'interfaccia intuitiva e funzionale per la gestione e consultazione delle informazioni relative agli esami.

## **Documentazione**

- **[Documentazione Tecnica](progetto/docs/documentazione_tecnica.md)**

## **Database**

Il database per il progetto si trova nella cartella `progetto/database` e include i seguenti file:

- **[Dump del Database](progetto/database/dump.sql)**: Contiene la struttura e i dati del database.
- **[Tabelle](progetto/database/tables.sql)**: Script per la creazione delle tabelle del database.
- **[Funzioni](progetto/database/function.sql)**: Script per la definizione delle funzioni nel database.
- **[Procedure](progetto/database/procedure.sql)**: Script per la creazione delle procedure.
- **[Trigger](progetto/database/trigger.sql)**: Script per la configurazione dei trigger.

## **Web App**

Le varie interfacce della Web App sono suddivise nelle seguenti sezioni:

- **[Ex Studente](progetto/webapp/ex_studente/)**
- **[Studente](progetto/webapp/studente/)**
- **[Docente](progetto/webapp/docente/)**
- **[Segreteria](progetto/webapp/segreteria/)**

## **Manuale Utente**

### **Requisiti per l'esecuzione di Universal**

Per eseguire l'applicazione `Universal`, è necessario avere installato sul proprio dispositivo:

- **PostgreSQL** (Versione 15.x)
- **PHP** (Versione 7.x o superiore, con un server web come Apache o Nginx)
- **Docker** (opzionale, ma consigliato per l'installazione semplificata del database)

### **Avvio del Database con Docker**

Per avviare il progetto in modo rapido e sicuro, è possibile utilizzare **Docker** per gestire l'ambiente del database PostgreSQL. Questa soluzione garantisce che l'applicazione venga eseguita con la versione corretta di PostgreSQL e che tutte le configurazioni siano predefinite. Non è necessario installare PostgreSQL manualmente sul sistema.

1. **Clona questo repository**:

   ```bash
   git clone https://github.com/comitanigiacomo/Universal.git
   cd universal
   ```

2. **Assicurati di avere Docker e Docker Compose installati**. Se non hai già Docker, puoi seguire le istruzioni ufficiali di Docker per il tuo sistema operativo:

    - [Guida all'installazione di Docker](https://docs.docker.com/get-started/get-docker/)

3. **Avvia il database PostgreSQL utilizzando Docker**. Nella root del progetto, esegui il comando:

```bash
docker-compose up -d
```
Questo comando avvierà i seguenti servizi:

- **PostgreSQL**: il database sarà accessibile sulla porta `5432` della tua macchina locale.

- Le variabili di ambiente configurano l'utente `giacomo` con i seguenti parametri:

    - Utente: `giacomo`

    - Password: `giacomo`

    - Database: `universal`

Il database sarà configurato automaticamente e pronto per essere utilizzato.

### **Popolamento del Database**

Una volta avviato il container con Docker (`docker-compose up -d`), è necessario **popolare manualmente il database** eseguendo i due script SQL in questo ordine:

1. **importa la struttura del database** (tabelle, funzioni, procedure, trigger):

```bash
docker cp database/dump-schema-only.sql <nome_container>:/dump-schema-only.sql

docker exec -it <nome_container> sh

psql -U giacomo -d universal -f /dump-schema-only
```

2. **Importa i dati** (utenti, esami ecc...):

```bash
docker cp database/dump-data-only.sql <nome_container>:/dump-data-only.sql

docker exec -it <nome_container> sh

psql -U giacomo -d universal -f /dump-data-only
```

Durante l'importazione è bene assicurarsi che:

- Il container PostgreSQL sia in esecuzione

- I file`.sql` siano correttamente posizionati nella cartella `progetto/database`

### **Credenziali di esempio**

L'applicazione include un utente di tipo Segretario con le seguenti credenziali di accesso:

Email: `giacomo.comitani@segretari.universal.it`

Password: `passwor!` (Nota: questa password è la stessa per tutti gli utenti).

### **Connessione al Database PostgreSQL**

Se si desidera connettersi al database PostgreSQL direttamente, si può utilizzare il client `psql` con le seguenti credenziali:

Host: `localhost`

Porta: `5432`

Utente: `giacomo`

Password: `giacomo`

Database: `universal`

E connettersi al database usando il comando:

```bash
psql -h localhost -U giacomo -d universal
```
### Avvio della Web App con VS Code (opzionale)

Se desideri avviare rapidamente la Web App per testarne il funzionamento, è possibile farlo direttamente da **Visual Studio Code**, grazie all’estensione [PHP Server](https://github.com/brapifra/vscode-phpserver). Ecco i passaggi:

1. Apri Visual Studio Code e posizionati nella cartella `progetto/webapp`.

2. Installa l'estensione **PHP Server** (se non l'hai già installata)

    - Vai nella barra laterale di VS Code → Estensioni (icona quadrata)

    - Cerca PHP Server di [brapifra](https://github.com/brapifra) e installala

3. Avvia il server locale:

    - Apri il file `login.php`

    - In alto a destra apparirà un icona blu -> cliccala

    - Si aprirà automaticamente il browser con la Web App attiva

>[!warning]
> Assicurati che PHP sia installato sul tuo sistema (in PATH), altrimenti l’estensione non funzionerà correttamente. Inoltre, il container Docker del database deve essere attivo perché la Web App possa funzionare.