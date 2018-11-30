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
-- TODO only one car returned??
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
SELECT maxes.max, cars.Description, cars.yearmade
FROM
   (SELECT
   MAX(subq.Accelerate) as max
   FROM
      (SELECT CN.Description, CD.YearMade, CD.Accelerate
      FROM countries CTR, carMakers CM, modelList ML, carNames CN, carsData CD
      WHERE CM.Country = CTR.Id AND CM.Id = ML.Maker AND ML.model = CN.Model AND CN.Id = CD.Id AND
            CD.MPG = (SELECT MAX(CD.MPG) FROM carsData CD)) as subq) as maxes,
      (SELECT CN.Description, CD.YearMade, CD.Accelerate
      FROM countries CTR, carMakers CM, modelList ML, carNames CN, carsData CD
      WHERE CM.Country = CTR.Id AND CM.Id = ML.Maker AND ML.model = CN.Model AND CN.Id = CD.Id AND
            CD.MPG = (SELECT MAX(CD.MPG) FROM carsData CD)) as cars
      ;

-- Q5
-- report automakers whose models were on average the heaviest 
-- report year, automaker, number of models that year, avg acceleration
-- exclude anyone with only one car that year
-- TODO ask Prof about cutting this down to only makers with > 1 car, and how to report how many
SELECT
   CM1.FullName
   , CD1.YearMade as theyear
   , COUNT(DISTINCT CN1.Description)
   , TRUNCATE(AVG(CD1.Accelerate), 2)
FROM
    carMakers CM1
    , modelList ML1
    , carNames CN1
    , carsData CD1
WHERE
    -- connect carMakers -> carNames
    CM1.Id = ML1.Maker AND
    ML1.model = CN1.Model AND
    -- connect carNames -> carsData
    CN1.Id = CD1.Id
GROUP BY
   theyear, CM1.FullName
HAVING AVG(CD1.Weight) >= ALL(
   SELECT subsubq.avg 
   FROM 
      (SELECT ML.Maker, CD.YearMade, AVG(CD.Weight) as avg
       FROM carsData CD, carNames CN, modelList ML
       WHERE ML.model = CN.Model AND
             CN.Id = CD.Id AND CD.YearMade = theyear
       GROUP  BY ML.maker, CD.YearMade) as subsubq
   WHERE subsubq.YearMade = CD1.YearMade); 

-- Q6
-- report diff between most efficient 8cyl and least efficient 4banger
SELECT 
   (SELECT MAX(CD.MPG) FROM carsData CD WHERE CD.Cylinders = 8) -
   (SELECT MIN(CD.MPG) FROM carsData CD WHERE CD.Cylinders = 4) as SUBQ;

-- Q7
-- For years b/w 1972 & 1976 find out if US automakers or others made more
-- cars. Report either US or 'The Rest of The World'
SELECT
   usa.yearMAde, IF(usa.count > nusa.count, 'US', 'The rest of the world')
FROM
(SELECT
   CD.YearMade
   ,COUNT(CN.Id) count
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
   CTR.Name = 'usa' AND CD.YearMade BETWEEN 1972 AND 1976
GROUP BY
   CD.YearMade) as usa,
(SELECT
   CD.YearMade
   ,COUNT(CN.Id) count
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
   CTR.Name <> 'usa' AND CD.YearMade BETWEEN 1972 AND 1976
GROUP BY
   CD.YearMade) as nusa
WHERE
   usa.YEarMAde = nusa.YEarMade;
