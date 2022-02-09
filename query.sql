-- QUERY CON SELECT

-- 1. Selezionare tutti gli studenti nati nel 1990 (160)
SELECT * FROM `students` WHERE YEAR(date_of_birth) = 1990


-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)
SELECT COUNT(id) FROM `courses` WHERE `cfu` > 10


-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT * FROM `students` WHERE ADDDATE(date_of_birth, INTERVAL 30 YEAR) <= CURDATE()


-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea (286)
SELECT * FROM `courses` WHERE `period` = 'I semestre'


-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020 (21)
SELECT * FROM `exams` WHERE date = '2020-06-20' AND hour >= TIME_FORMAT("14:00:00", "%H %i %s")


-- 6. Selezionare tutti i corsi di laurea magistrale (38)
SELECT * FROM `degrees` WHERE `level` = 'magistrale'
SELECT * FROM `degrees` WHERE `level` LIKE '%magistrale%'


-- 7. Da quanti dipartimenti è composta l'università? (12)
SELECT COUNT(*) FROM `departments`


-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)
SELECT COUNT(*) FROM `teachers` WHERE `phone` IS NULL



-- QUERY CON GROUP

-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) as `yearly_students`, YEAR(enrolment_date) FROM `students` GROUP BY YEAR(enrolment_date) ORDER BY YEAR(enrolment_date) DESC


-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*), `office_address` FROM `teachers` GROUP BY office_address


-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT AVG(vote), exam_id FROM `exam_student` GROUP BY exam_id
SELECT ROUND(AVG(vote), 2), exam_id FROM `exam_student` GROUP BY exam_id


-- 4. Contare quanti corsi di laurea ci sono per ogni dipartiment
SELECT COUNT(*), department_id FROM `degrees` GROUP BY department_id



-- QUERY CON JOIN   

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT * FROM students as s, degrees as d WHERE d.id = s.degree_id AND d.name = 'Corso di Laurea in Economia'
SELECT * FROM students as s INNER JOIN degrees as d ON d.id = s.degree_id WHERE d.name = 'Corso di Laurea in Economia'

-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT * FROM degrees AS deg, departments AS dep WHERE deg.department_id = dep.id AND dep.name = 'Dipartimento di Neuroscienze'
SELECT * FROM degrees AS deg INNER JOIN departments AS dep ON deg.department_id = dep.id WHERE dep.name = 'Dipartimento di Neuroscienze'

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT c.name, c.id FROM `course_teacher` AS ct, `teachers` AS t,`courses` AS c WHERE ct.course_id = c.id AND ct.teacher_id = t.id AND t.id = 44
SELECT c.name, c.id FROM `course_teacher` AS ct INNER JOIN (`teachers` AS t, `courses` AS c) ON (ct.teacher_id = t.id AND ct.course_id = c.id) WHERE t.id = 44

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT s.name, s.surname, deg.name, dep.name FROM students as s, degrees as deg, departments AS dep WHERE deg.id = s.degree_id AND deg.department_id = dep.id ORDER BY s.surname
SELECT s.name, s.surname, deg.name, dep.name FROM students as s INNER JOIN (degrees as deg, departments AS dep) ON (deg.id = s.degree_id AND deg.department_id = dep.id) ORDER BY s.surname

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT t.name, t.surname, c.name, d.name FROM `course_teacher` AS ct, `teachers` AS t,`courses` AS c, degrees as d WHERE ct.course_id = c.id AND ct.teacher_id = t.id AND c.degree_id = d.id
SELECT t.name, t.surname, c.name, d.name FROM `course_teacher` AS ct JOIN (`teachers` AS t, `courses` AS c, degrees as d) ON (ct.teacher_id = t.id AND ct.course_id = c.id AND c.degree_id = d.id) 

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT t.id, t.name, t.surname FROM `course_teacher` AS ct JOIN (`teachers` AS t, `courses` AS c, degrees as deg, departments AS dep) ON (ct.teacher_id = t.id AND ct.course_id = c.id AND c.degree_id = deg.id AND deg.department_id = dep.id) WHERE dep.name = 'Dipartimento di Matematica'

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per superare ciascuno dei suoi esami
SELECT COUNT(*) as failed_exams, s.name, s.surname FROM `exam_student` AS es INNER JOIN (students as s, exams AS ex) ON (es.student_id = s.id AND es.exam_id = ex.id) WHERE es.vote < 18 GROUP BY es.student_id
