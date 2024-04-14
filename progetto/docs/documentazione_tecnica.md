Giacomo Comitani, Matricola 986596

- [Database](#database)

- [Implementazioni Significative](#implementazioni-significative)

- [Funzioni Realizzate](#funzioni-realizzate)


# Database

Lo schema ER è disponibile cliccando [qui](ER.png)

Lo schema logico è disponibile cliccando [qui](./SchemaLogico.png)

# Implementazioni Significative

## Login

Il file `login.php` si occupa di permettere all'utente di accedere al sistema, e quindi di reindirizzarlo correttamente alla propria area personale. Per fare questo, una volta verificate le credenziali inserite dall'utente, questo verrà reindirizato alla propria area personale in base al suo tipo. in caso di credenziali erratee o ancanti, il sistema non permetterà all'utente di accedervi 

```php
if(isset($_POST["email"]) && isset($_POST["password"])) {
        $email = $_POST["email"];
        $password = $_POST["password"];
        $_SESSION['email'] = $email;
        
        $result = pg_query_params($conn, 'SELECT * FROM universal.utenti WHERE email = $1 AND password = crypt($2, password)', array($email, $password));

        if (pg_num_rows($result) == 1) {
            $query_get_id = "SELECT * FROM universal.get_id($1)";
            $result_get_id = pg_query_params($conn, $query_get_id, array($_SESSION['email']));
            $row_get_id = pg_fetch_assoc($result_get_id);
            $_SESSION['id'] = $row_get_id['id'];
            $type = Get_type($email);
            print_r($type);
            switch ($type){
                case "studenti":
                    header("Location: /progetto/webapp/studente/index.php");
                    exit();
                case "exstudenti":
                    header("Location: /progetto/webapp/ex_studente/index.php");
                    exit();
                case "docenti":
                    header("Location: /progetto/webapp/docente/index.php");
                    exit();
                case "segretari":
                    header("Location: /progetto/webapp/segreteria/index.php");
                    exit();
            }
        } else {
            echo '<script type="text/javascript">alert("Error: Credenziali errate!");</script>';
        }
    }
```

Una volta effettuato l'accesso al sistema, l'utente può usufruire delle diverse funzionalità, piò o meno estese al seconda del suo tipo. 

## Studente

Nel caso di uno studente, Questo verrà inizialmente reindirizzato alla seguente pagina: 

progetto/docs/images/homeStudent.png







# Funzioni Realizzate

## Funzioni

- `login`: verifica le credenziali dell'utente e ne restituisce il tipo e l'id
- `genera_matricola` : genera e ritorna il numero di matricola di uno studente 
- `get_all_students` : ritorna tutti gli studenti presenti nel sistema
- `get_all_exstudents` : ritorna tutti gli ex studenti presenti nel sistema
- `get_all_teachers` : ritorna tutti i docenti presenti nel sistema
- `get_id`: restituisce l'id dello studente a partire dai dati di autenticazione ? 
- `get_student` : restituisce uno studente dato il suo id
- `get_teacher`: restituisce un docente dato il suo id
- `get_ex_student` : restituisce un'ex studente dato il suo id 
- `get_secretary` : restituisce un segretario dato il suo id 
- `get_secretaries` : restituisce tutti i segretari presenti nel sistema 
- `get_degree_courses` : restituisce tutti i corsi di laurera presenti nel sistema 
- `get_degree_course` : restituisce un corso di laurea dato il suo codice 
- `get-email` : genera una nuova email per un utente. In caso di omonimia aggiunge un suffisso numerico incrementale alla fine del cognome dell'utente
- `get_teaching` : restituisce tutti gli insegnamenti presenti nel sistema
- `get_teaching_of-cdl` : dato il codice di un corso di laurea presente nel sistema, restituisce tutti gli insegnamenti del corso
- `get_exam-sessions` : dato il codice di un insegnamento, ne restituisce tutti gli appelli presenti nel sistema
- `get_all_exam-sessions` : restituisce tutti gli appelli di tutti gli insegnamenti presenti nel sistema 
- `get_student_exam_enrollments` : dato l'id di uno studente, restituisce tutti gli appelli a cui è iscritto 
- `get_exam_enrollments` : dato il codice di un appello, restituisce tutti gli studenti ad esso iscritti
- `get_grades` : dato il codice di un appello, restituisce tutte le valutazioni ad esso relative
- `get_grades_of_ex-students` : dato l'id di un ex studente, restituisce tutte le sue valutazioni
- `get_grades_of_ex_students` : restituisce tutte le valutazioni di tutti gli ex studenti presenti nel sistema 
- `get_missing_exams_for_graduation` : dato l'id di uno studente, restituisce gli esami che gli mancano al conseguimento della laurea a cui è iscritto 
- `get_teaching_activity_of_professor` : dato l'id di un docente, restituisce tutti gli insegnamenti di cui è responsabile
- `get_students_enrolled_in_teaching_appointments` : dato l'id di un docente, restituisce tutti gli studenti iscritti ad appelli degli insegnamenti di cui il docente è responsabile
- `get_teacher_grades` : dato l'id di un docente, restituisce tutte le valutazioni da lui assegnate
- `get_all_teaching_appointments_for_student_degree` : dato l'id di uno studente, restituisce tutti gli appelli di tutti gli insegnamenti del corso di laurea a cui è iscritto 
- `get_student_grades` : dato l'id di uno studente, restituisce tutte le sue valutazioni
- `get_student_average` : dato l'id di uno studente, restituisce la media delle sue valutazioni
- `get_all_cdl` : restituisce tutti i corsi di laurea presenti nel sistema 
- `get_partial_carrer` : dato l'id di uno studente, restituisce la sua carriera
- `get_propaedeutics` : dato il codice di un insegnamento, restituisce le sue propedeuticità
- `get_single_teaching` : dato il codice di un insegnamento, ne restituisce le informazioni associate
- `get_teaching_of_cdl_for_propaedeutics` : dato il codice di un corso di laurea e quello di un insegnamento del corso di laurea, restituisce tutti gli altri insegnamenti del corso di laurea
- `get_all_students_of_cdl` : dato il codice di un corso di laurea presente nel sistema, restituisce tutti gli studenti ad esso iscritto 

## Procedure

- `studentToExStudent` : trasforma uno studente in un ex studente, aggiornando correttamente le tabelle del sistema
- `insert_utente` : dato il nome, il cognome, la password e il tipo, inserisce un nuovo utente nel sistema
- `delete_utente` : dato l'id di un utente presente nel sistema, lo elimina
- `insert_degree_course` : inserisce un corso di laurea nel sistema 
- `insert_teaching` : inserisce un insegnamento nel sistema 
- `insert_exam_session` : inserisce un appello di un insegnamento presente nel sistema
- `subscription` : iscrive uno studente ad un appello 
- `insert_grade` : assegna una valutazione ad uno studente
- `subscribe_to_cdl` : iscrive uno studente ad un corso di laurea presente nel sistema 
- `change_password` : modifica la password di un utente presente nel sistema 
- `unsubscribe_from_exam_appointment` : disiscrive uno studente dall'appello di un insegnamento 
- `unsubscribe_from_exam_appointment` : disiscrive uno studente da un appello presente nel sistema 
- `unsubscribe_to-cdl` : disiscrive uno studente da un corso di laurea presente nel sistema 
- `create_exam_session` : crea un appello d'esame di un insegnamento
- `delete_exam_session` : cancella l'appello d'esame di un insegnamento
- `change_course_responsible_teacher` : modifica il docente responsabile di un insegnamento
- `change_secretary_office` : modifica la sede di un segretario 
- `delete_secretary` : elimina un segretario presente nel sistema 
- `delete_techer` : elimina un docente presente nel sistema 
- `insert_propaedeutics` : crea la propedeuticità per un'insegnamento

## Trigger

- `aggiorna_tabella` : inserisce le informazioni dell'utente creato nella tabella corretta, in base al tipo
- `elimina_utente_dopo_cancellazione` : elimina le informazioni dell'utente eliminato,  nella tabella `utenti`
- `check_number_of_session` : controlla che non ci sia piu di un appello nella stessa data per lo stesso corso di laurea
- `check_subscription_to_cdl` : controlla che uno studente non sia già iscritto ad un corso di laurea 
- `non_cyclic_prerequisites_check` : controlla che non ci siano propedeuticità cicliche 
- `check_instructor_course_limit`: controlla che il docente responsabile dell'insegnamento non sia giè responsabile di almeno tre insegnamenti
- `check_prerequisites_before_enrollment` : controlla che siano  rispettate le propedeuticità all'iscrizione ad un'appello.