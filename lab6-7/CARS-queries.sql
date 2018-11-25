-- Kaitlin Bleich kbleich

-- Q1
-- For each Japanese car maker report BEST MPG and avg acceleration
-- sort in ascending order
SELECT
   CM.Maker
FROM
   countries CTR
   , carMakers CM
WHERE
   -- connect countries -> carMakers
   CM.Country = CTR.Id AND
   -- other criteria
   CTR.Name = 'japan';
