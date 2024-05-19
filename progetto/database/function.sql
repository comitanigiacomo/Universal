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
--ok
CREATE OR REPLACE FUNCTION universal.get_all_students()
    RETURNS TABLE (
        id uuid,
        nome VARCHAR(255),
        cognome VARCHAR(255),
        email VARCHAR(255),
        matricola INTEGER,
        corso_di_laurea TEXT
    )
AS $$
    BEGIN
        RETURN QUERY
        SELECT
            u.id,
            u.nome,
            u.cognome,
            u.email,
            s.matricola,
            COALESCE(cdl.nome, 'Non iscritto') AS corso_di_laurea
        FROM universal.utenti AS u
            INNER JOIN universal.studenti AS s ON s.id = u.id
            LEFT JOIN universal.corsi_di_laurea AS cdl ON s.corso_di_laurea = cdl.codice
        WHERE u.tipo = 'studente'
        ORDER BY u.nome;
    END;
$$ LANGUAGE plpgsql;


-- GENERA IL NUMERO DI MATRICOLA
    CREATE OR REPLACE FUNCTION genera_matricola()
    RETURNS INTEGER AS $$
    DECLARE
        nuova_matricola INTEGER;
    BEGIN
        SELECT nextval('matricola_sequence') INTO nuova_matricola;
        RETURN nuova_matricola;
    END;
$$ LANGUAGE plpgsql;
--ok
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
--ok
--RESTITUISCE TUTTI I DOCENTI
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

--RESTITUISCE TUTTI I DOCENTI PER IL CAMBIO DELLA RESPONSABILITÀ DEL CORSO
    CREATE OR REPLACE FUNCTION universal.get_all_teachers_for_change_responsibility(_id uuid)
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
                WHERE u.tipo = 'docente' AND u.id != _id
                ORDER BY u.nome;
            END ;
        $$;


-- RESTITUISCE L'ID DELLO STUDENTE A PARTIRE DAI DATI DI AUTENTICAZIONE
--ok
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
--ok
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
-- ok
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
--ok
       CREATE OR REPLACE FUNCTION universal.get_ex_student(_id uuid)
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
                    ex.matricola,
                    cdl.nome
                FROM universal.utenti AS u
                    INNER JOIN universal.ex_studenti AS ex ON _id = ex.id
                    INNER JOIN universal.corsi_di_laurea AS cdl ON ex.corso_di_laurea = cdl.codice
                WHERE u.id = _id;
            END ;
        $$;



-- RESTITUISCE TUTTI I SEGRETARI DISPONIBILI
--ok
    CREATE OR REPLACE FUNCTION universal.get_secretaries(_id uuid)
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
                WHERE u.tipo = 'segretario' AND u.id  != _id
                ORDER BY u.nome;
            END ;
        $$;

-- RESTITUISCE UN SEGERETARIO DATO IL SUO ID
--ok
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

-- GENERA UNA NUOVA EMAIL
-- IN CASO DI OMONIMIA MODIFICA LA MAIL E AGGIUNGE UN SUFFISSO ALLA FINE INCREMENTALE
--ok
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

