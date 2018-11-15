-- Kaitlin Bleich kbleich
-- Kyaw Soe ksoe

-- Q1
-- Find all cars made after 1980 with MPG > 1982 civic
-- report full name of the car, year it was made, and name of manufacturer
-- sort by gas mileage, descending
SELECT
   CN.Description
   , CD.YearMade
   , CN.Model
FROM
   carsData CD INNER JOIN carNames CN ON CD.Id = CN.Id,
   carsData civic INNER JOIN carNames civN ON civic.Id = civN.Id AND
   civN.description = 'honda civic' AND civic.YearMade = 1982
WHERE
   CD.MPG > civic.MPG AND CD.YearMade > 1980
ORDER BY
   CD.MPG desc;

-- Q2
-- find average, max, and min HP for 4-cylinder engines by Renault between
-- 1971 and 1976
SELECT
   AVG(CD.horsepower), MAX(CD.horsepower), MIN(CD.horsepower)
FROM
   carsData CD INNER JOIN carNames CN ON CD.Id = CN.Id
WHERE
   CN.Model = 'renault' AND CD.YearMade BETWEEN 1971 AND 1976;

-- Q3 
-- find how many cars produced in 1973 had better acceleration than
-- a 1972 volvo 145e
SELECT
   COUNT(*)
FROM
   carsData volvoDt INNER JOIN carNames volvoNm ON 
      volvoDt.Id = volvoNm.Id AND volvoNm.description LIKE '%volvo 145e%',
   carsData CD INNER JOIN carNames CN ON
      CD.Id = CN.Id
WHERE
   CD.YearMade = 1973 AND CD.accelerate > volvoDt.accelerate;

-- Q4
-- find number of car manufacturers produced a vehicle heavier than 4000 lb
SELECT
   COUNT(DISTINCT CN.Model)
FROM
   carsData CD INNER JOIN carNames CN ON 
      CD.Id = CN.Id
WHERE
   CD.Weight > 4000;
