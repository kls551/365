CREATE TABLE Campuses( Id int PRIMARY KEY,
 CampusName CHAR(100) NOT NULL, 
 Location CHAR(20), 
 County CHAR(20), 
 YearOpened INT CHECK(YearOpened>=1800)
 );

CREATE TABLE faculty(Campus int REFERENCES Campuses(Id), 
	Year int, 
	FacultyCount int
);

CREATE TABLE fees(Campus int REFERENCES Campuses(Id), 
	Year int, 
	CampusFee INT CHECK(CampusFee>0)
);

CREATE TABLE degrees( Year int, 
	Campus int REFERENCES Campuses(Id), 
	Degrees INT CHECK(Degrees>0)
);

CREATE TABLE disciplines(Id int PRIMARY KEY, 
	Name CHAR(50) NOT NULL
);

CREATE TABLE DisEnrollments(Campus int REFERENCES Campuses(Id), 
	Discipline int REFERENCES disciplines(Id), 
	Year int, 
	UnderG int, 
	Graduate int
);

CREATE TABLE enrollments(Campus int REFERENCES Campuses(Id), 
	Year int, 
	TotalEnrollment int, 
	FTE int
);
