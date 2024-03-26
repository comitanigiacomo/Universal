-- FUNZIONI

-- VERIFICA LOGIN UTENTE E RESTITUISCE ID E TIPO
--OK
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
--OK
    CREATE OR REPLACE FUNCTION universal.get_all_students()
        RETURNS TABLE (
            id uuid,
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            matricola INTEGER,
            corso_di_laurea INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.id,
                    u.nome,
                    u.cognome,
                    u.email,
                    s.matricola,
                    s.corso_di_laurea
                FROM universal.utenti AS u
                    INNER JOIN universal.studenti AS s ON s.id = u.id
                WHERE u.tipo = 'studente'
                ORDER BY u.nome;
            END ;
        $$;

-- GENERA IL NUMERO DI MATRICOLA
-- OK
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
--OK
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
                    u.id,
                    u.nome,
                    u.cognome,
                    u.email,
                    ex.matricola
                FROM universal.utenti AS u
                    INNER JOIN universal.ex_studenti AS ex ON u.id = ex.id
                WHERE u.tipo = 'ex_studente'
                ORDER BY u.nome;
            END ;
        $$;

--RESTITUISCE TUTTI I DOCENTI
--OK
    CREATE OR REPLACE FUNCTION universal.get_all_teachers()
        RETURNS TABLE (
            id uuid,
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            ufficio VARCHAR(100)
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.id,
                    u.nome,
                    u.cognome,
                    u.email,
                    d.ufficio
                FROM universal.utenti AS u
                    INNER JOIN universal.docenti AS d ON d.id = u.id
                WHERE u.tipo = 'docente'
                ORDER BY u.nome;
            END ;
        $$;

-- RESTITUISCE L'ID DELLO STUDENTE A PARTIRE DAI DATI DI AUTENTICAZIONE
CREATE OR REPLACE FUNCTION universal.get_id(_email VARCHAR(255))
    RETURNS TABLE (
        id uuid
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            u.id
        FROM universal.utenti AS u
        WHERE u.email = _email;
    END ;
    $$;




-- RESTITUISCE UNO STUDENTE DATO IL SUO ID
-- OK
     CREATE OR REPLACE FUNCTION universal.get_student(_id uuid)
        RETURNS TABLE (
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            matricola INTEGER,
            corso_di_laurea TEXT
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    u.email,
                    s.matricola,
                    cdl.nome
                FROM universal.utenti AS u
                    INNER JOIN universal.studenti as s ON _id = s.id
                    INNER JOIN universal.corsi_di_laurea AS cdl ON s.corso_di_laurea = cdl.codice
                WHERE u.id = _id;
            END ;
        $$;

-- RESTITUISCE UN DOCENTE DATO IL SUO ID
-- OK
     CREATE OR REPLACE FUNCTION universal.get_teacher(_id uuid)
        RETURNS TABLE (
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            ufficio VARCHAR(100)
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    u.email,
                    d.ufficio
                FROM universal.utenti AS u
                    INNER JOIN universal.docenti AS d ON _id = d.id
                WHERE u.id = _id;
            END ;
        $$;

-- RESTITUISCE UN EX STUDENTE DATO IL SUO ID
-- OK
       CREATE OR REPLACE FUNCTION universal.get_ex_student(_id uuid)
        RETURNS TABLE (
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            matricola INTEGER,
            corso_di_laurea INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    u.email,
                    ex.matricola,
                    ex.corso_di_laurea
                FROM universal.utenti AS u
                    INNER JOIN universal.ex_studenti AS ex ON _id = ex.id
                WHERE u.id = _id;
            END ;
        $$;



-- RESTITUISCE TUTTI I SEGRETARI DISPONIBILI
-- OK
    CREATE OR REPLACE FUNCTION universal.get_secretaries()
        RETURNS TABLE (
            id uuid,
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            sede VARCHAR(40)
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.id,
                    u.nome,
                    u.cognome,
                    u.email,
                    s.sede
                FROM universal.utenti AS u
                    INNER JOIN universal.segretari AS s ON u.id = s.id
                WHERE u.tipo= 'segretario'
                ORDER BY u.nome;
            END ;
        $$;

-- RESTITUISCE UN SEGERETARIO DATO IL SUO ID
      CREATE OR REPLACE FUNCTION universal.get_secretary(_id uuid)
        RETURNS TABLE (
            nome VARCHAR(255),
            cognome VARCHAR(255),
            email VARCHAR(255),
            sede VARCHAR(40)
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    u.email,
                    s.sede
                FROM universal.utenti AS u
                    INNER JOIN universal.segretari AS s ON s.id = _id
                WHERE _id = u.id;
            END ;
        $$;

-- RESTITUISCE TUTTI I CORSI DI LAUREA
-- OK
CREATE OR REPLACE FUNCTION universal.get_degree_courses()
        RETURNS TABLE (
            codice INTEGER,
            nome TEXT,
            tipo INTEGER,
            descrizione TEXT
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    cdl.codice,
                    cdl.nome,
                    cdl.tipo,
                    cdl.descrizione
                FROM universal.corsi_di_laurea AS cdl
                ORDER BY nome;
            END ;
        $$;

-- RESITUISCE UN CORSO DI LAUREA DATO IL SUO CODICE
-- OK
CREATE OR REPLACE FUNCTION universal.get_degree_course(_codice INTEGER)
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
                    cdl.nome,
                    cdl.tipo,
                    cdl.descrizione
                FROM universal.corsi_di_laurea AS cdl
                WHERE cdl.codice = _codice;
            END ;
        $$;

-- GENERA UNA NUOVA EMAIL
-- IN CASO DI OMONIMIA MODIFICA LA MAIL E AGGIUNGE UN SUFFISSO ALLA FINE INCREMENTALE
-- OK
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
                               WHEN tipo = 'segretario' THEN 'segretari.universal.it'
                           END;
    ELSE
        email_generata := nome || '.' || cognome || '@' ||
                           CASE
                               WHEN tipo = 'studente' THEN 'studenti.universal.it'
                               WHEN tipo = 'docente' THEN 'docenti.universal.it'
                               WHEN tipo = 'segretario' THEN 'segretari.universal.it'
                           END;
    END IF;
    RETURN email_generata;
END;
$$;


-- RESTITUISCE TUTTI GLI INSEGNAMENTI
-- OK
    CREATE OR REPLACE FUNCTION universal.get_teaching()
        RETURNS TABLE (
            codice INTEGER,
            nome VARCHAR(40),
            descrizione TEXT,
            anno INTEGER,
            responsabile uuid,
            corso_di_laurea INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                   i.codice,
                   i.nome,
                   i.descrizione,
                   i.anno,
                   i.docente_responsabile,
                   i.corso_di_laurea
                FROM universal.insegnamenti AS i
                ORDER BY codice;
            END ;
        $$;

-- RESTITUISCE TUTTI GLI INSEGNAMENTI PER UN CORSO DI LAUREA
-- OK
  CREATE OR REPLACE FUNCTION universal.get_teaching_of_cdl(_codice INTEGER)
        RETURNS TABLE (
            codice INTEGER,
            nome VARCHAR(40),
            descrizione TEXT,
            anno INTEGER,
            responsabile uuid
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    ins.codice,
                    ins.nome,
                    ins.descrizione,
                    ins.anno,
                    ins.docente_responsabile
                FROM universal.insegnamenti as ins
                WHERE ins.corso_di_laurea = _codice
                ORDER BY ins.codice;
            END ;
        $$;

-- RESTITUISCE TUTTI GLI APPELLI DI UN INSEGNAMENTO
-- OK
CREATE OR REPLACE FUNCTION universal.get_exam_sessions(_codice INTEGER)
        RETURNS TABLE (
            data DATE,
            luogo VARCHAR(40),
            nome VARCHAR(40),
            corso_di_laurea INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    a.data,
                    a.luogo,
                    i.nome,
                    i.corso_di_laurea
                FROM universal.appelli AS a
                    INNER JOIN universal.insegnamenti AS i ON a.insegnamento = i.codice
                WHERE i.codice = _codice
                ORDER BY data;
            END ;
        $$;

-- RESTITUISCE TUTTI GLI APPELLI ESISTENTI
-- OK
CREATE OR REPLACE FUNCTION universal.get_all_exam_sessions()
        RETURNS TABLE (
            codice INTEGER,
            data DATE,
            luogo VARCHAR(40),
            nome VARCHAR(40),
            corso_di_laurea INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    a.codice,
                    a.data,
                    a.luogo,
                    i.nome,
                    i.corso_di_laurea
                FROM universal.appelli AS a
                    INNER JOIN universal.insegnamenti AS i ON a.insegnamento = i.codice
                ORDER BY data;
            END ;
        $$;

-- DATO UNO STUDENTE MI RESTITUISCE TUTTI GLI ESAMI A CUI E' ISCRITTO

CREATE OR REPLACE FUNCTION universal.get_student_exam_enrollments(_id uuid)
        RETURNS TABLE (
            codice INTEGER,
            data DATE,
            luogo VARCHAR(40),
            nome_insegnamento VARCHAR(40)
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    a.codice,
                    a.data,
                    a.luogo,
                    ins.nome
                FROM universal.iscritti AS i
                    INNER JOIN universal.utenti AS u ON i.studente = u.id
                    INNER JOIN universal.appelli AS a ON i.appello= a.codice
                    INNER JOIN universal.insegnamenti AS ins ON a.insegnamento = ins.codice
                WHERE u.id = _id
                ORDER BY data;
            END ;
        $$;
-- RESTITUISCE TUTTE LE ISCRIZIONI AD UN  APPELLO D'ESAME
CREATE OR REPLACE FUNCTION universal.get_exam_enrollments(_codice INTEGER)
        RETURNS TABLE (
            nome VARCHAR(40),
            cognome VARCHAR(40),
            email VARCHAR(255),
            matricola INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    u.email,
                    s.matricola
                FROM universal.iscritti AS i
                    INNER JOIN universal.appelli AS a ON i.appello = a.codice
                    INNER JOIN universal.studenti AS s ON i.studente = s.id
                    INNER JOIN universal.utenti AS u ON s.id = u.id
                WHERE i.appello = _codice
                ORDER BY matricola;
            END ;
        $$;



-- RESTITUISCE TUTTE LE VALUTAZIONI RELATIVE AD UN ESAME
CREATE OR REPLACE FUNCTION universal.get_grades(_codice INTEGER)
        RETURNS TABLE (
            nome VARCHAR(40),
            cognome VARCHAR(40),
            matricola INTEGER,
            data DATE,
            voto INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    s.matricola,
                    a.data,
                    i.voto
                FROM universal.iscritti AS i
                    INNER JOIN universal.utenti AS u ON u.id = i.studente
                    INNER JOIN universal.appelli AS a ON i.appello = a.codice
                    INNER JOIN universal.studenti AS s ON s.id = i.studente
                WHERE i.appello = _codice
                ORDER BY voto;
            END ;
        $$;


-- RESTITUISCE TUTTE LE VALUTAZIONI DI EX STUDENTE
CREATE OR REPLACE FUNCTION universal.get_grades_of_ex_student(_id uuid)
        RETURNS TABLE (
            nome VARCHAR(40),
            cognome VARCHAR(40),
            nome_insegnamento VARCHAR(40),
            data DATE,
            voto INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    ins.nome,
                    a.data,
                    i.voto
                FROM universal.iscritti AS i
                    INNER JOIN universal.utenti AS u ON u.id = i.studente
                    INNER JOIN universal.appelli AS a ON i.appello = a.codice
                    INNER JOIN universal.insegnamenti AS ins ON a.insegnamento = ins.codice
                WHERE  i.studente = _id
                ORDER BY voto;
            END ;
        $$;
-- RESTITUISCE LE VALUTAZIONI DI TUTTI GLI EX STUDENTI

    CREATE OR REPLACE FUNCTION universal.get_grades_of_ex_students()
        RETURNS TABLE (
            nome VARCHAR(40),
            cognome VARCHAR(40),
            nome_insegnamento VARCHAR(40),
            data DATE,
            voto INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    ins.nome,
                    a.data,
                    i.voto
                FROM universal.iscritti AS i
                    INNER JOIN universal.utenti AS u ON u.id = i.studente
                    INNER JOIN universal.appelli AS a ON i.appello = a.codice
                    INNER JOIN universal.insegnamenti AS ins ON a.insegnamento = ins.codice
                WHERE u.tipo = 'ex_studente'
                ORDER BY voto;
            END;
        $$;

-- RESTITUISCE ESAMI MANCANTI ALLA LAUREA ( STUDENTI  ISCRITTI )
-- Uno studente quando passa un esame ha una voce in iscritti con un voto. tutti i voti rimangono quindi in iscritti fino a quando lo studente non diventa ex studente
CREATE OR REPLACE FUNCTION universal.get_missing_exams_for_graduation(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        docente_responsabile TEXT,
        corso_di_laurea INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            ins.nome,
            ins.descrizione,
            ins.anno,
            CONCAT(u.nome, ' ', u.cognome) AS nome,
            cdl.codice
        FROM universal.insegnamenti AS ins
        INNER JOIN universal.corsi_di_laurea AS cdl ON ins.corso_di_laurea = cdl.codice
        INNER JOIN universal.studenti AS s ON cdl.codice = s.corso_di_laurea
        LEFT JOIN universal.iscritti AS isc ON isc.insegnamento = ins.codice AND isc.studente = _id
        INNER JOIN universal.utenti AS u ON u.id = ins.docente_responsabile
        WHERE (isc.voto IS NULL AND isc.appello IS NOT NULL) OR (isc.appello IS NULL)
            AND cdl.codice = s.corso_di_laurea
        ORDER BY ins.nome;
    END;
$$;

-- RESTITUISCE INSEGNAMENTI DI DI CUI UN DOCENTE E' RESPONSABILE
CREATE OR REPLACE FUNCTION universal.get_teaching_activity_of_professor(_id uuid)
    RETURNS TABLE (
        codice_insegnamento INTEGER,
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        docente_responsabile uuid,
        corso_di_laurea INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            ins.codice INTEGER,
            ins.nome,
            ins.descrizione,
            ins.anno,
            ins.docente_responsabile,
            cdl.codice
        FROM universal.insegnamenti AS ins
            INNER JOIN universal.corsi_di_laurea AS cdl ON ins.corso_di_laurea = cdl.codice
            INNER JOIN universal.docenti AS d ON ins.docente_responsabile = d.id
        WHERE _id = d.id
        ORDER BY ins.codice;
    END;
$$;

-- RESTITUISE TUTTI GLI STUDENTI ISCRITTI AGLI APPELLI DI UN INSEGNAMENTO DI CUI UN DOCENTE È RESPONSABILE
CREATE OR REPLACE FUNCTION universal.get_students_enrolled_in_teaching_appointments(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        cognome VARCHAR(40),
        matricola INTEGER,
        data DATE,
        luogo VARCHAR(40),
        insegnamento INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            u.nome,
            u.cognome,
            s.matricola,
            a.data,
            a.luogo,
            ins.codice
        FROM
            universal.iscritti AS i
            INNER JOIN universal.utenti AS u ON i.studente = u.id
            INNER JOIN universal.insegnamenti AS ins ON i.insegnamento = ins.codice
            INNER JOIN universal.studenti AS s ON u.id = s.id
            INNER JOIN universal.appelli AS a ON ins.codice = a.insegnamento
        WHERE
            ins.docente_responsabile = _id  -- Filtra solo gli insegnamenti di cui il docente è responsabile
        ORDER BY matricola;
    END;
$$;

-- RESTITUISCE TUTTE LE VALUAZIONI CHE UN DOCENTE HA DATO
CREATE OR REPLACE FUNCTION universal.get_teacher_grades(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        cognome VARCHAR(40),
        matricola INTEGER,
        data DATE,
        luogo VARCHAR(40),
        insegnamento INTEGER,
        voto INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            u.nome,
            u.cognome,
            s.matricola,
            a.data,
            a.luogo,
            ins.codice,
            i.voto
        FROM
            universal.iscritti AS i
            INNER JOIN universal.utenti AS u ON i.studente = u.id
            INNER JOIN universal.insegnamenti AS ins ON i.insegnamento = ins.codice
            INNER JOIN universal.studenti AS s ON u.id = s.id
            INNER JOIN universal.appelli AS a ON ins.codice = a.insegnamento
        WHERE
            ins.docente_responsabile = _id  -- Filtra solo gli insegnamenti di cui il docente è responsabile
        ORDER BY matricola;
    END;
$$;
-- RESTITUISCE GLI APPELLI DI TUTTI GLI INSEGNAMENTI DEL CORSO DI LAUREA DI UNO STUDENTE
CREATE OR REPLACE FUNCTION universal.get_all_teaching_appointments_for_student_degree(_id uuid)
    RETURNS TABLE (
        codice INTEGER,
        data DATE,
        luogo VARCHAR(40),
        insegnamento VARCHAR(40)
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            a.codice,
            a.data,
            a.luogo,
            ins.nome
        FROM
            universal.appelli AS a
            INNER JOIN universal.insegnamenti AS ins ON ins.codice = a.insegnamento
            INNER JOIN universal.studenti AS s ON s.corso_di_laurea = ins.corso_di_laurea
        WHERE
            s.id = _id
        ORDER BY a.data;
    END;
$$;

-- RESTIUISCE TUTTE LE VALUTAZIONI DI UNO STUDENTE
CREATE OR REPLACE FUNCTION universal.get_student_grades(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        data DATE,
        docente_responsabile TEXT,
        corso_di_laurea INTEGER,
        voto INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            ins.nome,
            ins.descrizione,
            ins.anno,
            a.data,
            CONCAT(u.nome, ' ', u.cognome) AS docente_responsabile,
            ins.corso_di_laurea,
            i.voto
        FROM universal.iscritti AS i
            INNER JOIN universal.appelli AS a ON i.appello = a.codice
            INNER JOIN universal.insegnamenti AS ins ON a.insegnamento = ins.codice
            INNER JOIN universal.utenti AS u ON ins.docente_responsabile = u.id
        WHERE i.voto IS NOT NULL and i.studente = _id
        ORDER BY data;
    END;
$$;

-- RESTITUISCE MEDIA VALUTAZIONI DI UNO STUDENTE
CREATE OR REPLACE FUNCTION universal.get_student_average(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        cognome VARCHAR(40),
        matricola INTEGER,
        media DECIMAL
    )
    LANGUAGE plpgsql
    AS $$
    DECLARE
        total_votes INTEGER := 0;
        total_count INTEGER := 0;
        rec_row RECORD;
        grade_cursor CURSOR FOR SELECT * FROM universal.get_partial_carrer(_id);
    BEGIN
        OPEN grade_cursor;
        LOOP
            FETCH grade_cursor INTO rec_row;
            EXIT WHEN NOT FOUND;

            total_votes := total_votes + rec_row.voto;
            total_count := total_count + 1;
        END LOOP;
        CLOSE grade_cursor;

        -- Calcola la media se ci sono valutazioni
        IF total_count > 0 THEN
            media := ROUND(total_votes::DECIMAL / total_count, 2);
        ELSE
            media := 0;
        END IF;
         RETURN QUERY SELECT u.nome, u.cognome, s.matricola, media
                          FROM universal.studenti AS s
                            INNER JOIN universal.utenti AS u ON s.id = u.id
                          WHERE u.id = _id;
    END;
$$;

-- RESTITUISCE VOTI DATI AD EX STUDENTE
CREATE OR REPLACE FUNCTION universal.get_exstudent_grades(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        cognome VARCHAR(40),
        matricola INTEGER,
        insegnamento INTEGER,
        voto INTEGER,
        data DATE,
        corso_di_laurea INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            ex.nome,
            ex.cognome,
            ex.matricola,
            ins.codice,
            ex.voto,
            ex.data,
            ex.insegnamento
        FROM universal.storico_valutazioni AS ex
            INNER JOIN universal.insegnamenti AS ins ON ex.insegnamento = ins.codice
        WHERE ex.id = _id
        ORDER BY data;
    END;
$$;

-- RESTITUISCE TUTTI I CORSI DI LAUREA PRESENTI
CREATE OR REPLACE FUNCTION universal.get_all_cdl()
    RETURNS TABLE (
        codice INTEGER,
        nome TEXT,
        tipo INTEGER,
        descrizione TEXT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            cdl.codice,
            cdl.nome,
            cdl.tipo,
            cdl.descrizione
        FROM universal.corsi_di_laurea AS cdl
        ORDER BY nome;
    END;
$$;

-- RESTITUISCE LA CARRIERA DI UNO STUDENTE ( TUTTI GLI ESAMI FATTI NON DUPLICATI)
CREATE OR REPLACE FUNCTION universal.get_partial_carrer(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        data DATE,
        docente_responsabile TEXT,
        corso_di_laurea INTEGER,
        voto INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT DISTINCT ON (i.insegnamento)
            ins.nome,
            ins.descrizione,
            ins.anno,
            a.data,
            CONCAT(u.nome, ' ', u.cognome) AS docente_responsabile,
            ins.corso_di_laurea,
            i.voto
        FROM
            universal.iscritti i
            INNER JOIN universal.insegnamenti AS ins ON ins.codice = i.insegnamento
            INNER JOIN universal.appelli AS a ON i.appello = a.codice
            INNER JOIN universal.utenti AS u ON iNS.docente_responsabile = u.id
        WHERE
            i.studente = _id AND i.voto IS NOT NULL
        ORDER BY
            i.insegnamento,
            i.appello DESC;
    END;
$$;





