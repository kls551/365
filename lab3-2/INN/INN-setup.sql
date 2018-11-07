-- Kyaw Lwin Soe
-- ksoe@calpoly.edu
-- Kaitlin Bleich
-- kbleich@calpoly.edu

CREATE TABLE Rooms(
	RoomId CHAR(3) PRIMARY KEY,
	roomName CHAR(30) UNIQUE,
	numBeds INT,
	bedType CHAR(8),
	maxOccup INT CHECK (maxOccup<5),
	basePrice INT CHECK (basePrice>0),
	decor CHAR(20)
);

CREATE TABLE Reservations(
	Code INT PRIMARY KEY,
	Room CHAR(3) REFERENCES Rooms(RoomId),
	CheckIn CHAR(10),
	CheckOut CHAR(10),
	Rate INT CHECK (Rate>0),
	LastName CHAR(20),
	FirstName CHAR(20),
	Adults INT,
	Kids INT
);