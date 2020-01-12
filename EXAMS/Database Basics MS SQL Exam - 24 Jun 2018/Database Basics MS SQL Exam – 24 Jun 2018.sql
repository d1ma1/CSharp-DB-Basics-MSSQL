create database TripService

/* 01 */

CREATE TABLE Cities(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(20) NOT NULL,
	CountryCode CHAR(2) NOT NULL
)

CREATE TABLE Hotels(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	CityId INT FOREIGN KEY REFERENCES Cities(Id),
	EmployeeCount INT NOT NULL,
	BaseRate DECIMAL(15,2)
)

CREATE TABLE Rooms(
	Id INT PRIMARY KEY IDENTITY,
	Price DECIMAL(15,2) NOT NULL,
	Type NVARCHAR(20),
	Beds INT NOT NULL,
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id)
)

CREATE TABLE Trips(
	Id INT PRIMARY KEY IDENTITY,
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id),
	BookDate DATE NOT NULL,
	ArrivalDate DATE NOT NULL,
	ReturnDate DATE NOT NULL,
	CancelDate DATE,
	CONSTRAINT CK_BookDate_ArrivalDate CHECK (BookDate < ArrivalDate),
    CONSTRAINT CK_ArrivalDate_ReturnDate CHECK (ArrivalDate < ReturnDate),
)

CREATE TABLE Accounts(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(20),
	LastName NVARCHAR(50) NOT NULL,
	CityId INT FOREIGN KEY REFERENCES Cities(Id), 
	BirthDate DATE NOT NULL,
	Email NVARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE AccountsTrips(
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id), 
	TripId INT FOREIGN KEY REFERENCES Trips(Id), 
	Luggage INT NOT NULL CHECK(Luggage >=0),
	CONSTRAINT PK_AccountsTrips PRIMARY KEY (AccountId,TripId)
)

/* 02 */

INSERT INTO Accounts VALUES
('John','Smith','Smith',34,'1975-07-21','j_smith@gmail.com'),
('Gosho',NULL,'Petrov',11,'1978-05-16','g_petrov@gmail.com'),
('Ivan','Petrovich','Pavlov',59,'1849-09-26','i_pavlov@softuni.bg'),
('Friedrich','Wilhelm','Nietzsche',2,'1844-10-15','f_nietzsche@softuni.bg')


INSERT INTO Trips VALUES
(101,'2015-04-12','2015-04-14','2015-04-20','2015-02-02'),
(102,'2015-07-07','2015-07-15','2015-07-22','2015-04-29'),
(103,'2013-07-17','2013-07-23','2013-07-24',NULL),
(104,'2012-03-17','2012-03-31','2012-04-01','2012-01-10'),
(109,'2017-08-07','2017-08-28','2017-08-29',NULL)

/* 03 */

UPDATE Rooms
	SET Price = Price + Price*14/100
	WHERE HotelId IN (5, 7, 9)

/* 04 */

DELETE FROM AccountsTrips WHERE AccountId = 47

/* 05 */

SELECT Id, Name FROM Cities WHERE CountryCode = 'BG' ORDER BY Name

/* 06 */

SELECT CASE WHEN MiddleName IS NULL THEN FirstName + ' ' + LastName
		ELSE FirstName + ' ' + MiddleName + ' ' + LastName
	END AS [Full Name], 
	 DATEPART(YEAR, BirthDate) AS BirthYear  FROM Accounts a
	 WHERE DATEPART(YEAR, BirthDate) > 1991
	 ORDER BY BirthYear DESC, FirstName

/* 07 */

SELECT a.FirstName, a.LastName,
	format(a.BirthDate, 'MM-dd-yyyy'),
	c.Name, a.Email FROM Accounts a
	JOIN Cities c ON c.Id = a.CityId
	WHERE LEFT(a.Email,1) = 'e'
	ORDER BY c.Name DESC
	
/* 08 */

SELECT c.Name, COUNT(h.Id) FROM Cities c
	LEFT JOIN Hotels h ON h.CityId = c.Id
	GROUP BY c.Name
	ORDER BY COUNT(h.Id) DESC, c.Name

