-- Q1
select f.Source, a.Name
from flights f, airports a
where a.Code = f.Source
group by f.Source, a.Name
having count(f.Source) = 17
order by f.Source;

-- Q2
select count(distinct f.Source)
from flights f, flights f1
where
f.Destination = f1.Source
and f1.Destination = 'ANP' and f.Source != 'ANP';

-- Q3
select count(distinct f.Source)
from flights f, flights f1
where
(f.Destination = f1.Source and f1.Destination = 'ATE' and f.Source != 'ATE')
or
(f.Destination = 'ATE' and f.Source != 'ATE');

-- Q4
select a.Airline, count(distinct f.Source) as '# of outgoing'
from
flights f, airlines a
where a.Id = f.Airline
group by f.Airline;