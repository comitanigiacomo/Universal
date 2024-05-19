-- TRIGGER

-- AGGIORNA LA TABELLA CORRISPONDENTE IN BASE AL TIPO DELL'UTENTE CREATO NELLA TABELLA UTENTI

CREATE OR REPLACE FUNCTION aggiorna_tabella()
RETURNS TRIGGER AS $$
DECLARE
    new_matricola INTEGER;
BEGIN
    IF NEW.tipo = 'studente' THEN
        new_matricola := genera_matricola();
        INSERT INTO universal.studenti (id, matricola, corso_di_laurea)
        VALUES (NEW.id, new_matricola,NULL);
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

CREATE TRIGGER aggiorna_tabella_trigger
AFTER INSERT ON universal.utenti
FOR EACH ROW
EXECUTE FUNCTION aggiorna_tabella();

-- ELIMINA IL DOCENTE, L'EX STUDENTE O IL SEGRETARIO, E L'UTENTE CORRISPONDENTE
CREATE OR REPLACE FUNCTION elimina_utente_dopo_cancellazione()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM universal.utenti WHERE id = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger
AFTER DELETE ON universal.studenti
FOR EACH ROW
EXECUTE FUNCTION elimina_utente_dopo_cancellazione();

CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger
AFTER DELETE ON universal.ex_studenti
FOR EACH ROW
EXECUTE FUNCTION elimina_utente_dopo_cancellazione();

CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger
AFTER DELETE ON universal.segretari
FOR EACH ROW
EXECUTE FUNCTION elimina_utente_dopo_cancellazione();

CREATE TRIGGER elimina_utente_dopo_cancellazione_trigger
AFTER DELETE ON universal.docenti
FOR EACH ROW
EXECUTE FUNCTION elimina_utente_dopo_cancellazione();

-- CONTROLLA CHE UN DOCENTE NON SIA RESPONSABILE DI PIU DI 3 CORSI
CREATE OR REPLACE FUNCTION check_number_of_session()
RETURNS TRIGGER AS $$
DECLARE
    corso_di_laurea_id INTEGER;
    data_appello DATE;
    count_sessions INTEGER;
BEGIN
    -- Ottieni il corso di laurea del corso associato all'appello
    SELECT corso_di_laurea INTO corso_di_laurea_id
    FROM universal.insegnamenti
    WHERE codice = NEW.insegnamento;

    -- Ottieni la data dell'appello
    SELECT data INTO data_appello
    FROM universal.appelli
    WHERE codice = NEW.codice;

    -- Conta il numero di appelli nella stessa data per lo stesso corso di laurea
    SELECT COUNT(*)
    INTO count_sessions
    FROM universal.appelli AS a
    JOIN universal.insegnamenti AS i ON a.insegnamento = i.codice
    WHERE i.corso_di_laurea = corso_di_laurea_id
    AND a.data = data_appello;

    -- Se ci sono già appelli nella stessa data per lo stesso corso di laurea, solleva un'eccezione
    IF count_sessions > 1 THEN
        RAISE EXCEPTION 'Sono già presenti % appelli per il corso di laurea nella stessa data.', count_sessions;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER enforce_unique_sessions_per_day
BEFORE INSERT ON universal.appelli
FOR EACH ROW
EXECUTE FUNCTION check_number_of_session();

-- CONTROLLA CHE UNO STUDENTE NON SIA GIA ISCRITTO AD UN CORSO DI LAUREA
CREATE OR REPLACE FUNCTION check_subscription_to_cdl()
RETURNS TRIGGER AS $$
BEGIN
    -- Controlla se lo studente è già iscritto a un corso di laurea
    IF EXISTS (SELECT 1 FROM universal.studenti WHERE id = NEW.id AND corso_di_laurea IS NOT NULL) THEN
        RAISE EXCEPTION 'Lo studente è già iscritto a un corso di laurea.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER check_subscription_to_cdl_trigger
BEFORE INSERT OR UPDATE OF corso_di_laurea ON universal.studenti
FOR EACH ROW
EXECUTE FUNCTION check_subscription_to_cdl();

CREATE OR REPLACE FUNCTION non_cyclic_prerequisites_check()
RETURNS TRIGGER AS $$
DECLARE
    current_insegnamento_id INTEGER;
    propedeuticita_id INTEGER;
    is_cyclic BOOLEAN := FALSE;
