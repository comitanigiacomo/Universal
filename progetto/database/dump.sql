create table docenti
(
    id      uuid not null
        primary key,
    ufficio varchar(100)
);

alter table docenti
    owner to giacomo;

create trigger elimina_utente_dopo_cancellazione_trigger
    after delete
    on docenti
    for each row
execute procedure public.elimina_utente_dopo_cancellazione();

create table segretari
(
    id   uuid not null
        primary key,
    sede varchar(40) default 'sede_centrale'::character varying
);

alter table segretari
    owner to giacomo;

create trigger elimina_utente_dopo_cancellazione_trigger
    after delete
    on segretari
    for each row
execute procedure public.elimina_utente_dopo_cancellazione();

create table utenti
(
    id       uuid default gen_random_uuid() not null
        primary key,
    nome     varchar(40)                    not null
        constraint utenti_nome_check
            check ((nome)::text !~ '[0-9]'::text),
    cognome  varchar(40)                    not null
        constraint utenti_cognome_check
            check ((cognome)::text !~ '[0-9]'::text),
    tipo     tipoutente                     not null
        constraint utenti_tipo_check
            check (tipo = ANY
                   (ARRAY ['studente'::tipoutente, 'docente'::tipoutente, 'segretario'::tipoutente, 'ex_studente'::tipoutente])),
    email    varchar(255)                   not null
        constraint utenti_email_check
            check ((email)::text <> ''::text),
    password text                           not null
);

alter table utenti
    owner to giacomo;

create trigger aggiorna_tabella_trigger
    after insert
    on utenti
    for each row
execute procedure public.aggiorna_tabella();

create table corsi_di_laurea
(
    codice      serial
        primary key,
    nome        text not null
        constraint corsi_di_laurea_nome_check
            check (nome !~ '[0-9]'::text),
    tipo        integer
        constraint corsi_di_laurea_tipo_check
            check (tipo = ANY (ARRAY [3, 5, 2])),
    descrizione text not null
);

alter table corsi_di_laurea
    owner to giacomo;

create table ex_studenti
(
    id              uuid       not null
        primary key
        references utenti,
    matricola       integer    not null,
    motivo          tipomotivo not null,
    corso_di_laurea integer
        references corsi_di_laurea
            on update cascade
);

alter table ex_studenti
    owner to giacomo;

create table insegnamenti
(
    codice               serial
        primary key,
    nome                 varchar(40) not null
        constraint insegnamenti_nome_check
            check ((nome)::text !~ '[0-9]'::text),
    descrizione          text,
    anno                 integer
        constraint insegnamenti_anno_check
            check ((anno >= 2000) AND (anno <= 2100)),
    docente_responsabile uuid        not null
        references docenti,
    corso_di_laurea      integer     not null
        references corsi_di_laurea
            on update cascade
);

alter table insegnamenti
    owner to giacomo;

create table appelli
(
    codice       serial
        primary key,
    data         date        not null,
    luogo        varchar(40) not null,
    insegnamento integer     not null
        references insegnamenti
            on update cascade
);

alter table appelli
    owner to giacomo;

create trigger enforce_unique_sessions_per_day
    before insert
    on appelli
    for each row
execute procedure public.check_number_of_session();

create table studenti
(
    id              uuid    not null
        primary key
        references utenti,
    matricola       integer not null
        unique,
    corso_di_laurea integer
        references corsi_di_laurea
            on update cascade
);

alter table studenti
    owner to giacomo;

create trigger check_subscription_trigger
    before insert
    on studenti
    for each row
execute procedure public.check_subscription_to_cdl();

create table iscritti
(
    appello      integer not null
        references appelli,
    studente     uuid    not null
        references utenti,
    insegnamento integer,
    voto         integer
        constraint iscritti_voto_check
            check ((voto >= 0) AND (voto <= 31)),
    primary key (appello, studente)
);

alter table iscritti
    owner to giacomo;

create table propedeutico
(
    insegnamento   integer not null
        references insegnamenti,
    propedeuticità integer not null
        references insegnamenti,
    primary key (insegnamento, propedeuticità)
);

alter table propedeutico
    owner to giacomo;

create trigger check_non_cyclic_prerequisites
    before insert
    on propedeutico
    for each row
