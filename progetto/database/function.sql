-- FUNZIONI

-- VERIFICA LOGIN UTENTE E RESTITUISCE ID E TIPO
CREATE OR REPLACE FUNCTION universal.login (
  login_email VARCHAR(255),
  login_password TEXT
)
  RETURNS TABLE (
    id uuid,
    tipo TipoUtente
  )
  LANGUAGE plpgsql
  AS $$
    DECLARE
      stored_password TEXT;
    BEGIN
      -- Recupera la password criptata associata all'email inserita
      SELECT password INTO stored_password
      FROM universal.utenti
      WHERE email = login_email;

      -- Controlla se l'email esiste e se la password in chiaro corrisponde alla password criptata nel database
      IF FOUND AND crypt(login_password, stored_password) = stored_password THEN
        RETURN QUERY
          SELECT
            utenti.id,
            utenti.tipo::TipoUtente
          FROM universal.utenti
          WHERE utenti.email = login_email;
      ELSE
        RAISE EXCEPTION 'Email o password non valide.';
      END IF;
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

-- RESTITUISCE TUTTI GLI EX STUDENTI

    CREATE OR REPLACE FUNCTION universal.get_all_exstudents()
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
                    ex_studenti.matricola
                FROM universal.utenti
                    INNER JOIN universal.ex_studenti ON utenti.id = ex_studenti.id
                WHERE utenti.tipo = 'ex_studente';
            END ;
        $$;

--RESTITUISCE TUTTI I DOCENTI

    CREATE OR REPLACE FUNCTION universal.get_all_teachers()
        RETURNS TABLE (
            id uuid,
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255)
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    utenti.id,
                    utenti.nome,
                    utenti.cognome,
                    utenti.email
                FROM universal.utenti
                WHERE utenti.tipo = 'docente';
            END ;
        $$;

