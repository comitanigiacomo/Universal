-- TABELLE

CREATE TYPE TipoMotivo AS ENUM ('laureato', 'rinuncia');
CREATE TYPE TipoUtente AS ENUM ('studente','docente','segretario','ex_studente');

CREATE SEQUENCE matricola_sequence START 1000;

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


-- FUNZIONI


-- VERIFICA LOGIN UTENTE E RESTITUISCE ID E TIPO


CREATE OR REPLACE FUNCTION universal.login (
  email VARCHAR(255),
  password VARCHAR(255)
)
  RETURNS TABLE (
    id uuid,
    tipo TipoUtente
  )
  LANGUAGE plpgsql
  AS $$
    BEGIN

      RETURN QUERY
        SELECT
            utenti.id,
            utenti.tipo::TipoUtente
        FROM universal.utenti
        WHERE
            login.password = universal.utenti.password
            AND login.email = utenti.email
            AND utenti.password = login.password;
    END;
  $$;

-- RESTITUISCE TUTTI GLI STUDENTI


    CREATE OR REPLACE FUNCTION universal.get_all_students()
        RETURNS TABLE (
            id uuid,
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            matricola INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    utenti.id,
                    utenti.nome,
                    utenti.cognome,
                    utenti.email,
                    studenti.matricola
                FROM universal.utenti
                    INNER JOIN universal.studenti ON studenti.id = utenti.id
                WHERE utenti.tipo = 'studente';
            END ;
        $$;

    CREATE OR REPLACE FUNCTION genera_matricola()
    RETURNS INTEGER AS $$
    DECLARE
        nuova_matricola INTEGER;
    BEGIN
        SELECT nextval('matricola_sequence') INTO nuova_matricola;
        RETURN nuova_matricola;
    END;
$$ LANGUAGE plpgsql;


-- TRIGGER

CREATE TRIGGER aggiorna_tabella_trigger
AFTER INSERT ON universal.utenti
FOR EACH ROW EXECUTE FUNCTION aggiorna_tabella();

-- AGGIORNA LA TABELLA CORRISPONDENTE IN BASE AL TIPO DELL'UTENTE CREATO NELLA TABELLA UTENTI
CREATE SEQUENCE matricola_sequence START 1000;

CREATE OR REPLACE FUNCTION aggiorna_tabella()
RETURNS TRIGGER AS $$
DECLARE
    new_matricola INTEGER;
BEGIN
    IF NEW.tipo = 'studente' THEN
        new_matricola := genera_matricola();
        INSERT INTO universal.studenti (id, matricola)
        VALUES (NEW.id, new_matricola);
    ELSIF NEW.tipo = 'docente' THEN
        INSERT INTO universal.docenti (id, ufficio)
        VALUES (NEW.id, 'edificio 74');
    ELSIF NEW.tipo = 'segretario' THEN
        INSERT INTO universal.segretari (id, sede)
        VALUES (NEW.id, 'sede centrale');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger
AFTER DELETE ON universal.ex_studenti
FOR EACH ROW EXECUTE FUNCTION elimina_utente_dopo_cancellazione();


CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger
AFTER DELETE ON universal.segretari
FOR EACH ROW EXECUTE FUNCTION elimina_utente_dopo_cancellazione();


CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger
AFTER DELETE ON universal.docenti
FOR EACH ROW EXECUTE FUNCTION elimina_utente_dopo_cancellazione();

-- ELIMINA IL DOCENTE, LO STUDENTE O IL  SEGRETARIO, E L'UTENTE CORRISPONDENTE

CREATE OR REPLACE FUNCTION elimina_utente_dopo_cancellazione()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM universal.utenti WHERE id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- PROCEDURE 

CREATE OR REPLACE PROCEDURE studentToExStudent (
    _id uuid,
    _motivo TipoMotivo
)
  LANGUAGE plpgsql
  AS $$
    BEGIN

        UPDATE universal.utenti
        SET tipo = 'ex_studente'
        WHERE universal.utenti.id = _id;

        INSERT INTO universal.ex_studenti (id, motivo)
        VALUES (_id, _motivo);

        DELETE FROM universal.studenti
        WHERE universal.studenti.id = _id;

    END;
  $$;

