-- Q1
SELECT FirstName, LastName
FROM list
WHERE Classroom=111
ORDER BY LastName;

-- Q2
SELECT DISTINCT Classroom, Grade
FROM list
ORDER BY Classroom DESC;

-- Q3
SELECT DISTINCT t.FirstName, t.LastName, t.Classroom
FROM list l, teachers t
WHERE l.Grade=5 AND t.Classroom=l.Classroom;

-- Q4
SELECT l.FirstName, l.LastName
FROM list l, teachers t
WHERE l.Classroom=t.Classroom and t.FirstName='OTHA' and t.LastName='MOYER'
ORDER BY l.LastName;

-- Q5
SELECT DISTINCT t.FirstName, t.LastName, l.Grade
FROM list l, teachers t
WHERE l.Classroom=t.Classroom and l.Grade <= 3
ORDER BY l.Grade, t.LastName;