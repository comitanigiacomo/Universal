CREATE TYPE TipoMotivo AS ENUM ('laureato', 'rinuncia');

CREATE TABLE universal.utente(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    cognome VARCHAR(40) NOT NULL CHECK(cognome !~ '[0-9]'),
    tipo VARCHAR(20) NOT NULL CHECK(tipo IN ('studente', 'docente', 'segreteria')),
    email VARCHAR(255) NOT NULL CHECK(email != ''),
    password VARCHAR(255) NOT NULL CHECK(password ~ '[^a-zA-Z0-9]{5,5}')
);

CREATE TABLE universal.docente (
    id integer PRIMARY KEY REFERENCES universal.utente(id),
    ufficio VARCHAR(100) NOT NULL check (ufficio <> '')
);

CREATE TABLE universal.corso_di_laurea (
    codice integer PRIMARY KEY,
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    tipo integer CHECK(tipo in (3,5)),
    descrizione TEXT NOT NULL
);

CREATE TABLE universal.studente (
    id INTEGER PRIMARY KEY REFERENCES universal.utente(id),
    matricola INTEGER UNIQUE NOT NULL
);
CREATE TABLE universal.segretario (
    id INTEGER PRIMARY KEY REFERENCES universal.utente(id),
    sede VARCHAR(40) DEFAULT 'sede_centrale'
);

CREATE TABLE universal.ex_studente (
    id INTEGER PRIMARY KEY REFERENCES universal.utente(id),
    motivo TipoMotivo NOT NULL
);

CREATE TABLE universal.insegnamento (
    codice INTEGER PRIMARY KEY,
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    descrizione TEXT,
    anno INTEGER CHECK(anno BETWEEN 2000 AND 2100)
);


CREATE TABLE universal.appelli (
    codice INTEGER PRIMARY KEY,
    data date NOT NULL,
    luogo VARCHAR(40) NOT NULL
);


CREATE TABLE universal.iscritto (
    appello INTEGER NOT NULL REFERENCES universal.appelli(codice),
    studente INTEGER NOT NULL REFERENCES universal.studente(id),
    voto INTEGER CHECK( voto BETWEEN 0 AND 31 ),
    PRIMARY KEY (appello, studente)
);

CREATE TABLE universal.propedeutico (
    insegnamento INTEGER NOT NULL REFERENCES universal.insegnamento(codice),
    propedeuticità INTEGER NOT NULL REFERENCES universal.insegnamento(codice),
    PRIMARY KEY (insegnamento, propedeuticità)
);