execute procedure public.non_cyclic_prerequisites_check();

create function get_all_exstudents()
    returns TABLE(id uuid, nome character varying, cognome character varying, email character varying, matricola integer)
    language plpgsql
as
$$
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

alter function get_all_exstudents() owner to giacomo;

create procedure insert_utente(IN nome character varying, IN cognome character varying, IN tipo tipoutente, IN password character varying)
    language plpgsql
as
$$
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

alter procedure insert_utente(varchar, varchar, tipoutente, varchar) owner to giacomo;

create function get_email(nome character varying, cognome character varying, tipo tipoutente) returns character varying
    language plpgsql
as
$$
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

alter function get_email(varchar, varchar, tipoutente) owner to giacomo;

create function login(login_email character varying, login_password text)
    returns TABLE(id uuid, tipo tipoutente)
    language plpgsql
as
$$
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

alter function login(varchar, text) owner to giacomo;

create procedure insert_degree_course(IN _nome character varying, IN _tipo integer, IN _descrizione text)
    language plpgsql
as
$$
BEGIN

    INSERT INTO universal.corsi_di_laurea(nome, tipo, descrizione)
    VALUES (_nome, _tipo, _descrizione);
END;
$$;

alter procedure insert_degree_course(varchar, integer, text) owner to giacomo;

create procedure insert_teaching(IN _nome character varying, IN _descrizione text, IN _anno integer, IN _responsabile uuid, IN _corso_di_laurea integer)
    language plpgsql
as
$$
        BEGIN
            INSERT INTO universal.insegnamenti(nome, descrizione, anno, docente_responsabile, corso_di_laurea)
            VALUES (_nome, _descrizione, _anno, _responsabile, _corso_di_laurea);
        END;
    $$;

alter procedure insert_teaching(varchar, text, integer, uuid, integer) owner to giacomo;

create procedure insert_exam_session(IN _data date, IN _luogo character varying, IN _insegnamento integer)
    language plpgsql
as
$$
        BEGIN
            INSERT INTO universal.appelli(data, luogo, insegnamento)
            VALUES (_data, _luogo, _insegnamento);
        END;
    $$;

alter procedure insert_exam_session(date, varchar, integer) owner to giacomo;

create procedure insert_grade(IN _id_studente uuid, IN _id_docente uuid, IN codice_appello integer, IN _voto integer)
    language plpgsql
as
$$
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

alter procedure insert_grade(uuid, uuid, integer, integer) owner to giacomo;

create procedure subscription(IN _id uuid, IN _appello integer)
    language plpgsql
as
$$
BEGIN
    DECLARE
        codice_insegnamento INTEGER;
    BEGIN
        -- Ottieni l'insegnamento relativo all'appello specificato
        SELECT a.insegnamento INTO codice_insegnamento
        FROM universal.appelli AS a
        WHERE a.codice = _appello;

        -- Inserisci l'iscrizione dello studente all'appello d'esame
        INSERT INTO universal.iscritti (appello, studente,insegnamento, voto)
        VALUES (_appello, _id, codice_insegnamento, NULL);
    END;
END;
$$;

alter procedure subscription(uuid, integer) owner to giacomo;

create function get_all_teachers()
    returns TABLE(id uuid, nome character varying, cognome character varying, email character varying, ufficio character varying)
    language plpgsql
as
$$
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

alter function get_all_teachers() owner to giacomo;

create function get_teacher(_id uuid)
    returns TABLE(nome character varying, cognome character varying, email character varying, ufficio character varying)
    language plpgsql
as
$$
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

alter function get_teacher(uuid) owner to giacomo;

create function get_secretaries()
    returns TABLE(id uuid, nome character varying, cognome character varying, email character varying, sede character varying)
    language plpgsql
as
$$
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

alter function get_secretaries() owner to giacomo;

create function get_secretary(_id uuid)
    returns TABLE(nome character varying, cognome character varying, email character varying, sede character varying)
    language plpgsql
as
$$
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

alter function get_secretary(uuid) owner to giacomo;

create function get_degree_courses()
    returns TABLE(codice integer, nome text, tipo integer, descrizione text)
    language plpgsql
as
$$
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

alter function get_degree_courses() owner to giacomo;

