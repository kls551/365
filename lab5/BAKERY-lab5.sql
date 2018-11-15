-- Q1
select distinct c.FirstName, c.LastName
from customers c, receipts r, goods g, items i, items i1
where 
c.CId=r.Customer and r.RNumber=i.Receipt and i.Receipt=i1.Receipt and i.Ordinal<>i1.Ordinal and
g.Food='Croissant' and g.GId=i.Item and g.GId=i1.Item
order by c.LastName;

-- Q2
select distinct r.saleDate
from receipts r, customers c, items i, goods g
where
(c.FirstName='ALMETA' and c.LastName='DOMKOWSKI' and r.Customer=c.CId) or
(g.Flavor='Gongolais' and g.Food='Cookie' and g.GId=i.Item and r.RNumber=i.Receipt)
order by r.saleDate;