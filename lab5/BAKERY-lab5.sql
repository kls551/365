-- Kaitlin Bleich

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
