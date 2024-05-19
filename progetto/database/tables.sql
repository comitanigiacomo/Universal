-- TABELLE

CREATE TYPE TipoMotivo AS ENUM ('laureato', 'rinuncia');
CREATE TYPE TipoUtente AS ENUM ('studente','docente','segretario','ex_studente');

CREATE SEQUENCE matricola_sequence START 100000;
CREATE SEQUENCE codice_corso_laurea START WITH 1 INCREMENT BY 1;

CREATE TABLE universal.utenti(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    cognome VARCHAR(40) NOT NULL CHECK(cognome !~ '[0-9]'),
    tipo TipoUtente NOT NULL CHECK(tipo IN ('studente', 'docente', 'segretario', 'ex_studente')),
    email VARCHAR(255) NOT NULL CHECK(email != ''),
    password VARCHAR(255) NOT NULL
);

CREATE TABLE universal.docenti (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    ufficio VARCHAR(100)
);

CREATE TABLE universal.studenti (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    matricola INTEGER UNIQUE NOT NULL,
    corso_di_laurea INTEGER REFERENCES universal.corsi_di_laurea(codice) ON UPDATE CASCADE
);

CREATE TABLE universal.segretari (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    sede VARCHAR(40) DEFAULT 'sede_centrale'
);

CREATE TABLE universal.ex_studenti (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    matricola INTEGER NOT NULL,
    motivo TipoMotivo NOT NULL,
    corso_di_laurea INTEGER REFERENCES universal.corsi_di_laurea(codice) ON UPDATE CASCADE
);

CREATE TABLE universal.corsi_di_laurea (
    codice SERIAL UNIQUE PRIMARY KEY,
    nome TEXT NOT NULL CHECK(nome !~ '[0-9]'),
    tipo integer CHECK(tipo in (3,5,2)),
    descrizione TEXT NOT NULL
);

CREATE TABLE universal.insegnamenti (
    codice SERIAL UNIQUE PRIMARY KEY,
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    descrizione TEXT,
    anno INTEGER CHECK(anno BETWEEN 2000 AND 2100),
    docente_responsabile uuid NOT NULL REFERENCES universal.docenti(id) ,
    corso_di_laurea INTEGER NOT NULL REFERENCES universal.corsi_di_laurea(codice) ON UPDATE CASCADE
);

CREATE TABLE universal.appelli (
    codice SERIAL UNIQUE PRIMARY KEY,
    data date NOT NULL,
    luogo VARCHAR(40) NOT NULL,
    insegnamento INTEGER NOT NULL REFERENCES universal.insegnamenti(codice) ON UPDATE CASCADE
);


CREATE TABLE universal.iscritti (
    appello INTEGER NOT NULL REFERENCES universal.appelli(codice),
    studente uuid NOT NULL REFERENCES universal.utenti(id),
    insegnamento INTEGER,
    voto INTEGER CHECK( voto BETWEEN 0 AND 31 ),
    PRIMARY KEY (appello, studente, voto)
);

CREATE TABLE universal.propedeutico (
    insegnamento INTEGER NOT NULL REFERENCES universal.insegnamenti(codice),
    propedeuticità INTEGER NOT NULL REFERENCES universal.insegnamenti(codice),
    PRIMARY KEY (insegnamento, propedeuticità)
);