/* 09 */

SELECT r.Id, Price, h.Name, c.Name FROM Rooms r
	JOIN Hotels h ON h.Id = r.HotelId
	JOIN Cities c ON c.Id = h.CityId
	WHERE r.Type = 'First Class'
	ORDER BY r.Price DESC, r.Id

/* 10 */

SELECT a.Id, a.FirstName + ' ' + a.LastName, 
	MAX(DATEDIFF(DAY, ArrivalDate, ReturnDate)) AS LongestTrip,
	MIN(DATEDIFF(DAY, ArrivalDate, ReturnDate)) FROM Accounts a
	JOIN AccountsTrips at ON at.AccountId = a.Id
	JOIN Trips t ON t.Id = at.TripId
	WHERE a.MiddleName IS NULL AND CancelDate IS NULL
	GROUP BY a.Id,  a.FirstName, a.LastName
	ORDER BY LongestTrip DESC, a.Id

/* 11 */

SELECT TOP 5 c.Id, c.Name, c.CountryCode, COUNT(a.Id) FROM Cities c
	JOIN Accounts a ON a.CityId = c.Id
	GROUP BY c.Id, c.Name, c.CountryCode
	ORDER BY  COUNT(a.Id) DESC

/* 12 */

SELECT a.Id, a.Email, c.Name, COUNT(at.AccountId) FROM Accounts a
	JOIN AccountsTrips at ON at.AccountId = a.Id
	JOIN Trips t ON t.Id = at.TripId
	JOIN Rooms r ON r.Id = t.RoomId
	JOIN Hotels h ON h.Id = r.HotelId
	JOIN Cities c ON c.Id = h.CityId
	WHERE h.CityId = a.CityId
	GROUP BY a.Id, a.Email, c.Name
	ORDER BY COUNT(t.Id) DESC, a.Id

/* 13 */

SELECT TOP 10 c.Id,c.Name, SUM(ho.BaseRate + r.Price) AS TOTAL, COUNT(t.Id) FROM Cities c
	JOIN Hotels ho ON ho.CityId = c.Id
	JOIN Rooms r ON r.HotelId = ho.Id
	JOIN Trips t ON t.RoomId = r.Id
		WHERE DATEPART(YEAR, BookDate) = 2016
	GROUP BY c.Id,c.Name
	ORDER BY TOTAL DESC, COUNT(t.Id) DESC

/* 14 */

SELECT at.TripId, ho.Name, r.Type, 
	 CASE WHEN t.CancelDate IS NOT NULL THEN 0
		ELSE 
		SUM(ho.BaseRate + r.Price)
	END
	AS TOTAL FROM Hotels ho
	JOIN Rooms r ON r.HotelId = ho.Id
	JOIN Trips t ON t.RoomId = r.Id
	JOIN AccountsTrips at ON at.TripId = t.Id
	GROUP BY  at.TripId, ho.Name, r.Type,  t.CancelDate 
	ORDER BY r.Type, at.TripId

/* 15 */

SELECT Id, Email, CountryCode, Trips FROM(
SELECT a.Id as Id, a.Email as Email, c.CountryCode as CountryCode, COUNT(*) AS Trips,
	 DENSE_RANK() OVER(PARTITION BY c.CountryCode ORDER BY COUNT(*) DESC, a.Id) AS rank1
FROM Accounts a
 JOIN AccountsTrips AT on A.Id = AT.AccountId
        JOIN Trips T on AT.TripId = T.Id
        JOIN Rooms R on T.RoomId = R.Id
        JOIN Hotels H on R.HotelId = H.Id
        JOIN Cities C on H.CityId = C.Id
	GROUP BY a.Id, a.Email, c.CountryCode) AS tt
	where rank1 = 1
	ORDER BY Trips DESC, Id

/* 16 */

