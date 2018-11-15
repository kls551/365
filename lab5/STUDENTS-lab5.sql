-- Q1
select distinct l1.FirstName, l1.LastName, l1.Grade
from list l1, list l2
where l1.FirstName=l2.FirstName and l1.LastName!=l2.LastName;

-- Q2
select l.FirstName, l.LastName
from list l, teachers t
where l.Grade=1 and l.Classroom<>t.Classroom and t.FirstName='OTHA' and t.LastName='MOYER'
order by l.LastName;

-- Q3
select count(*)
from list
where Grade=3 or Grade=4;

-- Q4
select count(*)
from list l, teachers t
where t.FirstName='LORIA' and t.LastName='ONDERSMA' and t.Classroom=l.Classroom;
