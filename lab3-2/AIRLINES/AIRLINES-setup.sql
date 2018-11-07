-- Kaitlin Bleich kbleich
-- Kyaw Soe ksoe

CREATE TABLE Airlines (
   ID int PRIMARY KEY,
   Airline char(40),
   Abbreviation char(30),
   Country char(20)
);

CREATE TABLE Airports100 (
   City char(20),
   AirportCode char(3) PRIMARY KEY,
   AirportName char(50),
   Country char(30) REFERENCES Airlines(Country),
   CountryAbbr char(10)
);

CREATE TABLE Flights (
   Airline int,
   FlightNumber int,
   SourceAirport char(3) REFERENCES Airports100(AirportCode),
   DestAirport char(3) REFERENCES Airports100(AirportCode)
);
