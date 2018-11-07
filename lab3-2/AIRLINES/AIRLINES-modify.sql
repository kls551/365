-- Kaitlin Bleich kbleich
-- Kyaw Soe ksoe

-- Remove all flights except to and from AKI
DELETE FROM Flights
  WHERE SourceAirport != "AKI" AND DestAirport != "AKI";

-- non Continental, AirTran, or Virgin increase # by 2000
UPDATE Flights
SET FLightNumber = FlightNumber + 2000
WHERE Airline NOT IN (7, 10, 12);

-- swap Continental, AirTran, or Virgin with odd or even version
UPDATE Flights
SET FlightNumber = (IF(Airline IN (7,10,12),
                     IF(MOD(FlightNumber,2) = 0, FlightNumber + 1, FlightNumber-1),
                     FlightNumber)
      );

-- replace airline for all flights to/from AKI w/ Continental
UPDATE Flights
SET Airline = 7
WHERE SourceAirport = "AKI" OR DestAirport = "AKI";

-- display contents
SELECT *
FROM Flights
ORDER BY Airline, FlightNumber
