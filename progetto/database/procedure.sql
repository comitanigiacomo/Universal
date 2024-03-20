-- PROCEDURE

-- TRASFORMA UNO STUDENTE IN UN EX_STUDENTE
CREATE OR REPLACE PROCEDURE studentToExStudent (
    _id uuid,
    _motivo TipoMotivo
)
  LANGUAGE plpgsql
  AS $$
    DECLARE
        matricola_ex_studente INTEGER;
        cdl INTEGER;
    BEGIN
        SELECT matricola INTO matricola_ex_studente
        FROM universal.studenti
        WHERE id = _id;

        SELECT corso_di_laurea INTO cdl
        FROM universal.studenti
        WHERE id = _id;

        UPDATE universal.utenti
        SET tipo = 'ex_studente'
        WHERE universal.utenti.id = _id;

        INSERT INTO universal.ex_studenti (id, motivo, matricola, corso_di_laurea)
        VALUES (_id, _motivo, matricola_ex_studente,cdl);

        DELETE FROM universal.studenti
        WHERE universal.studenti.id = _id;

    END;
  $$;

-- INSERISCE UN NUOVO UTENTE
CREATE OR REPLACE PROCEDURE universal.insert_utente(
    nome VARCHAR(40),
    cognome VARCHAR(40),
    tipo TipoUtente,
    password VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    email VARCHAR(255);
    crypt_password VARCHAR(255);
BEGIN
    -- Verifica che la password soddisfi i vincoli prima della crittografia
    IF LENGTH(password) != 8 OR NOT (password ~ '[!@#$%^&*()-_+=]') THEN
        RAISE EXCEPTION 'La password deve essere lunga 8 caratteri e contenere almeno un carattere speciale.';
    END IF;

    email := universal.get_email(nome, cognome, tipo);
    crypt_password := crypt(password, gen_salt('bf')); -- Utilizzo del metodo di crittografia Blowfish
    INSERT INTO universal.utenti (nome, cognome, tipo, email, password)
    VALUES (nome, cognome, tipo, email, crypt_password);
END;
$$;

-- INSERISCE UN CORSO DI LAUREA
CREATE OR REPLACE PROCEDURE universal.insert_degree_course(
    _nome VARCHAR(40),
    _tipo INTEGER,
    _descrizione TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO universal.corsi_di_laurea(nome, tipo, descrizione)
    VALUES (_nome, _tipo, _descrizione);
END;
$$;

-- INSERISCE UN INSEGNAMENTO

CREATE OR REPLACE PROCEDURE universal.insert_teaching(
    _nome VARCHAR(40),
    _descrizione TEXT,
    _anno INTEGER,
    _responsabile uuid,
    _corso_di_laurea INTEGER
)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO universal.insegnamenti(nome, descrizione, anno, docente_responsabile, corso_di_laurea)
            VALUES (_nome, _descrizione, _anno, _responsabile, _corso_di_laurea);
        END;
    $$;

-- INSERISCE UN APPELLO

CREATE OR REPLACE PROCEDURE universal.insert_exam_session(
    _data DATE,
    _luogo VARCHAR(40),
    _insegnamento INTEGER
)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO universal.appelli(data, luogo, insegnamento)
            VALUES (_data, _luogo, _insegnamento);
        END;
    $$;

-- ISCRIVE UNO STUDENTE AD UN APPELLO ( DATO IL SUO ID E APPELLO, SPERO DI AVERLO NELLA SESSIONE PHP )
CREATE OR REPLACE PROCEDURE universal.subscription(
    _id uuid, -- HO TUTTE LE INFORMAZIONI DI STUDENTE PER get_student()
    _appello INTEGER
)
    LANGUAGE plpgsql
    AS $$
        DECLARE
        BEGIN
            INSERT INTO universal.iscritti(appello, studente,voto)
            VALUES (_appello, _id,NULL);
        END;
    $$;

-- MODIFICA PASSWORD STUDENTE

-- DOCENTE METTE VALUTAZIONE
CREATE OR REPLACE PROCEDURE universal.insert_grade(
    _id_studente uuid,
    _id_docente uuid,
    codice_appello INTEGER,
    _voto INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Controllo se il docente è responsabile dell'appello specificato
    IF NOT EXISTS (
        SELECT 1
        FROM universal.insegnamenti AS ins
        WHERE ins.docente_responsabile = _id_docente
    ) THEN
        RAISE EXCEPTION 'Il docente specificato non è responsabile per l''appello specificato.';
    END IF;

    -- Aggiornamento del voto dello studente nell'appello specificato
    UPDATE universal.iscritti
    SET voto = _voto
    WHERE studente = _id_studente AND appello = codice_appello;
END;
$$;


-- DISISCRIZIONE APPELLO STUDENTE

-- ISCRIZIONE CORSO DI LAURERA STUDENTE

-- DISISCRIZIONE CORSO DI LAUREA STUDENTE

-- CREAZIONE APPELLO DOCENTE

 -- CANCELLAZIONE APPELLO DOCENTE

-- CREAZIONE UTENTE SEGRETARIO

-- CANCELLAZIONE STUDENTE SEGRETARIO

-- ASSEGNAZIONE DOCENTE INSEGNAMENTO SEGRETARIO

-- DISASSEGNAMENTO DOCENTE INSEGNAMENTO SEGRETARIO

-- SEGRETARIO CREA NUOVO STUDENTE

-- SEGRETARIO CREA NUOVO DOCENTE

-- SEGRETARIO MODIFICA STUDENTE

-- SEGRETARIO MODIFICA DOCENTE

-- SEGRETARIO MODIFICA CALENDARIO APPELLI

-- SEGRETARIO CREA NUOVO SEGRETARIO

-- SEGRETARIO MODIFICA SEGRETARIO

-- SEGRETARIO CANCELLA SEGRETARIO

-- SEGRETARIO CREA PASSWORD UTENTE

-- SEGRETARIO CREA CORSO DI LAUREA

-- SEGRETARIO MODIFICA CORSO DI LAUREA

-- SEGRETARIO ELIMINA CORSO DI LAUREA

-- SEGRETARIO CREA NUOVO INSEGNAMENTO

-- SEGRETARIO MODIFICA NUOVO INSEGNAMENTO

-- SEGRETARIO ELIMINA INSEGNAMENTO

-- SEGRETARIO CREA APPELLO

-- SEGRETARIO MODIFICA APPELLO

-- SEGRETARIO ELIMINA APPELLO

-- SEGRETARIO ISCRIVE UNO STUDENTE AD UN APPELLO

-- SEGRETARIO ELIMINA STUDENTE DA UN APPELLO