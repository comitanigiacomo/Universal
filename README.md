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
   git clone https://github.com/tuo-username/universal.git
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

Una volta avviato il container con Docker, è possibile popolare il database utilizzando i file SQL presenti nella cartella `progetto/database`:

- `dump-schema-only.sql`: Crea la struttura del database (tabelle, funzioni, ecc.).

- `dump-data-only.sql`: Popola il database con i dati di esempio.

È possibile eseguire questi script utilizzando un client PostgreSQL come `psql` o un'interfaccia grafica come **pgAdmin**.

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