create function get_degree_course(_codice integer)
    returns TABLE(nome text, tipo integer, descrizione text)
    language plpgsql
as
$$
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

alter function get_degree_course(integer) owner to giacomo;

create function get_teaching()
    returns TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile uuid, corso_di_laurea integer)
    language plpgsql
as
$$
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

alter function get_teaching() owner to giacomo;

create function get_grades(_codice integer)
    returns TABLE(nome character varying, cognome character varying, matricola integer, data date, voto integer)
    language plpgsql
as
$$
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

alter function get_grades(integer) owner to giacomo;

create function get_grades_of_ex_student(_id uuid)
    returns TABLE(nome character varying, cognome character varying, nome_insegnamento character varying, data date, voto integer)
    language plpgsql
as
$$
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

alter function get_grades_of_ex_student(uuid) owner to giacomo;

create function get_grades_of_ex_students()
    returns TABLE(nome character varying, cognome character varying, nome_insegnamento character varying, data date, voto integer)
    language plpgsql
as
$$
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

alter function get_grades_of_ex_students() owner to giacomo;

create procedure subsribe_to_cdl(IN _id_studente uuid, IN _codice integer)
    language plpgsql
as
$$
BEGIN
    UPDATE universal.studenti
    SET corso_di_laurea = _codice
    WHERE id = _id_studente;
END;
$$;

alter procedure subsribe_to_cdl(uuid, integer) owner to giacomo;

create function get_student_average(_id uuid)
    returns TABLE(nome character varying, cognome character varying, matricola integer, media numeric)
    language plpgsql
as
$$
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

alter function get_student_average(uuid) owner to giacomo;

create function get_exstudent_grades(_id uuid)
    returns TABLE(nome character varying, cognome character varying, matricola integer, insegnamento integer, voto integer, data date, corso_di_laurea integer)
    language plpgsql
as
$$
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

alter function get_exstudent_grades(uuid) owner to giacomo;

create procedure change_password(IN _id_utente uuid, IN _vecchia_password character varying, IN _nuova_password character varying)
    language plpgsql
as
$$
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
$$;

alter procedure change_password(uuid, varchar, varchar) owner to giacomo;

create procedure unsubscribe_from_exam_appointment(IN id_studente uuid, IN codice_appello integer)
    language plpgsql
as
$$
BEGIN
    -- Verifica se lo studente è iscritto all'appello selezionato
    IF NOT EXISTS (SELECT 1 FROM universal.iscritti WHERE studente = id_studente AND appello = codice_appello) THEN
        RAISE EXCEPTION 'Non sei iscritto all''appello selezionato.';
    END IF;

    -- Elimina l'iscrizione dello studente all'appello
    DELETE FROM universal.iscritti WHERE studente = id_studente AND appello = codice_appello;
END;
$$;

alter procedure unsubscribe_from_exam_appointment(uuid, integer) owner to giacomo;

create procedure subscribe_to_cdl(IN id_studente uuid, IN codice_cdl integer)
    language plpgsql
as
$$
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

alter procedure subscribe_to_cdl(uuid, integer) owner to giacomo;

create procedure unsubscribe_to_cdl(IN id_studente uuid, IN codice_cdl integer)
    language plpgsql
as
$$
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

alter procedure unsubscribe_to_cdl(uuid, integer) owner to giacomo;

create procedure create_exam_session(IN id_docente uuid, IN _data date, IN _luogo character varying, IN _insegnamento integer)
    language plpgsql
as
$$
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
    IF EXISTS (SELECT 1 FROM universal.appelli WHERE data = _data AND luogo = _luogo) THEN
        RAISE EXCEPTION 'Esiste già un appello in quel giorno e luogo.';
    END IF;

    -- Crea l'appello
    INSERT INTO universal.appelli (data, luogo, insegnamento)
    VALUES (_data, _luogo, _insegnamento);
END;
$$;

alter procedure create_exam_session(uuid, date, varchar, integer) owner to giacomo;

create procedure delete_exam_session(IN id_docente uuid, IN _data date, IN _luogo character varying, IN _insegnamento integer)
    language plpgsql
as
$$
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

alter procedure delete_exam_session(uuid, date, varchar, integer) owner to giacomo;

