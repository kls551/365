-- Q1
SELECT Flavor, Food, Price
from goods
where Flavor='Chocolate'
order by Price DESC;

-- Q2
SELECT g.Flavor, g.Food, g.Price
from goods g
where (g.Price > 1.1 and g.Food='Cookie') or g.Flavor='Lemon' or (g.Flavor='Apple' and g.Food<>'Pie')
order by g.Flavor, g.Food;

-- Q3
SELECT distinct c.FirstName, c.LastName
from customers c, receipts r
where r.saleDate='2007-10-03' and r.Customer=c.Cid
order by c.LastName;

-- Q4
SELECT distinct g.Flavor, g.Food
from goods g, receipts r, items i
where r.saleDate='2007-10-04' and r.RNumber=i.Receipt and i.Item=g.Gid
order by g.Flavor;

-- Q5
select g.Flavor, g.Food
from  customers c, receipts r, goods g, items i
where c.FirstName='ARIANE' and c.LastName='CRUZEN' and r.saleDate='2007-10-25'
	and r.Customer=c.Cid and i.Item=g.Gid and i.Receipt=r.RNumber;

-- Q6
select g.Flavor, g.Food
from customers c, receipts r, goods g, items i
where c.FirstName='KIP' and c.LastName='ARNN' and Month(r.saleDate)=Month('2007-10-01') 
	and Year(r.saleDate)=Year('2007-10-01') and r.Customer=c.Cid and i.Item=g.Gid and i.Receipt=r.RNumber
	and g.Food='Cookie'
order by g.Flavor;