-- RESTITUISCE TUTTI GLI INSEGNAMENTI PER UN CORSO DI LAUREA
-- ok
 CREATE OR REPLACE FUNCTION universal.get_teaching_of_cdl(_codice INTEGER)
    RETURNS TABLE (
        codice INTEGER,
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        responsabile TEXT,
        id_responsabile uuid
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
            CONCAT(u.nome, ' ', u.cognome) AS responsabile,
            u.id
        FROM
            universal.insegnamenti AS ins
        INNER JOIN
            universal.utenti AS u ON ins.docente_responsabile = u.id
        WHERE
            ins.corso_di_laurea = _codice
        ORDER BY
            ins.codice;
    END;
$$;


-- RESTITUISCE TUTTI GLI APPELLI DI UN INSEGNAMENTO
--ok
CREATE OR REPLACE FUNCTION universal.get_exam_sessions(_codice INTEGER)
        RETURNS TABLE (
            data DATE,
            luogo VARCHAR(40),
            nome VARCHAR(40),
            corso_di_laurea INTEGER,
            codice_appello INTEGER,
            id_docente uuid
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    a.data,
                    a.luogo,
                    i.nome,
                    i.corso_di_laurea,
                    a.codice,
                    d.id
                FROM universal.appelli AS a
                    INNER JOIN universal.insegnamenti AS i ON a.insegnamento = i.codice
                    INNER JOIN universal.docenti AS d ON i.docente_responsabile = d.id

                WHERE i.codice = _codice
                ORDER BY data;
            END ;
        $$;

-- RESTITUISCE TUTTI GLI APPELLI ESISTENTI
--ok
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
--ok
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
                WHERE u.id = _id AND i.voto = 0
                ORDER BY data;
            END ;
        $$;
-- RESTITUISCE TUTTE LE ISCRIZIONI AD UN  APPELLO D'ESAME
-- FUNZIONALITÀ DOCENTE CHE USO PER INSERIRE ANCHE VALUTAZIONI, QUINDI  RITORNO SOLO QUELLI CON VALUTAZIONE PENDENTE
--ok
CREATE OR REPLACE FUNCTION universal.get_exam_enrollments(_codice INTEGER)
        RETURNS TABLE (
            nome VARCHAR(40),
            cognome VARCHAR(40),
            _id uuid,
            email VARCHAR(255),
            matricola INTEGER,
            voto INTEGER
        )
        LANGUAGE plpgsql
        AS $$
            BEGIN
                RETURN QUERY
                SELECT
                    u.nome,
                    u.cognome,
                    u.id,
                    u.email,
                    s.matricola,
                    i.voto
                FROM universal.iscritti AS i
                    INNER JOIN universal.appelli AS a ON i.appello = a.codice
                    INNER JOIN universal.studenti AS s ON i.studente = s.id
                    INNER JOIN universal.utenti AS u ON s.id = u.id
                WHERE i.appello = _codice AND i.voto = 0
                ORDER BY matricola;
            END ;
        $$;

-- RESTITUISCE ESAMI MANCANTI ALLA LAUREA ( STUDENTI  ISCRITTI )
-- Uno studente quando passa un esame ha una voce in iscritti con un voto. tutti i voti rimangono quindi in iscritti fino a quando lo studente non diventa ex studente
--ok
CREATE OR REPLACE FUNCTION universal.get_missing_exams_for_graduation(_id uuid)
    RETURNS TABLE (
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        docente_responsabile TEXT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            ins.nome,
            ins.descrizione,
            ins.anno,
            CONCAT(u.nome, ' ', u.cognome) AS docente_responsabile
        FROM universal.insegnamenti AS ins
        INNER JOIN universal.corsi_di_laurea AS cdl ON ins.corso_di_laurea = cdl.codice
        INNER JOIN universal.docenti AS d ON ins.docente_responsabile = d.id
        INNER JOIN universal.utenti AS u ON d.id = u.id
        WHERE ins.codice NOT IN (
            SELECT isc.insegnamento
            FROM universal.iscritti AS isc
            WHERE isc.studente = _id and isc.voto >= 18
        )
        AND cdl.codice = (SELECT corso_di_laurea FROM universal.studenti WHERE id = _id)
        ORDER BY ins.nome;
    END;
$$;


-- RESTITUISCE INSEGNAMENTI DI DI CUI UN DOCENTE E' RESPONSABILE
--ok
CREATE OR REPLACE FUNCTION universal.get_teaching_activity_of_professor(_id uuid)
    RETURNS TABLE (
        codice_insegnamento INTEGER,
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        corso_di_laurea INTEGER,
        nome_cdl TEXT
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
            cdl.codice,
            cdl.nome
        FROM universal.insegnamenti AS ins
            INNER JOIN universal.corsi_di_laurea AS cdl ON ins.corso_di_laurea = cdl.codice
        WHERE _id = ins.docente_responsabile
        ORDER BY ins.codice;
    END;
$$;

-- RESTITUISCE TUTTE LE VALUAZIONI CHE UN DOCENTE HA DATO
--ok
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
            INNER JOIN universal.studenti AS s ON i.studente = s.id
            INNER JOIN universal.appelli AS a ON i.appello = a.codice
        WHERE
            i.voto != 0 AND  ins.docente_responsabile = _id -- Filtra solo gli insegnamenti di cui il docente è responsabile
            AND ins.docente_responsabile = _id -- Aggiungi questa condizione per filtrare solo gli insegnamenti del docente attualmente loggato
        ORDER BY matricola;
    END;
$$;

-- RESTITUISCE GLI APPELLI DI TUTTI GLI INSEGNAMENTI DEL CORSO DI LAUREA DI UNO STUDENTE
--ok
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
            ins.nome AS insegnamento
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
--ok
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
        WHERE i.voto != 0 and i.studente = _id
        ORDER BY data;
    END;
$$;

-- RESTITUISCE MEDIA VALUTAZIONI DI UNO STUDENTE
--ok
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

-- RESTITUISCE TUTTI I CORSI DI LAUREA PRESENTI
--ok
CREATE OR REPLACE FUNCTION universal.get_all_cdl()
    RETURNS TABLE (
        codice INTEGER,
        nome TEXT,
        tipo TEXT,
        descrizione TEXT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            cdl.codice,
            cdl.nome,
            CASE cdl.tipo
                WHEN 2 THEN 'magistrale'
                WHEN 3 THEN 'triennale'
                WHEN 5 THEN 'ciclo unico'
                ELSE 'Altro'
            END AS tipo,
            cdl.descrizione
        FROM universal.corsi_di_laurea AS cdl
        ORDER BY nome;
    END;
$$;


-- RESTITUISCE LA CARRIERA DI UNO STUDENTE ( TUTTI GLI ESAMI FATTI NON DUPLICATI)
--ok
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
            i.studente = _id AND i.voto != 0
        ORDER BY
            i.insegnamento,
            i.appello DESC;
    END;
$$;

CREATE OR REPLACE FUNCTION universal.get_propaedeutics(codice_ins INTEGER)
    RETURNS TABLE (
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        docente_responsabile TEXT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            ins.nome,
            ins.descrizione,
            ins.anno,
            CONCAT(u.nome,' ',u.cognome) AS responsabile
        FROM
            universal.propedeutico AS p
        INNER JOIN universal.insegnamenti AS ins ON p.propedeuticità = ins.codice
        INNER JOIN universal.utenti AS u ON ins.docente_responsabile = u.id
        WHERE
            p.insegnamento = codice_ins;
    END;
$$;

--ok
 CREATE OR REPLACE FUNCTION universal.get_teaching_of_cdl_for_propaedeutics(
        codice_cdl INTEGER,
        codice_ins INTEGER
        )
    RETURNS TABLE (
        codice INTEGER,
        nome VARCHAR(40),
        descrizione TEXT,
        anno INTEGER,
        responsabile TEXT
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
            CONCAT(u.nome, ' ', u.cognome) AS responsabile
        FROM
            universal.insegnamenti AS ins
        INNER JOIN
            universal.utenti AS u ON ins.docente_responsabile = u.id
        WHERE
            ins.corso_di_laurea = codice_cdl AND ins.codice != codice_ins
        ORDER BY
            ins.codice;
    END;
$$;

--ok
CREATE OR REPLACE FUNCTION universal.get_all_students_of_cdl(
        codice_cdl INTEGER
        )
    RETURNS TABLE (
        id uuid,
        nome VARCHAR(40),
        cognome VARCHAR(40),
        email VARCHAR(255),
        matricola INTEGER,
        cdl INTEGER
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
            s.id,
            u.nome,
            u.cognome,
            u.email,
            s.matricola,
            s.corso_di_laurea
        FROM
            universal.studenti AS s
        INNER JOIN
            universal.utenti AS u ON s.id = u.id
        WHERE
            s.corso_di_laurea =  codice_cdl
        ORDER BY
            s.matricola;
    END;
$$;