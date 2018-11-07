-- 1
-- find all Renaults in the database
SELECT
    CN.Description
  , CD.YearMade
FROM
  carNames CN INNER JOIN carsData CD ON CD.Id = CN.Id
WHERE
  CN.Model = 'Renault'
ORDER BY
  CD.YearMade;

-- 2
-- find all Volvos between 1977 and 1981
SELECT
  CN.Description
 ,CD.YearMade
FROM
  carNames CN INNER JOIN carsData CD ON CD.Id = CN.Id
WHERE
  CN.Model = 'Volvo' AND CD.YearMade >= 1977 AND CD.YearMade <= 1981
ORDER BY
  CD.YearMade;

-- 3
-- find all asian automakers
SELECT
   CM.FullName
   , Cr.Name
FROM
   carMakers CM,
   continents Ctn INNER JOIN 
      countries Cr ON Ctn.Id = Cr.Continent
WHERE
   CM.Country = Cr.Id AND Ctn.Name = 'asia';

-- 4
-- non-four cylinder cars produced in 1980 with fuel economy > 20 and
-- 0-60 < 15
SELECT
  CN.Description
  , CM.FullName
FROM
   carMakers CM JOIN modelList ML ON CM.Maker = ML.Model,
   carNames CN JOIN carsData CD ON CD.Id = CN.Id
WHERE
   ML.Model = CN.Model AND
   CD.Cylinders != 4 AND
   CD.YearMade = 1980 AND
   CD.MPG > 20 AND
   CD.Accelerate < 15;

-- 5
-- all non-european car makers that produced at least one car with
-- < 2000 lb weight made between 1979 and 1981
SELECT DISTINCT
   CM.FullName,
   Ctry.Country
FROM
   continents Cont
   , countries Ctry
   , carMakers CM
   , modelList ML
   , carNames CN
   , carsData CD
   WHERE
   Cont.Id = Ctry.Continent AND
   CM.Country = Ctry.Id AND
   CM.Id = ML.Maker AND
   ML.Model = CN.Model AND
   CN.Id = CD.Id AND
   Cont.Name != 'europe' AND
   CD.Weight < 2000 AND
   CD.YearMade BETWEEN 1979 AND 1981;

-- for each saab released after 1978 compute weight/horsepower
SELECT
   CN.description
   ,CD.YearMade
   ,CD.Weight/CD.Horsepower as ratio
FROM
    carNames CN
   ,modelList ML
   ,carsData CD
WHERE
   ML.Model = CN.Model AND
   CN.Id = CD.Id AND
   ML.Model = 'saab' AND
   CD.YearMade > 1978
