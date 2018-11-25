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
    
-- Q3
-- Report total amount of money 'Natacha Stenz' spent at bakery during Oct 2007
SELECT
   TRUNCATE(SUM(G.Price), 2) as 'total Nat purchase'
FROM
   customers C, receipts R, items I, goods G
WHERE
   -- connect tables
   C.CId = R.Customer AND
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   C.FirstName = 'Natacha' AND C.LastName = 'Stenz' AND
   month(R.saleDate) = 10 AND YEAR(R.saleDate) = 2007;

-- Q4
-- report total amount spent on 'Chocolate' by customers in Oct 2007
SELECT
   TRUNCATE(SUM(G.Price), 2) as 'total Oct Chocolate'
FROM
   receipts R, items I, goods G
WHERE
   -- connect tables
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   G.flavor = 'chocolate' AND
   month(R.saleDate) = 10 AND YEAR(R.saleDate) = 2007;
