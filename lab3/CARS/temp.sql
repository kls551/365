DELETE FROM CarData
WHERE (
   (CarData.Year IN (1979, 1980) AND CarData.MPG >= 20) OR
   (CarData.MPG >= 26 AND CarData.Horsepower > 110) OR
   (CarData.Cylinders = 8 AND CarData.Accelerate < 10)
);

SELECT *
FROM CarData
ORDER BY CarData.year, CarData.ID;

ALTER TABLE CarData
DROP Edispl, Horsepower, Weight;

SELECT *
FROM CarData
ORDER BY CarData.year, CarData.ID;

DELETE FROM CarData
WHERE (CarData.Cylinders <= 5)

SELECT *
FROM CarData
ORDER BY CarData.year, CarData.ID;