-- RESTITUISCE UNO STUDENTE DATO IL SUO ID

     CREATE OR REPLACE FUNCTION universal.get_student(_id uuid)
        RETURNS TABLE (
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
                    utenti.nome,
                    utenti.cognome,
                    utenti.email,
                    studenti.matricola
                FROM universal.utenti
                    INNER JOIN universal.studenti ON _id = studenti.id
                WHERE utenti.id = _id;
            END ;
        $$;



-- RESTITUISCE UN DOCENTE DATO IL SUO ID

     CREATE OR REPLACE FUNCTION universal.get_teacher(_id uuid)
        RETURNS TABLE (
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255)
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    utenti.nome,
                    utenti.cognome,
                    utenti.email
                FROM universal.utenti
                    INNER JOIN universal.docenti ON _id = docenti.id
                WHERE utenti.id = _id;
            END ;
        $$;

-- RESTITUISCE UN EX STUDENTE DATO IL SUO ID

       CREATE OR REPLACE FUNCTION universal.get_ex_student(_id uuid)
        RETURNS TABLE (
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
                    utenti.nome,
                    utenti.cognome,
                    utenti.email,
                    ex_studenti.matricola
                FROM universal.utenti
                    INNER JOIN universal.ex_studenti ON _id = ex_studenti.id
                WHERE utenti.id = _id;
            END ;
        $$;



-- RESTITUISCE TUTTI I SEGRETARI DISPONIBILI
    CREATE OR REPLACE FUNCTION universal.get_secretaries()
        RETURNS TABLE (
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            tipo TipoUtente
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    utenti.nome,
                    utenti.cognome,
                    utenti.email,
                    utenti.tipo
                FROM universal.utenti
                    INNER JOIN universal.segretari ON utenti.id = segretari.id
                WHERE utenti.tipo= 'segretario';
            END ;
        $$;

-- RESTITUISCE UN SEGERETARIO DATO IL SUO ID

      CREATE OR REPLACE FUNCTION universal.get_secretary(_id uuid)
        RETURNS TABLE (
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            tipo TipoUtente
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    utenti.nome,
                    utenti.cognome,
                    utenti.email,
                    utenti.tipo
                FROM universal.utenti
                WHERE utenti.tipo = 'segretario'AND _id = utenti.id;
            END ;
        $$;

-- RESTITUISCE TUTTI I CORSI DI LAUREA
    CREATE OR REPLACE FUNCTION universal.get_degree_courses()
        RETURNS TABLE (
            nome TEXT,
            tipo INTEGER,
            descrizione TEXT
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    corsi_di_laurea.nome,
                    corsi_di_laurea.tipo,
                    corsi_di_laurea.descrizione
                FROM universal.corsi_di_laurea
                ORDER BY nome;
            END ;
        $$;

-- RESITUISCE UN CORSO DI LAUREA DATO IL SUO CODICE
CREATE OR REPLACE FUNCTION universal.get_degree_course(_codice VARCHAR(6))
        RETURNS TABLE (
            nome TEXT,
            tipo INTEGER,
            descrizione TEXT
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    corsi_di_laurea.nome,
                    corsi_di_laurea.tipo,
                    corsi_di_laurea.descrizione
                FROM universal.corsi_di_laurea
                WHERE universal.corsi_di_laurea.codice = _codice
                ORDER BY universal.corsi_di_laurea.nome;
            END ;
        $$;

-- GENERA UNA NUOVA EMAIL
-- IN CASO DI OMONIMIA MODIFICA LA MAIL E AGGIUNGE UN SUFFISSO ALLA FINE INCREMENTALE

 CREATE OR REPLACE FUNCTION universal.get_email(nome VARCHAR(255), cognome VARCHAR(255), tipo TipoUtente)
    RETURNS VARCHAR(100)
    LANGUAGE plpgsql
AS $$
DECLARE
    email_generata VARCHAR(255);
    suffix_count INT;
BEGIN
    SELECT COUNT(*)
    INTO suffix_count
    FROM universal.utenti
    WHERE utenti.nome = $1 AND utenti.cognome = $2;

    IF suffix_count > 0 THEN
        email_generata := nome || '.' || cognome || suffix_count || '@' ||
                           CASE
                               WHEN tipo = 'studente' THEN 'studenti.universal.it'
                               WHEN tipo = 'docente' THEN 'docenti.universal.it'
                               WHEN tipo = 'segretario' THEN 'segretario.universal.it'
                           END;
    ELSE
        email_generata := nome || '.' || cognome || '@' ||
                           CASE
                               WHEN tipo = 'studente' THEN 'studenti.universal.it'
                               WHEN tipo = 'docente' THEN 'docenti.universal.it'
                               WHEN tipo = 'segretario' THEN 'segretario.universal.it'
                           END;
    END IF;
    RETURN email_generata;
END;
$$;


-- RESTITUISCE TUTTI GLI INSEGNAMENTI


-- RESTITUISCE TUTTI GLI INSEGNAMENTI PER CORSO DI LAUREA

-- RESTITUISCE TUTTI GLI APPELLI

-- RESTITUISCE TUTTE LE ISCRIZIONI

-- RESTITUISCE TUTTE LE VALUTAZIONI

-- RESTITUISCE TUTTE LE VALUTAZIONI DI EX STUDENTI

-- RESTITUISCE ESAMI MANCANTI ALLA LAUREA

-- RESTITUISCE INSEGNAMENTIDI CUI UN DOCENTE E' RESPONSABILE

-- RESTITUISE TUTTI GLI ATUDENTI ASCRITTI AGLI APPELLI DI UN DOCENTE

-- RESTITUISCE TUTTE LE VALUAZIONI CHE UN DOCENTE HA DATO

-- RESTITUISCE TUTTI GLI APPELLI DEGLI INSEGNAMENTI DEL CORSO DI LAUREA DI UNO STUDENTE

-- RESTITUISCE LA MEDIA DELLE VLUTAZIONI DI UNO STUDENTE

-- RESTIUISCE TUTTE LE VALUTAZIONI DI UNO STUDENTE

-- RESTITUISCE MEDIA VALUTAZIONI DI UNO STUDENTE

-- RESTITUISCE VOTI DATI AD EX STUDENTE





