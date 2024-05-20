--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: universal; Type: SCHEMA; Schema: -; Owner: giacomo
--

CREATE SCHEMA universal;


ALTER SCHEMA universal OWNER TO giacomo;

--
-- Name: change_course_responsible_teacher(uuid, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.change_course_responsible_teacher(IN _id_nuovo_docente uuid, IN codice_insegnamento integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

    IF EXISTS (SELECT 1 FROM universal.insegnamenti AS ins WHERE ins.codice = codice_insegnamento AND ins.docente_responsabile = _id_nuovo_docente ) THEN
        RAISE EXCEPTION 'Sei già il responsabile di questo corso';
    end if;
    UPDATE universal.insegnamenti AS ins
    SET docente_responsabile = _id_nuovo_docente
    WHERE ins.codice = codice_insegnamento;
END;
$$;


ALTER PROCEDURE universal.change_course_responsible_teacher(IN _id_nuovo_docente uuid, IN codice_insegnamento integer) OWNER TO giacomo;

--
-- Name: change_password(uuid, character varying, character varying); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.change_password(IN _id_utente uuid, IN _vecchia_password character varying, IN _nuova_password character varying)
    LANGUAGE plpgsql
    AS $_$
DECLARE
    old_password VARCHAR(255);
    new_password VARCHAR(255);
BEGIN
    -- Ottieni la vecchia password crittografata dal database
    SELECT password INTO old_password
    FROM universal.utenti
    WHERE id = _id_utente;

    -- Verifica che la vecchia password sia corretta
    IF old_password IS NULL OR NOT crypt(_vecchia_password, old_password) = old_password THEN
        RAISE EXCEPTION 'La vecchia password non corrisponde.';
    END IF;

    -- Verifica che la nuova password soddisfi i vincoli prima della crittografia
    IF LENGTH(_nuova_password) != 8 OR NOT (_nuova_password ~ '[!@#$%^&*()-_+=]') THEN
        RAISE EXCEPTION 'La nuova password deve essere lunga 8 caratteri e contenere almeno un carattere speciale.';
    END IF;

    -- Crittografa la nuova password
    new_password := crypt(_nuova_password, gen_salt('bf'));

    -- Aggiorna la password nel database
    UPDATE universal.utenti
    SET password = new_password
    WHERE id = _id_utente;
END;
$_$;


ALTER PROCEDURE universal.change_password(IN _id_utente uuid, IN _vecchia_password character varying, IN _nuova_password character varying) OWNER TO giacomo;

--
-- Name: change_secretary_office(uuid, character varying); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.change_secretary_office(IN _id uuid, IN _nuova_sede character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

    UPDATE universal.segretari AS s
    SET sede = _nuova_sede
    WHERE s.id = _id;
END;
$$;


ALTER PROCEDURE universal.change_secretary_office(IN _id uuid, IN _nuova_sede character varying) OWNER TO giacomo;

--
-- Name: create_exam_session(uuid, date, character varying, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.create_exam_session(IN id_docente uuid, IN _data date, IN _luogo character varying, IN _insegnamento integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    responsabile uuid;
BEGIN
    -- Verifica che il docente sia il responsabile dell'insegnamento
    SELECT docente_responsabile INTO responsabile
    FROM universal.insegnamenti
    WHERE codice = _insegnamento;

    IF responsabile <> id_docente THEN
        RAISE EXCEPTION 'Non sei il responsabile di questo insegnamento';
    END IF;

    -- Verifica se la data è passata
    IF _data < CURRENT_DATE THEN
        RAISE EXCEPTION 'Non puoi creare un appello in una data passata.';
    END IF;

    -- Verifica se esiste già un appello nella stessa data e luogo
    IF EXISTS (SELECT 1 FROM universal.appelli WHERE data = _data AND luogo = _luogo) THEN
        RAISE EXCEPTION 'Esiste già un appello in quel giorno e luogo.';
    END IF;

    -- Crea l'appello
    INSERT INTO universal.appelli (data, luogo, insegnamento)
    VALUES (_data, _luogo, _insegnamento);
END;
$$;


ALTER PROCEDURE universal.create_exam_session(IN id_docente uuid, IN _data date, IN _luogo character varying, IN _insegnamento integer) OWNER TO giacomo;

--
-- Name: delete_exam_session(uuid, date, character varying, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.delete_exam_session(IN id_docente uuid, IN _data date, IN _luogo character varying, IN _insegnamento integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    responsabile uuid;
BEGIN
    -- Verifica che il docente sia il responsabile dell'insegnamento
    SELECT docente_responsabile INTO responsabile
    FROM universal.insegnamenti
    WHERE codice = _insegnamento;

    IF responsabile <> id_docente THEN
        RAISE EXCEPTION 'Non sei il responsabile di questo insegnamento';
    END IF;

    -- Verifica se esiste già un appello nella stessa data e luogo
    IF  NOT EXISTS (SELECT 1 FROM universal.appelli WHERE data = _data AND luogo = _luogo) THEN
        RAISE EXCEPTION 'NON esiste già un appello in quel giorno e luogo.';
    END IF;

    -- Cancella l'appello
    DELETE FROM universal.appelli AS a
    WHERE
        a.data = _data
      AND a.luogo = _luogo
      AND a.insegnamento = _insegnamento;
END;
$$;


ALTER PROCEDURE universal.delete_exam_session(IN id_docente uuid, IN _data date, IN _luogo character varying, IN _insegnamento integer) OWNER TO giacomo;

--
-- Name: delete_secretary(uuid); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.delete_secretary(IN _id uuid)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

    DELETE FROM universal.segretari AS s
    WHERE s.id = _id;
END;
$$;


ALTER PROCEDURE universal.delete_secretary(IN _id uuid) OWNER TO giacomo;

--
-- Name: delete_teacher(uuid); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.delete_teacher(IN _id uuid)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

    IF EXISTS (SELECT 1 FROM universal.insegnamenti AS ins WHERE ins.docente_responsabile = _id ) THEN
        RAISE EXCEPTION 'Il docente è responsabile di un corso';
    end if;

    DELETE FROM universal.docenti AS d
    WHERE d.id = _id;

END;
$$;


ALTER PROCEDURE universal.delete_teacher(IN _id uuid) OWNER TO giacomo;

--
-- Name: delete_utente(uuid); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.delete_utente(IN _id uuid)
    LANGUAGE plpgsql
    AS $$
DECLARE
    tipo_utente TipoUtente;
BEGIN
    -- Ottieni il tipo dell'utente
    SELECT tipo INTO tipo_utente
    FROM universal.utenti
    WHERE id = _id;

    -- Elimina l'utente in base al suo tipo
    CASE tipo_utente
        WHEN 'studente' THEN
            DELETE FROM universal.studenti WHERE id = _id;
        WHEN 'ex_studente' THEN
            DELETE FROM universal.ex_studenti WHERE id = _id;
        WHEN 'docente' THEN
            DELETE FROM universal.docenti WHERE id = _id;
        WHEN 'segretario' THEN
            DELETE FROM universal.segretari WHERE id = _id;
        ELSE
            RAISE EXCEPTION 'Tipo utente non valido';
    END CASE;
END;
$$;


ALTER PROCEDURE universal.delete_utente(IN _id uuid) OWNER TO giacomo;

--
-- Name: get_all_cdl(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_cdl() RETURNS TABLE(codice integer, nome text, tipo text, descrizione text)
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


ALTER FUNCTION universal.get_all_cdl() OWNER TO giacomo;

--
-- Name: get_all_exam_sessions(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_exam_sessions() RETURNS TABLE(codice integer, data date, luogo character varying, nome character varying, corso_di_laurea integer)
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


ALTER FUNCTION universal.get_all_exam_sessions() OWNER TO giacomo;

--
-- Name: get_all_exstudents(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_exstudents() RETURNS TABLE(id uuid, nome character varying, cognome character varying, email character varying, matricola integer)
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


ALTER FUNCTION universal.get_all_exstudents() OWNER TO giacomo;

--
-- Name: get_all_students(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_students() RETURNS TABLE(id uuid, nome character varying, cognome character varying, email character varying, matricola integer, corso_di_laurea text)
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
            COALESCE(cdl.nome, 'Non iscritto') AS corso_di_laurea
        FROM universal.utenti AS u
            INNER JOIN universal.studenti AS s ON s.id = u.id
            LEFT JOIN universal.corsi_di_laurea AS cdl ON s.corso_di_laurea = cdl.codice
        WHERE u.tipo = 'studente'
        ORDER BY u.nome;
    END;
$$;


ALTER FUNCTION universal.get_all_students() OWNER TO giacomo;

--
-- Name: get_all_students_of_cdl(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_students_of_cdl(codice_cdl integer) RETURNS TABLE(id uuid, nome character varying, cognome character varying, email character varying, matricola integer, cdl integer)
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


ALTER FUNCTION universal.get_all_students_of_cdl(codice_cdl integer) OWNER TO giacomo;

--
-- Name: get_all_students_of_cdl(integer, uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_students_of_cdl(codice_cdl integer, id_studente uuid) RETURNS TABLE(nome character varying, cognome character varying, email character varying, matricola integer, cdl text)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT
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
            s.corso_di_laurea =  codice_cdl AND s.id =  id_studente
        ORDER BY
            s.matricola;
    END;
$$;


ALTER FUNCTION universal.get_all_students_of_cdl(codice_cdl integer, id_studente uuid) OWNER TO giacomo;

--
-- Name: get_all_teachers(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_teachers() RETURNS TABLE(id uuid, nome character varying, cognome character varying, email character varying, ufficio character varying)
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


ALTER FUNCTION universal.get_all_teachers() OWNER TO giacomo;

--
-- Name: get_all_teachers_for_change_responsibility(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_teachers_for_change_responsibility(_id uuid) RETURNS TABLE(id uuid, nome character varying, cognome character varying, email character varying, ufficio character varying)
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


ALTER FUNCTION universal.get_all_teachers_for_change_responsibility(_id uuid) OWNER TO giacomo;

--
-- Name: get_all_teaching_appointments_for_student_degree(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_all_teaching_appointments_for_student_degree(_id uuid) RETURNS TABLE(codice integer, data date, luogo character varying, insegnamento character varying)
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


ALTER FUNCTION universal.get_all_teaching_appointments_for_student_degree(_id uuid) OWNER TO giacomo;

--
-- Name: get_degree_course(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_degree_course(_codice integer) RETURNS TABLE(nome text, tipo integer, descrizione text)
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


ALTER FUNCTION universal.get_degree_course(_codice integer) OWNER TO giacomo;

--
-- Name: get_degree_courses(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_degree_courses() RETURNS TABLE(codice integer, nome text, tipo integer, descrizione text)
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


ALTER FUNCTION universal.get_degree_courses() OWNER TO giacomo;

--
-- Name: get_email(character varying, character varying, public.tipoutente); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_email(nome character varying, cognome character varying, tipo public.tipoutente) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION universal.get_email(nome character varying, cognome character varying, tipo public.tipoutente) OWNER TO giacomo;

--
-- Name: get_ex_student(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_ex_student(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, email character varying, matricola integer, corso_di_laurea text)
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


ALTER FUNCTION universal.get_ex_student(_id uuid) OWNER TO giacomo;

--
-- Name: get_exam_enrollments(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_exam_enrollments(_codice integer) RETURNS TABLE(nome character varying, cognome character varying, _id uuid, email character varying, matricola integer, voto integer)
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


ALTER FUNCTION universal.get_exam_enrollments(_codice integer) OWNER TO giacomo;

--
-- Name: get_exam_sessions(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_exam_sessions(_codice integer) RETURNS TABLE(data date, luogo character varying, nome character varying, corso_di_laurea integer, codice_appello integer, id_docente uuid)
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


ALTER FUNCTION universal.get_exam_sessions(_codice integer) OWNER TO giacomo;

--
-- Name: get_exstudent_grades(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_exstudent_grades(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, matricola integer, insegnamento integer, voto integer, data date, corso_di_laurea integer)
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


ALTER FUNCTION universal.get_exstudent_grades(_id uuid) OWNER TO giacomo;

--
-- Name: get_grades(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_grades(_codice integer) RETURNS TABLE(nome character varying, cognome character varying, matricola integer, data date, voto integer)
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


ALTER FUNCTION universal.get_grades(_codice integer) OWNER TO giacomo;

--
-- Name: get_grades_of_ex_student(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_grades_of_ex_student(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, nome_insegnamento character varying, data date, voto integer)
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


ALTER FUNCTION universal.get_grades_of_ex_student(_id uuid) OWNER TO giacomo;

--
-- Name: get_grades_of_ex_students(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_grades_of_ex_students() RETURNS TABLE(nome character varying, cognome character varying, nome_insegnamento character varying, data date, voto integer)
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
            END ;
        $$;


ALTER FUNCTION universal.get_grades_of_ex_students() OWNER TO giacomo;

--
-- Name: get_id(character varying); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_id(_email character varying) RETURNS TABLE(id uuid)
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


ALTER FUNCTION universal.get_id(_email character varying) OWNER TO giacomo;

--
-- Name: get_missing_exams_for_graduation(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_missing_exams_for_graduation(_id uuid) RETURNS TABLE(nome character varying, descrizione text, anno integer, docente_responsabile text)
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


ALTER FUNCTION universal.get_missing_exams_for_graduation(_id uuid) OWNER TO giacomo;

--
-- Name: get_partial_carrer(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_partial_carrer(_id uuid) RETURNS TABLE(nome character varying, descrizione text, anno integer, data date, docente_responsabile text, corso_di_laurea integer, voto integer)
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


ALTER FUNCTION universal.get_partial_carrer(_id uuid) OWNER TO giacomo;

--
-- Name: get_propaedeutics(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_propaedeutics(codice_ins integer) RETURNS TABLE(nome character varying, descrizione text, anno integer, docente_responsabile text)
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


ALTER FUNCTION universal.get_propaedeutics(codice_ins integer) OWNER TO giacomo;

--
-- Name: get_secretaries(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_secretaries() RETURNS TABLE(id uuid, nome character varying, cognome character varying, email character varying, sede character varying)
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
                WHERE u.tipo = 'segretario'
                ORDER BY u.nome;
            END ;
        $$;


ALTER FUNCTION universal.get_secretaries() OWNER TO giacomo;

--
-- Name: get_secretaries(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_secretaries(_id uuid) RETURNS TABLE(id uuid, nome character varying, cognome character varying, email character varying, sede character varying)
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


ALTER FUNCTION universal.get_secretaries(_id uuid) OWNER TO giacomo;

--
-- Name: get_secretary(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_secretary(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, email character varying, sede character varying)
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


ALTER FUNCTION universal.get_secretary(_id uuid) OWNER TO giacomo;

--
-- Name: get_single_teaching(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_single_teaching(_codice integer) RETURNS TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile uuid, corso_di_laurea integer)
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
                WHERE i.codice = _codice
                ORDER BY codice;
            END ;
        $$;


ALTER FUNCTION universal.get_single_teaching(_codice integer) OWNER TO giacomo;

--
-- Name: get_student(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_student(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, email character varying, matricola integer, corso_di_laurea text)
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


ALTER FUNCTION universal.get_student(_id uuid) OWNER TO giacomo;

--
-- Name: get_student_average(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_student_average(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, matricola integer, media numeric)
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


ALTER FUNCTION universal.get_student_average(_id uuid) OWNER TO giacomo;

--
-- Name: get_student_exam_enrollments(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_student_exam_enrollments(_id uuid) RETURNS TABLE(codice integer, data date, luogo character varying, nome_insegnamento character varying)
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


ALTER FUNCTION universal.get_student_exam_enrollments(_id uuid) OWNER TO giacomo;

--
-- Name: get_student_grades(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_student_grades(_id uuid) RETURNS TABLE(nome character varying, descrizione text, anno integer, data date, docente_responsabile text, corso_di_laurea integer, voto integer)
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


ALTER FUNCTION universal.get_student_grades(_id uuid) OWNER TO giacomo;

--
-- Name: get_students_enrolled_in_teaching_appointments(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_students_enrolled_in_teaching_appointments(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, matricola integer, data date, luogo character varying, insegnamento integer)
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


ALTER FUNCTION universal.get_students_enrolled_in_teaching_appointments(_id uuid) OWNER TO giacomo;

--
-- Name: get_teacher(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_teacher(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, email character varying, ufficio character varying)
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


ALTER FUNCTION universal.get_teacher(_id uuid) OWNER TO giacomo;

--
-- Name: get_teacher_grades(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_teacher_grades(_id uuid) RETURNS TABLE(nome character varying, cognome character varying, matricola integer, data date, luogo character varying, insegnamento integer, voto integer)
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


ALTER FUNCTION universal.get_teacher_grades(_id uuid) OWNER TO giacomo;

--
-- Name: get_teaching(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_teaching() RETURNS TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile uuid, corso_di_laurea integer)
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


ALTER FUNCTION universal.get_teaching() OWNER TO giacomo;

--
-- Name: get_teaching_activity_of_professor(uuid); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_teaching_activity_of_professor(_id uuid) RETURNS TABLE(codice_insegnamento integer, nome character varying, descrizione text, anno integer, corso_di_laurea integer, nome_cdl text)
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


ALTER FUNCTION universal.get_teaching_activity_of_professor(_id uuid) OWNER TO giacomo;

--
-- Name: get_teaching_of_cdl(integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_teaching_of_cdl(_codice integer) RETURNS TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile text, id_responsabile uuid)
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


ALTER FUNCTION universal.get_teaching_of_cdl(_codice integer) OWNER TO giacomo;

--
-- Name: get_teaching_of_cdl_for_propaedeutics(integer, integer); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.get_teaching_of_cdl_for_propaedeutics(codice_cdl integer, codice_ins integer) RETURNS TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile text)
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


ALTER FUNCTION universal.get_teaching_of_cdl_for_propaedeutics(codice_cdl integer, codice_ins integer) OWNER TO giacomo;

--
-- Name: insert_degree_course(character varying, integer, text); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.insert_degree_course(IN _nome character varying, IN _tipo integer, IN _descrizione text)
    LANGUAGE plpgsql
    AS $$
BEGIN

    INSERT INTO universal.corsi_di_laurea(nome, tipo, descrizione)
    VALUES (_nome, _tipo, _descrizione);
END;
$$;


ALTER PROCEDURE universal.insert_degree_course(IN _nome character varying, IN _tipo integer, IN _descrizione text) OWNER TO giacomo;

--
-- Name: insert_exam_session(date, character varying, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.insert_exam_session(IN _data date, IN _luogo character varying, IN _insegnamento integer)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO universal.appelli(data, luogo, insegnamento)
            VALUES (_data, _luogo, _insegnamento);
        END;
    $$;


ALTER PROCEDURE universal.insert_exam_session(IN _data date, IN _luogo character varying, IN _insegnamento integer) OWNER TO giacomo;

--
-- Name: insert_grade(uuid, uuid, integer, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.insert_grade(IN _id_studente uuid, IN _id_docente uuid, IN codice_appello integer, IN _voto integer)
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
    WHERE studente = _id_studente AND appello = codice_appello AND voto = 0;
END;
$$;


ALTER PROCEDURE universal.insert_grade(IN _id_studente uuid, IN _id_docente uuid, IN codice_appello integer, IN _voto integer) OWNER TO giacomo;

--
-- Name: insert_propaedeutics(integer, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.insert_propaedeutics(IN codice_ins integer, IN codice_prop integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Controlla se l'insegnamento e la propedeuticità esistono
    IF EXISTS (SELECT 1 FROM universal.insegnamenti WHERE codice = codice_ins) AND
       EXISTS (SELECT 1 FROM universal.insegnamenti WHERE codice = codice_prop) THEN

        -- Controlla se la propedeuticità è già presente nella tabella propedeutico
        IF NOT EXISTS (SELECT 1 FROM universal.propedeutico WHERE insegnamento = codice_ins AND propedeuticità = codice_prop) THEN
            -- Inserisce le propedeuticità nella tabella propedeutico
            INSERT INTO universal.propedeutico (insegnamento, propedeuticità)
            VALUES (codice_ins, codice_prop);
        ELSE
            RAISE NOTICE 'La propedeuticità specificata è già presente per questo insegnamento.';
        END IF;

    ELSE
        RAISE EXCEPTION 'L''insegnamento o la propedeuticità specificati non esistono.';
    END IF;
END;
$$;


ALTER PROCEDURE universal.insert_propaedeutics(IN codice_ins integer, IN codice_prop integer) OWNER TO giacomo;

--
-- Name: insert_teaching(character varying, text, integer, uuid, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.insert_teaching(IN _nome character varying, IN _descrizione text, IN _anno integer, IN _responsabile uuid, IN _corso_di_laurea integer)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            INSERT INTO universal.insegnamenti(nome, descrizione, anno, docente_responsabile, corso_di_laurea)
            VALUES (_nome, _descrizione, _anno, _responsabile, _corso_di_laurea);
        END;
    $$;


ALTER PROCEDURE universal.insert_teaching(IN _nome character varying, IN _descrizione text, IN _anno integer, IN _responsabile uuid, IN _corso_di_laurea integer) OWNER TO giacomo;

--
-- Name: insert_utente(character varying, character varying, public.tipoutente, character varying); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.insert_utente(IN nome character varying, IN cognome character varying, IN tipo public.tipoutente, IN password character varying)
    LANGUAGE plpgsql
    AS $_$
DECLARE
    email VARCHAR(255);
    crypt_password VARCHAR(255);
BEGIN
    -- Verifica che la password soddisfi i vincoli prima della crittografia
    IF LENGTH(password) != 8 OR NOT (password ~ '.*[!@#$%^&*()-_+=].*') THEN
        RAISE EXCEPTION 'La password deve essere lunga 8 caratteri e contenere almeno un carattere speciale.';
    END IF;

    email := universal.get_email(nome, cognome, tipo);
    crypt_password := crypt(password, gen_salt('bf')); -- Utilizzo del metodo di crittografia Blowfish
    INSERT INTO universal.utenti (nome, cognome, tipo, email, password)
    VALUES (nome, cognome, tipo, email, crypt_password);
END;
$_$;


ALTER PROCEDURE universal.insert_utente(IN nome character varying, IN cognome character varying, IN tipo public.tipoutente, IN password character varying) OWNER TO giacomo;

--
-- Name: login(character varying, text); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.login(login_email character varying, login_password text) RETURNS TABLE(id uuid, tipo public.tipoutente)
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


ALTER FUNCTION universal.login(login_email character varying, login_password text) OWNER TO giacomo;

--
-- Name: studenttoexstudent(uuid, public.tipomotivo); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.studenttoexstudent(IN _id uuid, IN _motivo public.tipomotivo)
    LANGUAGE plpgsql
    AS $$
DECLARE
    matricola_ex_studente INTEGER;
    cdl INTEGER;
    new_email TEXT;
    old_email TEXT;
BEGIN
    SELECT matricola INTO matricola_ex_studente
    FROM universal.studenti
    WHERE id = _id;

    SELECT corso_di_laurea INTO cdl
    FROM universal.studenti
    WHERE id = _id;

    SELECT email into old_email
    FROM universal.utenti AS u
    WHERE u.id = _id;

    -- Costruisci il nuovo indirizzo email dell'ex studente
    new_email := REPLACE(old_email, '@studenti.', '@exstudenti.');

    -- Aggiorna il tipo dell'utente a 'ex_studente' e modifica l'email
    UPDATE universal.utenti
    SET tipo = 'ex_studente', email = new_email
    WHERE id = _id;

    -- Elimina la riga associata all'ex studente dalla tabella degli ex studenti
    DELETE FROM universal.ex_studenti
    WHERE id = _id;

    -- Inserisce i dati dell'ex studente nella tabella degli ex studenti
    INSERT INTO universal.ex_studenti (id, motivo, matricola, corso_di_laurea)
    VALUES (_id, _motivo, matricola_ex_studente, cdl);

    -- Rimuove lo studente dalla tabella studenti
    DELETE FROM universal.studenti
    WHERE id = _id;

END;
$$;


ALTER PROCEDURE universal.studenttoexstudent(IN _id uuid, IN _motivo public.tipomotivo) OWNER TO giacomo;

--
-- Name: subscribe_to_cdl(uuid, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.subscribe_to_cdl(IN id_studente uuid, IN codice_cdl integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se lo studente è iscritto al corso di laurea selezionato
    IF EXISTS (SELECT 1 FROM universal.studenti AS s WHERE s.corso_di_laurea = codice_cdl AND s.id = id_studente) THEN
        RAISE EXCEPTION 'sei gia iscritto al corso di laurea selezionato.';
    END IF;

    -- Iscrive lo studente al cdl selezionato
    UPDATE universal.studenti
    SET corso_di_laurea = codice_cdl
    WHERE id = id_studente;
END;
$$;


ALTER PROCEDURE universal.subscribe_to_cdl(IN id_studente uuid, IN codice_cdl integer) OWNER TO giacomo;

--
-- Name: subscription(uuid, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.subscription(IN _id uuid, IN _appello integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DECLARE
        codice_insegnamento INTEGER;
        data_appello DATE;
    BEGIN
        -- Ottieni l'insegnamento relativo all'appello specificato
        SELECT a.insegnamento, a.data INTO codice_insegnamento, data_appello
        FROM universal.appelli AS a
        WHERE a.codice = _appello;

        -- Controlla se la data dell'appello è diversa dalla data odierna
        IF data_appello = CURRENT_DATE THEN
            RAISE EXCEPTION 'Non è possibile iscriversi all''appello di oggi.';
        END IF;

        -- Inserisci l'iscrizione dello studente all'appello d'esame
        INSERT INTO universal.iscritti (appello, studente, insegnamento, voto)
        VALUES (_appello, _id, codice_insegnamento, 0);
    END;
END;
$$;


ALTER PROCEDURE universal.subscription(IN _id uuid, IN _appello integer) OWNER TO giacomo;

--
-- Name: subsribe_to_cdl(uuid, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.subsribe_to_cdl(IN _id_studente uuid, IN _codice integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE universal.studenti
    SET corso_di_laurea = _codice
    WHERE id = _id_studente;
END;
$$;


ALTER PROCEDURE universal.subsribe_to_cdl(IN _id_studente uuid, IN _codice integer) OWNER TO giacomo;

--
-- Name: trigger_delete_appello(); Type: FUNCTION; Schema: universal; Owner: giacomo
--

CREATE FUNCTION universal.trigger_delete_appello() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Cancella gli iscritti con voto null associati all'appello cancellato
    DELETE FROM universal.iscritti
    WHERE appello = OLD.codice AND voto IS NULL;

    RETURN OLD;
END;
$$;


ALTER FUNCTION universal.trigger_delete_appello() OWNER TO giacomo;

--
-- Name: unsubscribe_from_exam_appointment(uuid, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.unsubscribe_from_exam_appointment(IN id_studente uuid, IN codice_appello integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se lo studente è iscritto all'appello selezionato
    IF NOT EXISTS (SELECT 1 FROM universal.iscritti WHERE studente = id_studente AND appello = codice_appello) THEN
        RAISE EXCEPTION 'Non sei iscritto all''appello selezionato.';
    END IF;

    -- Elimina l'iscrizione dello studente all'appello
    DELETE FROM universal.iscritti WHERE studente = id_studente AND appello = codice_appello;
END;
$$;


ALTER PROCEDURE universal.unsubscribe_from_exam_appointment(IN id_studente uuid, IN codice_appello integer) OWNER TO giacomo;

--
-- Name: unsubscribe_to_cdl(uuid, integer); Type: PROCEDURE; Schema: universal; Owner: giacomo
--

CREATE PROCEDURE universal.unsubscribe_to_cdl(IN id_studente uuid, IN codice_cdl integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verifica se lo studente è iscritto al corso di laurea selezionato
    IF  NOT EXISTS (SELECT 1 FROM universal.studenti AS s WHERE s.corso_di_laurea = codice_cdl AND s.id = id_studente) THEN
        RAISE EXCEPTION 'non sei iscritto al corso di laurea selezionato.';
    END IF;
    -- disiscrive lo studente dal cdl selezionato
    UPDATE universal.studenti
    SET corso_di_laurea = NULL
    WHERE id = id_studente AND corso_di_laurea = codice_cdl;
END;
$$;


ALTER PROCEDURE universal.unsubscribe_to_cdl(IN id_studente uuid, IN codice_cdl integer) OWNER TO giacomo;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appelli; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.appelli (
    codice integer NOT NULL,
    data date NOT NULL,
    luogo character varying(40) NOT NULL,
    insegnamento integer NOT NULL
);


ALTER TABLE universal.appelli OWNER TO giacomo;

--
-- Name: appelli_codice_seq; Type: SEQUENCE; Schema: universal; Owner: giacomo
--

CREATE SEQUENCE universal.appelli_codice_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE universal.appelli_codice_seq OWNER TO giacomo;

--
-- Name: appelli_codice_seq; Type: SEQUENCE OWNED BY; Schema: universal; Owner: giacomo
--

ALTER SEQUENCE universal.appelli_codice_seq OWNED BY universal.appelli.codice;


--
-- Name: corsi_di_laurea; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.corsi_di_laurea (
    codice integer NOT NULL,
    nome text NOT NULL,
    tipo integer,
    descrizione text NOT NULL,
    CONSTRAINT corsi_di_laurea_nome_check CHECK ((nome !~ '[0-9]'::text)),
    CONSTRAINT corsi_di_laurea_tipo_check CHECK ((tipo = ANY (ARRAY[3, 5, 2])))
);


ALTER TABLE universal.corsi_di_laurea OWNER TO giacomo;

--
-- Name: corsi_di_laurea_codice_seq; Type: SEQUENCE; Schema: universal; Owner: giacomo
--

CREATE SEQUENCE universal.corsi_di_laurea_codice_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE universal.corsi_di_laurea_codice_seq OWNER TO giacomo;

--
-- Name: corsi_di_laurea_codice_seq; Type: SEQUENCE OWNED BY; Schema: universal; Owner: giacomo
--

ALTER SEQUENCE universal.corsi_di_laurea_codice_seq OWNED BY universal.corsi_di_laurea.codice;


--
-- Name: docenti; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.docenti (
    id uuid NOT NULL,
    ufficio character varying(100)
);


ALTER TABLE universal.docenti OWNER TO giacomo;

--
-- Name: ex_studenti; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.ex_studenti (
    id uuid NOT NULL,
    matricola integer NOT NULL,
    motivo public.tipomotivo NOT NULL,
    corso_di_laurea integer
);


ALTER TABLE universal.ex_studenti OWNER TO giacomo;

--
-- Name: insegnamenti; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.insegnamenti (
    codice integer NOT NULL,
    nome character varying(40) NOT NULL,
    descrizione text,
    anno integer,
    docente_responsabile uuid NOT NULL,
    corso_di_laurea integer NOT NULL,
    CONSTRAINT insegnamenti_anno_check CHECK (((anno >= 2000) AND (anno <= 2100))),
    CONSTRAINT insegnamenti_nome_check CHECK (((nome)::text !~ '[0-9]'::text))
);


ALTER TABLE universal.insegnamenti OWNER TO giacomo;

--
-- Name: insegnamenti_codice_seq; Type: SEQUENCE; Schema: universal; Owner: giacomo
--

CREATE SEQUENCE universal.insegnamenti_codice_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE universal.insegnamenti_codice_seq OWNER TO giacomo;

--
-- Name: insegnamenti_codice_seq; Type: SEQUENCE OWNED BY; Schema: universal; Owner: giacomo
--

ALTER SEQUENCE universal.insegnamenti_codice_seq OWNED BY universal.insegnamenti.codice;


--
-- Name: iscritti; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.iscritti (
    appello integer NOT NULL,
    studente uuid NOT NULL,
    insegnamento integer,
    voto integer NOT NULL,
    CONSTRAINT iscritti_voto_check CHECK (((voto >= 0) AND (voto <= 31)))
);


ALTER TABLE universal.iscritti OWNER TO giacomo;

--
-- Name: propedeutico; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.propedeutico (
    insegnamento integer NOT NULL,
    "propedeuticità" integer NOT NULL
);


ALTER TABLE universal.propedeutico OWNER TO giacomo;

--
-- Name: segretari; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.segretari (
    id uuid NOT NULL,
    sede character varying(40) DEFAULT 'sede_centrale'::character varying
);


ALTER TABLE universal.segretari OWNER TO giacomo;

--
-- Name: studenti; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.studenti (
    id uuid NOT NULL,
    matricola integer NOT NULL,
    corso_di_laurea integer
);


ALTER TABLE universal.studenti OWNER TO giacomo;

--
-- Name: utenti; Type: TABLE; Schema: universal; Owner: giacomo
--

CREATE TABLE universal.utenti (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nome character varying(40) NOT NULL,
    cognome character varying(40) NOT NULL,
    tipo public.tipoutente NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    CONSTRAINT utenti_cognome_check CHECK (((cognome)::text !~ '[0-9]'::text)),
    CONSTRAINT utenti_email_check CHECK (((email)::text <> ''::text)),
    CONSTRAINT utenti_nome_check CHECK (((nome)::text !~ '[0-9]'::text)),
    CONSTRAINT utenti_tipo_check CHECK ((tipo = ANY (ARRAY['studente'::public.tipoutente, 'docente'::public.tipoutente, 'segretario'::public.tipoutente, 'ex_studente'::public.tipoutente])))
);


ALTER TABLE universal.utenti OWNER TO giacomo;

--
-- Name: appelli codice; Type: DEFAULT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.appelli ALTER COLUMN codice SET DEFAULT nextval('universal.appelli_codice_seq'::regclass);


--
-- Name: corsi_di_laurea codice; Type: DEFAULT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.corsi_di_laurea ALTER COLUMN codice SET DEFAULT nextval('universal.corsi_di_laurea_codice_seq'::regclass);


--
-- Name: insegnamenti codice; Type: DEFAULT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.insegnamenti ALTER COLUMN codice SET DEFAULT nextval('universal.insegnamenti_codice_seq'::regclass);



--
-- Data for Name: utenti; Type: TABLE DATA; Schema: universal; Owner: giacomo
--

COPY universal.utenti (id, nome, cognome, tipo, email, password) FROM stdin;
3dec0064-701b-463a-9685-6578b4622c32	giacomo	comitani	segretario	giacomo.comitani@segretari.universal.it	$2a$06$wbkDHg2wTt8aILroCVbyVeDQsUkOHvcvltedFtyZA1I8agU27whxO
\.


--
-- Name: appelli_codice_seq; Type: SEQUENCE SET; Schema: universal; Owner: giacomo
--

SELECT pg_catalog.setval('universal.appelli_codice_seq', 40, true);


--
-- Name: corsi_di_laurea_codice_seq; Type: SEQUENCE SET; Schema: universal; Owner: giacomo
--

SELECT pg_catalog.setval('universal.corsi_di_laurea_codice_seq', 16, true);


--
-- Name: insegnamenti_codice_seq; Type: SEQUENCE SET; Schema: universal; Owner: giacomo
--

SELECT pg_catalog.setval('universal.insegnamenti_codice_seq', 15, true);


--
-- Name: appelli appelli_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.appelli
    ADD CONSTRAINT appelli_pkey PRIMARY KEY (codice);


--
-- Name: corsi_di_laurea corsi_di_laurea_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.corsi_di_laurea
    ADD CONSTRAINT corsi_di_laurea_pkey PRIMARY KEY (codice);


--
-- Name: docenti docenti_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.docenti
    ADD CONSTRAINT docenti_pkey PRIMARY KEY (id);


--
-- Name: ex_studenti ex_studenti_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.ex_studenti
    ADD CONSTRAINT ex_studenti_pkey PRIMARY KEY (id);


--
-- Name: insegnamenti insegnamenti_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.insegnamenti
    ADD CONSTRAINT insegnamenti_pkey PRIMARY KEY (codice);


--
-- Name: iscritti iscritti_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.iscritti
    ADD CONSTRAINT iscritti_pkey PRIMARY KEY (appello, studente, voto);


--
-- Name: propedeutico propedeutico_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.propedeutico
    ADD CONSTRAINT propedeutico_pkey PRIMARY KEY (insegnamento, "propedeuticità");


--
-- Name: segretari segretari_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.segretari
    ADD CONSTRAINT segretari_pkey PRIMARY KEY (id);


--
-- Name: studenti studenti_matricola_key; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.studenti
    ADD CONSTRAINT studenti_matricola_key UNIQUE (matricola);


--
-- Name: studenti studenti_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.studenti
    ADD CONSTRAINT studenti_pkey PRIMARY KEY (id);


--
-- Name: utenti utenti_pkey; Type: CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.utenti
    ADD CONSTRAINT utenti_pkey PRIMARY KEY (id);


--
-- Name: utenti aggiorna_tabella_trigger; Type: TRIGGER; Schema: universal; Owner: giacomo
--

CREATE TRIGGER aggiorna_tabella_trigger AFTER INSERT ON universal.utenti FOR EACH ROW EXECUTE FUNCTION public.aggiorna_tabella();


--
-- Name: propedeutico check_non_cyclic_prerequisites; Type: TRIGGER; Schema: universal; Owner: giacomo
--

CREATE TRIGGER check_non_cyclic_prerequisites BEFORE INSERT ON universal.propedeutico FOR EACH ROW EXECUTE FUNCTION public.non_cyclic_prerequisites_check();


--
-- Name: studenti check_subscription_to_cdl_trigger; Type: TRIGGER; Schema: universal; Owner: giacomo
--

CREATE TRIGGER check_subscription_to_cdl_trigger BEFORE INSERT OR UPDATE OF corso_di_laurea ON universal.studenti FOR EACH ROW EXECUTE FUNCTION public.check_subscription_to_cdl();


--
-- Name: docenti elimina_utente_dopo_cancellazione_trigger; Type: TRIGGER; Schema: universal; Owner: giacomo
--

CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger AFTER DELETE ON universal.docenti FOR EACH ROW EXECUTE FUNCTION public.elimina_utente_dopo_cancellazione();


--
-- Name: segretari elimina_utente_dopo_cancellazione_trigger; Type: TRIGGER; Schema: universal; Owner: giacomo
--

CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger AFTER DELETE ON universal.segretari FOR EACH ROW EXECUTE FUNCTION public.elimina_utente_dopo_cancellazione();


--
-- Name: insegnamenti enforce_instructor_course_limit; Type: TRIGGER; Schema: universal; Owner: giacomo
--

CREATE TRIGGER enforce_instructor_course_limit BEFORE INSERT ON universal.insegnamenti FOR EACH ROW EXECUTE FUNCTION public.check_instructor_course_limit();


--
-- Name: appelli enforce_unique_sessions_per_day; Type: TRIGGER; Schema: universal; Owner: giacomo
--

CREATE TRIGGER enforce_unique_sessions_per_day BEFORE INSERT ON universal.appelli FOR EACH ROW EXECUTE FUNCTION public.check_number_of_session();


--
-- Name: docenti docenti_id_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.docenti
    ADD CONSTRAINT docenti_id_fkey FOREIGN KEY (id) REFERENCES universal.utenti(id);


--
-- Name: ex_studenti ex_studenti_corso_di_laurea_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.ex_studenti
    ADD CONSTRAINT ex_studenti_corso_di_laurea_fkey FOREIGN KEY (corso_di_laurea) REFERENCES universal.corsi_di_laurea(codice) ON UPDATE CASCADE;


--
-- Name: ex_studenti ex_studenti_id_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.ex_studenti
    ADD CONSTRAINT ex_studenti_id_fkey FOREIGN KEY (id) REFERENCES universal.utenti(id);


--
-- Name: insegnamenti insegnamenti_corso_di_laurea_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.insegnamenti
    ADD CONSTRAINT insegnamenti_corso_di_laurea_fkey FOREIGN KEY (corso_di_laurea) REFERENCES universal.corsi_di_laurea(codice) ON UPDATE CASCADE;


--
-- Name: insegnamenti insegnamenti_docente_responsabile_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.insegnamenti
    ADD CONSTRAINT insegnamenti_docente_responsabile_fkey FOREIGN KEY (docente_responsabile) REFERENCES universal.docenti(id);


--
-- Name: iscritti iscritti_appello_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.iscritti
    ADD CONSTRAINT iscritti_appello_fkey FOREIGN KEY (appello) REFERENCES universal.appelli(codice);


--
-- Name: iscritti iscritti_studente_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.iscritti
    ADD CONSTRAINT iscritti_studente_fkey FOREIGN KEY (studente) REFERENCES universal.utenti(id);


--
-- Name: propedeutico propedeutico_insegnamento_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.propedeutico
    ADD CONSTRAINT propedeutico_insegnamento_fkey FOREIGN KEY (insegnamento) REFERENCES universal.insegnamenti(codice);


--
-- Name: propedeutico propedeutico_propedeuticità_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.propedeutico
    ADD CONSTRAINT "propedeutico_propedeuticità_fkey" FOREIGN KEY ("propedeuticità") REFERENCES universal.insegnamenti(codice);


--
-- Name: segretari segretari_id_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.segretari
    ADD CONSTRAINT segretari_id_fkey FOREIGN KEY (id) REFERENCES universal.utenti(id);


--
-- Name: studenti studenti_corso_di_laurea_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.studenti
    ADD CONSTRAINT studenti_corso_di_laurea_fkey FOREIGN KEY (corso_di_laurea) REFERENCES universal.corsi_di_laurea(codice) ON UPDATE CASCADE;


--
-- Name: studenti studenti_id_fkey; Type: FK CONSTRAINT; Schema: universal; Owner: giacomo
--

ALTER TABLE ONLY universal.studenti
    ADD CONSTRAINT studenti_id_fkey FOREIGN KEY (id) REFERENCES universal.utenti(id);


--
-- PostgreSQL database dump complete
--

