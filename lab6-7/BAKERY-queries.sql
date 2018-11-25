-- Kaitlin Bleich kbleich
-- Kyaw Soe Ksoe

-- Q1
-- for pastry flavors found in >3 pastries, report average price of an item
-- of this flavor and total number of different pastries of this flavor
SELECT
   G.Flavor
   ,TRUNCATE(AVG(G.Price), 3)
   ,COUNT(G.GId)
FROM
   goods G
GROUP BY
   G.Flavor 
HAVING
   COUNT(G.GId) > 3
ORDER BY
   AVG(G.Price) asc;

-- Q2
-- for each day of the week of Oct 8, report total purchases, total pastries,
-- and overall daily revenue
-- report results in chronological order and include both the day of week and date
SELECT
   DAYNAME(R.saleDate)
   , R.SaleDate
FROM 
   receipts R
WHERE
   MONTH(R.SaleDate) = 10 AND
   DAY(R.Saledate) BETWEEN 8 AND 8+6
   
GROUP BY
   DAYNAME(R.saleDate), R.SaleDate
ORDER BY 
   R.SaleDate;
