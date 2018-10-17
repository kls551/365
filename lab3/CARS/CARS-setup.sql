--Kyaw Lwin Soe
--ksoe@calpoly.edu
--Kaitlin Bleich
--kbleich@calpoly.edu

CREATE TABLE CarData (
   ID int PRIMARY KEY REFERENCES CarNames(ID),
   MPG int,
   Cylinders int,
   Edispl int,
   Horsepower int,
   Weight int,
   Accelerate decimal(3,1),
   Year int
);

CREATE TABLE CarMakers (
   ID int PRIMARY KEY,
   Maker char(30) REFERENCES ModelList(Maker),
   FullName char(30),
   Country int
);

CREATE TABLE CarNames(
   ID int PRIMARY KEY,
   Model Char(40) REFERENCES ModelList(Model),
   Make  Char(40)
);

CREATE TABLE Continents (
   ContID int PRIMARY KEY,
   Continent char(10) UNIQUE
);

CREATE TABLE Countries (
   CountryID int PRIMARY KEY,
   CountryName char(20),
   Continent char(10) REFERENCES Continents(Continent)
);

CREATE TABLE ModelList (
   ModelID int PRIMARY KEY,
   Maker char(30),
   Model char(30) UNIQUE
);
