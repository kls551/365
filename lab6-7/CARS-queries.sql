-- Kaitlin Bleich kbleich

-- Q1
-- For each Japanese car maker report BEST MPG and avg acceleration
-- sort in ascending order
SELECT
   CM.Maker
   , MAX(CD.MPG)
   , AVG(CD.Accelerate)
FROM
   countries CTR
   , carMakers CM
   , modelList ML
   , carNames CN
   , carsData CD
WHERE
   -- connect countries -> carMakers
   CM.Country = CTR.Id AND
   -- connect carMakers -> carNames
   CM.Id = ML.Maker AND
   ML.model = CN.Model AND
   -- connect carNames -> carsData
   CN.Id = CD.Id AND
   -- other criteria
   CTR.Name = 'japan'
GROUP BY
   CM.Maker
ORDER BY
   MIN(CD.MPG) asc;

-- Q2
-- for each US car maker, report how many 4 bangers  they have 
-- lighter than 4000 lbs with 0-60 < 14 sec
-- sort in descending order by cars reported
SELECT
   CM.Maker
   , COUNT(CD.Id)
FROM
   countries CTR
   , carMakers CM
   , modelList ML
   , carNames CN
   , carsData CD
WHERE
   -- connect countries -> carMakers
   CM.Country = CTR.Id AND
   -- connect carMakers -> carNames
   CM.Id = ML.Maker AND
   ML.model = CN.Model AND
   -- connect carNames -> carsData
   CN.Id = CD.Id AND
   -- other criteria
   CTR.Name = 'usa' AND
   CD.Cylinders = 4 AND
   CD.Weight < 4000 AND
   CD.Accelerate < 14
 GROUP BY
   CM.Maker
 ORDER BY
    SUM(CD.ID) desc;

-- Q3
-- report full name and year of cars with best gas mileage
SELECT
   CN.Description
   , CD.YearMade
FROM
   countries CTR
   , carMakers CM
   , modelList ML
   , carNames CN
   , carsData CD
WHERE
   -- connect countries -> carMakers
   CM.Country = CTR.Id AND
   -- connect carMakers -> carNames
   CM.Id = ML.Maker AND
   ML.model = CN.Model AND
   -- connect carNames -> carsData
   CN.Id = CD.Id AND
   -- other criteria
   CD.MPG = (SELECT MAX(CD.MPG) FROM carsData CD);

-- Q4
-- among best MPG cars report best acceleration (full name and year)

-- Q5
-- report automakers whose models were on average the heaviest 
-- report year, automaker, number of models that year, avg acceleration
-- exclude anyone with only one car that year
SELECT SUBQ.YearMade, MAX(SUBQ.avg)
FROM 
   carMakers OCM
   , (SELECT
   CD.YearMade
   , CM.FullName
   , AVG(CD.Weight) as avg
   FROM
   countries CTR
   , carMakers CM
   , modelList ML
   , carNames CN
   , carsData CD
   WHERE
   -- connect countries -> carMakers
   CM.Country = CTR.Id AND
   -- connect carMakers -> carNames
   CM.Id = ML.Maker AND
   ML.model = CN.Model AND
   -- connect carNames -> carsData
   CN.Id = CD.Id 
   -- other criteria
   GROUP BY
   CD.YearMade
   , CM.FullName) as SUBQ
WHERE
   OCM.FullName = SUBQ.FullName

-- Q6
-- report diff between most efficient 8cyl and least efficient 4banger
SELECT
   (SELECT MAX(CD.MPG) FROM carsData CD WHERE CD.Cylinders = 8) -
   (SELECT MIN(CD.MPG) FROM carsData CD WHERE CD.Cylinders = 4);