create procedure delete_utente(IN _id uuid)
    language plpgsql
as
$$
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

alter procedure delete_utente(uuid) owner to giacomo;

create procedure change_course_responsible_teacher(IN _id_nuovo_docente uuid, IN codice_insegnamento integer)
    language plpgsql
as
$$
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

alter procedure change_course_responsible_teacher(uuid, integer) owner to giacomo;

create function get_student(_id uuid)
    returns TABLE(nome character varying, cognome character varying, email character varying, matricola integer, corso_di_laurea text)
    language plpgsql
as
$$
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

alter function get_student(uuid) owner to giacomo;

create function get_teacher_grades(_id uuid)
    returns TABLE(nome character varying, cognome character varying, matricola integer, data date, luogo character varying, insegnamento integer, voto integer)
    language plpgsql
as
$$
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
            i.voto IS NOT NULL AND  ins.docente_responsabile = _id -- Filtra solo gli insegnamenti di cui il docente è responsabile
            AND ins.docente_responsabile = _id -- Aggiungi questa condizione per filtrare solo gli insegnamenti del docente attualmente loggato
        ORDER BY matricola;
    END;
$$;

alter function get_teacher_grades(uuid) owner to giacomo;

create function get_students_enrolled_in_teaching_appointments(_id uuid)
    returns TABLE(nome character varying, cognome character varying, matricola integer, data date, luogo character varying, insegnamento integer)
    language plpgsql
as
$$
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

alter function get_students_enrolled_in_teaching_appointments(uuid) owner to giacomo;

create function get_all_teaching_appointments_for_student_degree(_id uuid)
    returns TABLE(codice integer, data date, luogo character varying, insegnamento character varying)
    language plpgsql
as
$$
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

alter function get_all_teaching_appointments_for_student_degree(uuid) owner to giacomo;

create function get_id(_email character varying)
    returns TABLE(id uuid)
    language plpgsql
as
$$
    BEGIN
        RETURN QUERY
        SELECT
            u.id
        FROM universal.utenti AS u
        WHERE u.email = _email;
    END ;
    $$;

alter function get_id(varchar) owner to giacomo;

create function get_all_exam_sessions()
    returns TABLE(codice integer, data date, luogo character varying, nome character varying, corso_di_laurea integer)
    language plpgsql
as
$$
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

alter function get_all_exam_sessions() owner to giacomo;

create function get_student_exam_enrollments(_id uuid)
    returns TABLE(codice integer, data date, luogo character varying, nome_insegnamento character varying)
    language plpgsql
as
$$
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

alter function get_student_exam_enrollments(uuid) owner to giacomo;

create function get_missing_exams_for_graduation(_id uuid)
    returns TABLE(nome character varying, descrizione text, anno integer, docente_responsabile text, corso_di_laurea integer)
    language plpgsql
as
$$
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

alter function get_missing_exams_for_graduation(uuid) owner to giacomo;

create function get_partial_carrer(_id uuid)
    returns TABLE(nome character varying, descrizione text, anno integer, data date, docente_responsabile text, corso_di_laurea integer, voto integer)
    language plpgsql
as
$$
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

alter function get_partial_carrer(uuid) owner to giacomo;

create function get_student_grades(_id uuid)
    returns TABLE(nome character varying, descrizione text, anno integer, data date, docente_responsabile text, corso_di_laurea integer, voto integer)
    language plpgsql
as
$$
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

alter function get_student_grades(uuid) owner to giacomo;

create function get_exam_enrollments(_codice integer)
    returns TABLE(nome character varying, cognome character varying, _id uuid, email character varying, matricola integer, voto integer)
    language plpgsql
as
$$
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
                WHERE i.appello = _codice AND i.voto IS NULL
                ORDER BY matricola;
            END ;
        $$;

alter function get_exam_enrollments(integer) owner to giacomo;

create function trigger_delete_appello() returns trigger
    language plpgsql
as
$$
BEGIN
    -- Cancella gli iscritti con voto null associati all'appello cancellato
    DELETE FROM universal.iscritti
    WHERE appello = OLD.codice AND voto IS NULL;

    RETURN OLD;
END;
$$;

alter function trigger_delete_appello() owner to giacomo;

