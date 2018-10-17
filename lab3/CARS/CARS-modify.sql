DELETE FROM CarData  
WHERE (
   (CarData.Year NOT IN (1979, 1980) OR CarData.MPG < 20) AND
   NOT(CarData.MPG >= 26 AND CarData.MPG IS NOT NULL AND CarData.Horsepower > 110) AND
   (CarData.Cylinders != 8 OR CarData.Accelerate >= 10)
);

SELECT *
FROM CarData
ORDER BY CarData.Year, CarData.ID;

ALTER TABLE CarData
DROP Edispl;

ALTER TABLE CarData
DROP Horsepower;

ALTER TABLE CarData
DROP Weight;

DELETE FROM CarData
WHERE (CarData.Cylinders <= 5);

SELECT *
FROM CarData
ORDER BY CarData.Year, CarData.ID;
