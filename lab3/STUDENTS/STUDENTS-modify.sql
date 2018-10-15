--Kyaw Lwin Soe
--ksoe@calpoly.edu
--Kaitlin Bleich
--kbleich@calpoly.edu

/*
• Extend the database structure to include information about the GPA for each student.
• Keep in the database only the students in grades 5 and 6.
• Add a new classroom to the database. The classroom number is 120, and the teacher in that
classroom is AP-MAWR GAWAIN.
• Move JEFFREY FLACHS, TAWANNA HUANG and EMILE GRUNIN to classroom 120.
• Set the GPA of sixth graders to 3.25.
• Set the GPA of fifth graders from room 109 to 2.9.
• Set the GPA of fifth graders from room 120 to 3.5.
• The following instructions apply to individual students and override all prior GPA assignments.
– Set the GPA of CHET MACIAG to 4.0.
– Set the GPA of AL GERSTEIN to be 0.3 higher than whatever it currently is.
– Set the GPAs of TAWANNA HUANG and ELVIRA JAGNEUX to be 10% higher than their current
GPAs.
*/

-- add GPA
ALTER TABLE students 
	ADD (GPA DECIMAL(4,2));

-- only leave 5th and 6th graders
DELETE FROM students
	WHERE Grade = 0 OR Grade = 1 OR Grade = 2 OR Grade = 3 OR
	Grade = 4;

-- add 120
INSERT INTO teachers 
	VALUES ('GAWAIN', 'AP-MAWR', 120);

-- set specific students to 120 classroom
UPDATE students
	SET Classroom = 120
	WHERE (FirstName = 'JEFFRY' AND LastName = 'FLACHS')
	OR (FirstName = 'TAWANNA' AND LastName = 'HUANG')
	OR (FirstName = 'EMILE' AND LastName = 'GRUNIN');

-- set GPA for 6th graders
UPDATE students
	SET GPA = 3.25
	WHERE (Grade = 6);

-- set GPA for 5th and 109 students
UPDATE students
	SET GPA = 2.9
	WHERE (Grade = 5 AND Classroom = 109);

-- set GPA fro 5th and 120 students
UPDATE students
	SET GPA = 3.5
	WHERE (Grade = 5 AND Classroom = 120);

-- set one 4.0 GPA guy
UPDATE students
	SET GPA = 4.0
	WHERE (FirstName = 'CHET' AND LastName = 'MACIAG');

-- modify Al GPA
UPDATE students
	SET GPA = GPA + 0.3
	WHERE (FirstName = 'AL' AND LastName = 'GERSTEIN');

-- modify Tawanna and Elvira GPAs
UPDATE students
	SET GPA = GPA + (GPA*0.1)
	WHERE (FirstName = 'ELVIRA' AND LastName = 'JAGNEAUX')
	OR (FirstName = 'TAWANNA' AND LastName = 'HUANG');

-- ending listing
SELECT * FROM students
ORDER BY GPA, Grade, LastName;

SELECT *
FROM teachers;