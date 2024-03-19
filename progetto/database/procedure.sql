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
    BEGIN
        SELECT matricola INTO matricola_ex_studente
        FROM universal.studenti
        WHERE id = _id;

        UPDATE universal.utenti
        SET tipo = 'ex_studente'
        WHERE universal.utenti.id = _id;

        INSERT INTO universal.ex_studenti (id, motivo, matricola)
        VALUES (_id, _motivo, matricola_ex_studente);

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
            INSERT INTO universal.insegnamenti(nome, descrizione, anno, responsabile, corso_di_laurea)
            VALUES (_nome, _descrizione, _anno, _responsabile, _corso_di_laurea);
        END;
    $$;

-- INSERISCE UN APPELLO

CREATE OR REPLACE PROCEDURE universal.insert_exam_session(
    _nome VARCHAR(40),
    _descrizione TEXT,
    _anno INTEGER,
    _responsabile uuid,
    _corso_di_laurea INTEGER
)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO universal.insegnamenti(nome, descrizione, anno, responsabile, corso_di_laurea)
            VALUES (_nome, _descrizione, _anno, _responsabile, _corso_di_laurea);
        END;
    $$;


-- MODIFICA PASSWORD STUDENTE

-- ISCRIZIONE APPELLO STUDENTE

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