CREATE TYPE TipoMotivo AS ENUM ('laureato', 'rinuncia');
CREATE TYPE TipoUtente AS ENUM ('studente','docente','segretario','ex_studente');

CREATE TABLE universal.utenti(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    cognome VARCHAR(40) NOT NULL CHECK(cognome !~ '[0-9]'),
    tipo VARCHAR(20) NOT NULL CHECK(tipo IN ('studente', 'docente', 'segretario')),
    email VARCHAR(255) NOT NULL CHECK(email != ''),
    password VARCHAR(255) NOT NULL CHECK (LENGTH(password) = 8 AND password ~ '[!@#$%^&*()-_+=]')
);



CREATE TABLE universal.docenti (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    ufficio VARCHAR(100)
);

CREATE TABLE universal.studenti (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    matricola INTEGER UNIQUE NOT NULL
);

CREATE TABLE universal.segretari (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    sede VARCHAR(40) DEFAULT 'sede_centrale'
);

CREATE TABLE universal.ex_studenti (
    id uuid PRIMARY KEY REFERENCES universal.utenti(id),
    motivo TipoMotivo NOT NULL
);

CREATE TABLE universal.corsi_di_laurea (
    codice integer PRIMARY KEY,
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    tipo integer CHECK(tipo in (3,5)),
    descrizione TEXT NOT NULL
);

CREATE TABLE universal.insegnamenti (
    codice INTEGER PRIMARY KEY,
    nome VARCHAR(40) NOT NULL CHECK(nome !~ '[0-9]'),
    descrizione TEXT,
    anno INTEGER CHECK(anno BETWEEN 2000 AND 2100)
);


CREATE TABLE universal.appelli (
    codice uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    data date NOT NULL,
    luogo VARCHAR(40) NOT NULL
);

CREATE TABLE universal.iscritti (
    appello uuid NOT NULL REFERENCES universal.appelli(codice),
    studente uuid NOT NULL REFERENCES universal.studenti(id),
    voto INTEGER CHECK( voto BETWEEN 0 AND 31 ),
    PRIMARY KEY (appello, studente)
);


CREATE TABLE universal.propedeutico (
    insegnamento INTEGER NOT NULL REFERENCES universal.insegnamenti(codice),
    propedeuticità INTEGER NOT NULL REFERENCES universal.insegnamenti(codice),
    PRIMARY KEY (insegnamento, propedeuticità)
);
