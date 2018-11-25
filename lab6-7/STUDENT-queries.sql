-- 	Q1
select l.Grade, count(distinct l.Classroom) as 'numClass', 
count(l.LastName and l.FirstName) as 'numStudents'
from list l
group by l.Grade
order by count(distinct l.Classroom) desc, l.Grade;

-- Q2
select l.Classroom, MAX(l.LastName)
from
list l 
where
l.Grade = 4
group by l.Classroom;

-- Q3
select t.FirstName, t.LastName, count(l.Classroom) as 'numStudents'
from list l, teachers t
where l.Classroom=t.Classroom
group by t.FirstName, t.LastName
order by count(l.Classroom) desc
limit 1;

-- Q4
select l.Grade, count(l.LastName) as '#'
from list l 
where
l.LastName like 'A%' or l.LastName like 'B%' or l.LastName like'C%'
group by l.Grade
order by count(l.LastName) desc
limit 1;

-- Q5
select distinct l.Classroom, count(l.Classroom)
from list l 
group by l.Classroom
having count(l.Classroom) < (select count(*)/count(distinct l.Classroom)
from list l)
order by l.Classroom;

-- Q6
select l1.Classroom, l2.Classroom, l1.count
from (select distinct l.Classroom, count(l.Classroom) as count
from list l 
group by l.Classroom) l1,
(select distinct l.Classroom, count(l.Classroom) as count
from list l 
group by l.Classroom) l2
where l1.count = l2.count and l1.Classroom != l2.Classroom
and l1.Classroom < l2.Classroom
order by l1.count;