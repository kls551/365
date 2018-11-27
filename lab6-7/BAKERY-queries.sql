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
   , COUNT(R.RNumber)
   , COUNT(G.GId)
   , TRUNCATE(SUM(G.Price), 2)
FROM 
   receipts R
   , items I
   , goods G
WHERE
   -- connect tables
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   -- other criteria
   MONTH(R.SaleDate) = 10 AND
   DAY(R.Saledate) BETWEEN 8 AND 8+6
   
GROUP BY
   DAYNAME(R.saleDate), R.SaleDate
ORDER BY 
   R.SaleDate;

-- Q3
-- find customers who never purchased a twist in Oct 2007
-- report first and last names in alphabetical order by last name
SELECT
   C.LastName
   , C.FirstName
FROM
   customers C
WHERE
   C.CId NOT IN
   (SELECT
      C.CId
   FROM 
   receipts R
   , items I
   , goods G
   , customers C
WHERE
   -- connect tables
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   R.Customer = C.CId AND
   -- other criteria
   G.Food = 'Twist' AND
   MONTH(R.saleDate) = 10);

-- Q4
-- for every cake, report cutomers who purchased it the most during Oct 2007
-- report name of pastry, customer names, # of purchases
SELECT
   maxper.Flavor, NmeToCount.FirstName, NmeToCount.LastName, maxper.count
FROM
   -- subq pulls max counts of each cake flavor
   (SELECT Flavor, MAX(count) as count
    FROM
      (SELECT G.Flavor, C.FirstName, C.LastName, COUNT(R.RNumber) as count
       FROM customers C, receipts R, items I, goods G
       WHERE C.CId = R.Customer AND R.RNumber = I.receipt AND
          I.Item = G.GId AND G.Food = 'Cake' AND  MONTH(R.saleDate) = 10
       GROUP BY G.Flavor, C.FirstName, C.LastName) as subq
    GROUP BY Flavor
   ) as maxper,
   -- subq pulls names with their total purchases of each cake flavor
   (SELECT G.Flavor, C.FirstName, C.LastName, COUNT(R.RNumber) as count
    FROM customers C, receipts R, items I, goods G
    WHERE C.CId = R.Customer AND R.RNumber = I.receipt AND
          I.Item = G.GId AND G.Food = 'Cake' AND MONTH(R.saleDate) = 10
    GROUP BY G.Flavor, C.FirstName, C.LastName) NmeToCount
WHERE
   NmeToCount.count = maxper.count AND NmeToCount.Flavor = maxper.Flavor;

-- Q5
-- report customers NOT make purchase b/w Oct5 and Oct11 of 2007
-- TODO check for accuracy
SELECT
   C.LastName
   , C.FirstName
FROM
  customers C
WHERE
   C.CId NOT IN
   (SELECT
      -- people who made purchases in time frame
      C.CId
   FROM 
   receipts R
   , items I
   , goods G
   , customers C
WHERE
   -- connect tables
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   R.Customer = C.CId AND
   -- other criteria
   R.SaleDate BETWEEN '2007-10-05' AND '2007-10-11')
ORDER BY C.LastName;

-- Q6
-- output customers who made >1 purchases on last day of Oct that they made a purchase
-- report names, and earliest day in Oct that they made a purchase
SELECT
   C.FirstName
   , C.LastName
   , (SELECT MIN(RS.SaleDate) FROM receipts RS INNER JOIN customers CS 
                        ON CS.CId = RS.Customer
                 WHERE MONTH(RS.SaleDate) = 10 AND YEAR(RS.SaleDate) = 2007 AND
                       CS.CId = C.CId) as earliest
FROM
   receipts R
   , items I
   , goods G
   , customers C
WHERE
    -- connect tables
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   R.Customer = C.CId AND
   -- other criteria
   R.saleDate = (SELECT MAX(RS.saleDate) FROM receipts RS INNER JOIN customers CS 
                        ON CS.CId = RS.Customer
                 WHERE MONTH(RS.SaleDate) = 10 AND YEAR(RS.SaleDate) = 2007 AND
                       CS.CId = C.CId)
GROUP BY
   C.FirstName,
   C.LastName,
   R.saleDate,
   earliest
HAVING
   COUNT(R.RNumber) > 1
ORDER BY
   earliest;

-- Q7
-- find out if 'Chocolate' or 'Croissants were more lucrative in Oct 2007
-- output Chocolate or Croissants
-- SELECT
--   IF(CHOC.maxx > CROISS.maxx, 'Chocolate!', 'HON HON HON CROISSANT')
-- FROM
SELECT
   IF(CHOC.rev > CROISS.rev, 'Chocolate!!', 'HON HON HON croissant') as winnamon
FROM
(SELECT
   G.Flavor
   , SUM(G.Price) as rev
FROM 
   receipts R
   , items I
   , goods G
WHERE
   -- connect tables
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   -- other criteria
   G.Flavor = 'Chocolate' AND
   YEAR(R.saleDate) = 2007 AND
   MONTH(R.saleDate) = 10
GROUP BY
   G.Flavor) as CHOC
,(SELECT
   G.Food
   , SUM(G.Price) as rev
FROM 
   receipts R
   , items I
   , goods G
WHERE
   -- connect tables
   R.RNumber = I.Receipt AND
   I.Item = G.GId AND
   -- other criteria
   G.Food = 'Croissant' AND
   YEAR(R.saleDate) = 2007 AND
   MONTH(R.saleDate) = 10
GROUP BY
   G.Food) as CROISS