SELECT a.TripId, SUM(a.Luggage), 
	CASE WHEN SUM(a.Luggage) > 5
		THEN '$' + CAST(SUM(a.Luggage)*5 as VARCHAR(10))
		ELSE '$0'
	END AS Fee 
	FROM AccountsTrips a
	GROUP BY a.TripId
	HAVING SUM(a.Luggage) > 0
	ORDER BY SUM(a.Luggage) DESC

/* 17 */

SELECT t.Id,
	CASE WHEN MiddleName IS NULL THEN FirstName + ' ' + LastName
		ELSE FirstName + ' ' + MiddleName + ' ' + LastName
	END AS [Full Name],
	(Select cc.Name FROM Cities cc WHERE cc.Id = a.CityId) AS [From],
	(Select cc.Name FROM Cities cc WHERE cc.Id = ho.CityId) AS [To],
	CASE WHEN t.CancelDate IS NULL THEN
		CAST(DATEDIFF(DAY, t.ArrivalDate, t.ReturnDate) as NVARCHAR(10)) + ' days'
		ELSE 'Canceled'
	END AS Duration
	 FROM Accounts a
	JOIN AccountsTrips at ON at.AccountId = a.Id
	JOIN Trips t ON t.Id =  at.TripId
	JOIN Rooms r ON r.Id = t.RoomId
	JOIN Hotels ho ON ho.Id = r.HotelId
	JOIN Cities c ON c.Id = ho.CityId
	ORDER BY [Full Name], t.Id

/* 18 */

CREATE FUNCTION udf_GetAvailableRoom(@HotelId int, @Date date, @People int)
	RETURNS NVARCHAR(200)
	AS
		BEGIN
			/*
			DECLARE @arrivalDate DATE = (SELECT ArrivalDate FROM Trips t join Rooms r ON r.Id = t.RoomId where HotelId = @HotelId)
			DECLARE @returnDate DATE = (SELECT ReturnDate FROM Trips t join Rooms r ON r.Id = t.RoomId where HotelId = @HotelId)
			DECLARE @cancelDate DATE = (SELECT CancelDate FROM Trips t join Rooms r ON r.Id = t.RoomId where HotelId = @HotelId)

			IF (@Date NOT BETWEEN @arrivalDate AND @returnDate) OR( @cancelDate IS NOT NULL)
				 RETURN 'No rooms available';
				 
			DECLARE @Holtel INT = (SELECT r.Id FROM Trips t join Rooms r ON r.Id = t.RoomId where HotelId = @HotelId);
			IF @Holtel IS NOT NULL
				RETURN 'No rooms available';

			DECLARE @beds INT = (SELECT r.Beds FROM Trips t join Rooms r ON r.Id = t.RoomId where HotelId = @HotelId);
			IF @People > @beds
				RETURN 'No rooms available';
			*/	
			DECLARE @Tabl TABLE
			(
				Id INT,
				TYPE NVARCHAR(20),
				Beds INT,
				RATE DECIMAL(15,2),
				PRICE DECIMAL(15,2)
			)
			
			INSERT INTO @Tabl 
			SELECT TOP 1 r.Id as roomId, r.Type as type, r.Beds as beds, h.BaseRate as rate, r.Price as price FROM Hotels h
											JOIN Rooms r ON r.HotelId = h.Id
											 WHERE h.Id = @HotelId
											 ORDER BY rate, price DESC
			
			DECLARE @rId INT = (SELECT Id FROM @Tabl)
			DECLARE @type NVARCHAR(20) = (SELECT type FROM @Tabl)
			DECLARE @bed INT = (SELECT Beds FROM @Tabl)
			DECLARE @rate DECIMAL(15,2) = (SELECT RATE FROM @Tabl)
			DECLARE @price DECIMAL(15,2) = (SELECT PRICE FROM @Tabl)

			IF @rId IS NULL
				 RETURN 'No rooms available';

			RETURN CONCAT('Room ', cast(@rId as varchar(20)),': ', @type, ' (', cast(@bed as varchar(20)), ' beds) - $', cast((@rate + @price)*@People as varchar(20)))
		END

SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)