BEGIN
    current_insegnamento_id := NEW.insegnamento;
    propedeuticita_id := NEW.propedeuticità;

    -- Verifica ricorsiva delle propedeuticità per rilevare ciclicità
    WHILE propedeuticita_id IS NOT NULL AND NOT is_cyclic LOOP
        IF current_insegnamento_id = propedeuticita_id THEN
            is_cyclic := TRUE;
        END IF;

        SELECT propedeuticità INTO propedeuticita_id
        FROM universal.propedeutico
        WHERE insegnamento = propedeuticita_id;
    END LOOP;

    IF is_cyclic THEN
        RAISE EXCEPTION 'Ciclicità rilevata tra le propedeuticità.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER check_non_cyclic_prerequisites
BEFORE INSERT ON universal.propedeutico
FOR EACH ROW
EXECUTE FUNCTION non_cyclic_prerequisites_check();


-- CONTROLLA CHE NON CI SIANO PIU APPELLI IN UNA STESSA GIORNATA DI UN CORSO DI LAUREA

CREATE OR REPLACE FUNCTION check_number_of_session()
RETURNS TRIGGER AS $$
DECLARE
    corso_di_laurea_id INTEGER;
    data_appello DATE;
    count_sessions INTEGER;
BEGIN
    -- Ottieni il corso di laurea del corso associato all'appello
    SELECT corso_di_laurea INTO corso_di_laurea_id
    FROM universal.insegnamenti
    WHERE codice = NEW.insegnamento;

    -- Ottieni la data dell'appello
    SELECT data INTO data_appello
    FROM universal.appelli
    WHERE codice = NEW.codice;

    -- Conta il numero di appelli nella stessa data per lo stesso corso di laurea
    SELECT COUNT(*)
    INTO count_sessions
    FROM universal.appelli AS a
    JOIN universal.insegnamenti AS i ON a.insegnamento = i.codice
    WHERE i.corso_di_laurea = corso_di_laurea_id
    AND a.data = data_appello;

    -- Se ci sono già appelli nella stessa data per lo stesso corso di laurea, solleva un'eccezione
    IF count_sessions > 1 THEN
        RAISE EXCEPTION 'Sono già presenti % appelli per il corso di laurea nella stessa data.', count_sessions;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER enforce_unique_sessions_per_day
BEFORE INSERT ON universal.appelli
FOR EACH ROW
EXECUTE FUNCTION check_number_of_session();

-- CONTROLLA CHE UN INSEGNAMENTO ALLA SUA CREAZIONE ABBIA UN DOCENTE CHE NON SIA GIA RESPONSABILE DI PIU DI 3 CORSI

CREATE OR REPLACE FUNCTION check_instructor_course_limit()
RETURNS TRIGGER AS $$
DECLARE
    instructor_id uuid;
    course_count INTEGER;
BEGIN
    -- Ottieni l'ID del docente responsabile dell'insegnamento
    instructor_id := NEW.docente_responsabile;

    -- Conta il numero di corsi di cui il docente è responsabile
    SELECT COUNT(*)
    INTO course_count
    FROM universal.insegnamenti
    WHERE docente_responsabile = instructor_id;

    -- Se il docente è già responsabile di più di 3 corsi, solleva un'eccezione
    IF course_count >= 3 THEN
        RAISE EXCEPTION 'Il docente è già responsabile di più di 3 corsi.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creazione del trigger
CREATE TRIGGER enforce_instructor_course_limit
BEFORE INSERT ON universal.insegnamenti
FOR EACH ROW
EXECUTE FUNCTION check_instructor_course_limit();


-- CONTROLLA CHE L'ISCRIZIONE DI UNO STUDENTE AD UN APPELLO RISPETTI LE PROPEDEUTICITÀ
CREATE OR REPLACE FUNCTION check_prerequisites_before_enrollment()
RETURNS TRIGGER AS $$
DECLARE
    prereq_count INTEGER;
BEGIN
    -- Controlla se ci sono insegnamenti correlati all'appello che richiedono propedeuticità
    SELECT COUNT(*) INTO prereq_count
    FROM universal.propedeutico p
    WHERE p.insegnamento = NEW.insegnamento;

    -- Se ci sono propedeuticità richieste
    IF prereq_count > 0 THEN
        -- Controlla se lo studente soddisfa le propedeuticità necessarie
        SELECT COUNT(*) INTO prereq_count
        FROM universal.propedeutico p
        WHERE p.insegnamento = NEW.insegnamento
        AND p.propedeuticità NOT IN (
            SELECT i.insegnamento
            FROM universal.iscritti i
            WHERE i.studente = NEW.studente
        );

        -- Se lo studente non soddisfa le propedeuticità richieste, genera un errore
        IF prereq_count > 0 THEN
            RAISE EXCEPTION 'Lo studente non soddisfa le propedeuticità necessarie per questo appello.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_enrollment_check_prerequisites
BEFORE INSERT ON universal.iscritti
FOR EACH ROW
EXECUTE FUNCTION check_prerequisites_before_enrollment();