create function get_teaching_activity_of_professor(_id uuid)
    returns TABLE(codice_insegnamento integer, nome character varying, descrizione text, anno integer, corso_di_laurea integer, nome_cdl text)
    language plpgsql
as
$$
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

alter function get_teaching_activity_of_professor(uuid) owner to giacomo;

create function get_teaching_of_cdl(_codice integer)
    returns TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile text)
    language plpgsql
as
$$
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
            ins.corso_di_laurea = _codice
        ORDER BY
            ins.codice;
    END;
$$;

alter function get_teaching_of_cdl(integer) owner to giacomo;

create function get_exam_sessions(_codice integer)
    returns TABLE(data date, luogo character varying, nome character varying, corso_di_laurea integer, codice_appello integer, id_docente uuid)
    language plpgsql
as
$$
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

alter function get_exam_sessions(integer) owner to giacomo;

create procedure delete_teacher(IN _id uuid)
    language plpgsql
as
$$
DECLARE
BEGIN

    IF EXISTS (SELECT 1 FROM universal.insegnamenti AS ins WHERE ins.docente_responsabile = _id ) THEN
        RAISE EXCEPTION 'Il docente è responsabile di un corso';
    end if;

    DELETE FROM universal.docenti AS d
    WHERE d.id = _id;

END;
$$;

alter procedure delete_teacher(uuid) owner to giacomo;

create procedure studenttoexstudent(IN _id uuid, IN _motivo tipomotivo)
    language plpgsql
as
$$
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

    -- Inserisce i dati dell'ex studente nella tabella degli ex studenti
    INSERT INTO universal.ex_studenti (id, motivo, matricola, corso_di_laurea)
    VALUES (_id, _motivo, matricola_ex_studente, cdl);

    -- Rimuove lo studente dalla tabella studenti
    DELETE FROM universal.studenti
    WHERE id = _id;

END;
$$;

alter procedure studenttoexstudent(uuid, tipomotivo) owner to giacomo;

create function get_all_students()
    returns TABLE(id uuid, nome character varying, cognome character varying, email character varying, matricola integer, corso_di_laurea text)
    language plpgsql
as
$$
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

alter function get_all_students() owner to giacomo;

create procedure change_secretary_office(IN _id uuid, IN _nuova_sede character varying)
    language plpgsql
as
$$
DECLARE
BEGIN

    UPDATE universal.segretari AS s
    SET sede = _nuova_sede
    WHERE s.id = _id;
END;
$$;

alter procedure change_secretary_office(uuid, varchar) owner to giacomo;

create procedure delete_secretary(IN _id uuid)
    language plpgsql
as
$$
DECLARE
BEGIN

    DELETE FROM universal.segretari AS s
    WHERE s.id = _id;
END;
$$;

alter procedure delete_secretary(uuid) owner to giacomo;

create function get_ex_student(_id uuid)
    returns TABLE(nome character varying, cognome character varying, email character varying, matricola integer, corso_di_laurea text)
    language plpgsql
as
$$
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

alter function get_ex_student(uuid) owner to giacomo;

create function get_all_cdl()
    returns TABLE(codice integer, nome text, tipo text, descrizione text)
    language plpgsql
as
$$
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

alter function get_all_cdl() owner to giacomo;

create procedure insert_propaedeutics(IN codice_ins integer, IN codice_prop integer)
    language plpgsql
as
$$
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

alter procedure insert_propaedeutics(integer, integer) owner to giacomo;

create function get_single_teaching(_codice integer)
    returns TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile uuid, corso_di_laurea integer)
    language plpgsql
as
$$
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

alter function get_single_teaching(integer) owner to giacomo;

create function get_teaching_of_cdl_for_propaedeutics(codice_cdl integer, codice_ins integer)
    returns TABLE(codice integer, nome character varying, descrizione text, anno integer, responsabile text)
    language plpgsql
as
$$
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

alter function get_teaching_of_cdl_for_propaedeutics(integer, integer) owner to giacomo;

create function get_propaedeutics(codice_ins integer)
    returns TABLE(nome character varying, descrizione text, anno integer, docente_responsabile text)
    language plpgsql
as
$$
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

alter function get_propaedeutics(integer) owner to giacomo;

