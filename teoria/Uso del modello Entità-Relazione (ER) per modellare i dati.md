
> [!note]
> Il modello ER descrive i dati come entità, relazioni e attributi.

# Entità e attributi

Un **entità** è una cosa o un oggetto del mondo reale dotata di un'esistenza indipendente.

Un'entità può essere: 

- **Fisica**: ha un'esistenza fisica, come una persona, una casa
- **Concettuale**: Azienda, lavoro etc...

Ciascuna entità ha degli **Attributi**, ovvero delle proprietà particolari che la descrivono.

Nel modello ER esistono diversi tipi di attributi: 

- **Attributi semplici**: Non posso scomporlo ulteriormente.

- **Attributi composti**: Possono essere divisi in parti più piccole. utile quando ho dei componenti a cui delle volte mi rivolgo come un tutt'uno

- **Attributi a valore singolo**: hanno un singolo valore per un'entità. ( età )

- **Attributi multivalore**: hanno un insieme di valori per la stessa entità. ( lauree )

- **Attributi archiviati/derivabili**: A volte due attributi  possono essere correlati, come `data_di_nascita` ed `età`, che quindi sono rispettivamente archiviato e derivato.

- **Attributi complessi**: insieme di attributi composti. . È possibile rappresentare un annidamento arbitrario raggruppando i componenti di un attributo composto tra parentesi tonde () e separando i componenti con virgole, nonché indicando gli attributi multivalore tra parentesi graffe {}.

Viene definito il valore `NULL`, applicabile ad un'entità come attributo in caso di: 

- valore non applicabile

- valore sconosciuto :
    - valore mancante
    - valore non noto

# Tipi di entità, insiemi di entità, chiavi e insiemi di valori

> [!note]
> Un tipo di entità definisce una collezione di entità che possiedono gli stessi attributi

La collezione di tutte le entità di un tipo in un qualsiasi istante di tempo è detta **insieme di entità**

> [!note]
> Un tipo di entità è rappresentato nel modello ER con un rettangolo con all'interno il nome del tipo. gli attributi sono posti all'interno di ovali, collegati ai tipi mediante linee rette. Gli attributi multivalore sono rappresentati mediante ovali doppi.

Un tipo di entità ha uno o più attributi i cui valori sono distinti per ciascuna entità dell'insieme. Questi attributi vengono detti **Attributi chiave**, vengono usati per identificare univocamente le entità all'interno dell'insieme. 

Talora molti attributi insieme formano una **chiave**: la combinazione di questi attributi è unica per l'entità. 

> [!note]
> Nei diagrammi ER gli attributi chiave vengono sottolineati 

Alcuni tipi di entità hanno più di un attributo chiave, altre non ne hanno e sono chiamate **entità deboli**. 

# Tipi di relazioni, insiemi di relazioni, ruoli e vincoli

> [!note]
> il grado di un tipo di relazione è il numero di tipi di entità che vi partecipano 

Ad esempio la relazione `lavora_per` è di grado due: 

![alt text](image.png)

> [!note]
> Nei diagrammi ER, i tipi di relazione sono rappresentati come rombi, collegati con linee rette ai rettangoli che rappresentano i tipi di entità partecipanti. Il nome della relazione è rappresentato all’interno del relativo rombo

I tipi di relazione hanno alcuni **vincoli** che limitano le possibili combinazioni di entità ch epossono far parte del corrispondente insieme di relazioni. 

È possibile distinguere due tipi principali di vincoli di relazione: rapporto di **cardinalità** e **partecipazione**.

Il **rapporto di cardinalità** di una relazione specifica il numero massimo di istanze di relazione a cui può partecipare un antità. Quindi nel caso di una associazione binaria di cardinalità 1:N, ho che un entità di sx può essere correlato ad una di destra, ma una sola di destra a quella di sx. 

> [!note]
> I rapporti di cardinalità per associazioni binarie sono rappresentati nei diagrammi ER ponendo 1, M e N sui rombi 

Il **vincolo di partecipazione**  specifica il numero minimo di istanze di relazione a cui ogni entità può partecipare, chiamato anche **vincolo di cardinalità minima**. 

Ci sono due tipi di vincoli di partecipazione, **totale** e **parziale**. 

il vincolo è totale se ogni se ogni entità dell'insieme deve essere correlata ad un entità attraverso la relazione

il vincolo è parziale se se sono correlate solamente alcune entità. 

> [!note]
> Nei diagrammi ER la partecipazione totale (o l’esistenza subordinata) è rappresentata con una linea doppia che collega il tipo di entità partecipante alla relazione, mentre la partecipazione parziale è rappresentata con una linea singola

Anche i tipi relazione possono avere attributi. 

# Tipi di entità debole

> [!note]
> i tipi di entità che non hanno attributi chiave sono detti tipi di entità debole

Di conseguenza quelli che lo hanno sono detti **tipi di entità forti**. Le entità che appartengono ad un tipo di entità debole vengono quindi identificate tramite il collegamento con specifiche entità di un altro tipo, chiamato **proprietà**. 

Un tipo di entità debole ha sempre un vincolo di partecipazione totale relativo alla relazione che collega l'entità debole al proprietario, altrimenti non potrebbe essere identificata

Normalmente un tipo di entità debole ha una **chiave parziale**, insieme di attributi che possono identificare univocamente le entità deboli collegate ala stessa entità proprietaria.  

> [!note]
> Nei diagrammi ER, sia un tipo di entità debole sia la sua relazione identificante vengono distinte circondando i relativi rettangoli e rombi con linee doppie. L’attributo chiave parziale è sottolineato con una linea tratteggiata o punteggiata.

Ecco di seguito un riepilogo delle convenzioni per i diagrammi ER: 

![alt text](image-1.png)

Nei diagrammi ER verrà usata la convenzione di indicare con lettere maiuscole i nomi dei tipi di entità e dei tipi di relazione, con iniziali maiuscole i nomi degli attributi e con lettere minuscole i nomi di ruolo. I nomi che compaiono nel resoconto tendono a dare origine a nomi di tipi di entità, mentre i verbi tendono a indicare nomi di tipi di relazione.

# Tipi di relazione di grado maggiore di 2

> [!note]
> Il grado di un tipo di relazione è il numero di tipi di entità che partecipano al tipo di relazione e un tipo di relazione di grado due viene detto **binario**, mentre un tipo di relazione di grado tre è **ternario**










