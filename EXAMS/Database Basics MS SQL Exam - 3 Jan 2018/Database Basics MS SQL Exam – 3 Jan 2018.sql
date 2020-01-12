
/* 01 */

CREATE DATABASE RentACar

USE RentACar

CREATE TABLE Clients (

	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Gender CHAR(1) CHECK (Gender in ('M', 'F')),
	BirthDate DATETIME,
	CreditCard NVARCHAR(30) NOT NULL,
	CardValidity DATETIME,
	Email NVARCHAR(50) NOT NULL
)

CREATE TABLE Towns (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

CREATE TABLE Offices (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(40),
	ParkingPlaces INT,
	TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Models (
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer NVARCHAR(50) NOT NULL,
	Model NVARCHAR(50) NOT NULL,
	ProductionYear DATETIME,
	Seats INT,
	Class NVARCHAR(10),
	Consumption DECIMAL(14,2)
)

CREATE TABLE Vehicles(
	Id INT PRIMARY KEY IDENTITY,
	ModelId INT FOREIGN KEY REFERENCES Models(Id),
	OfficeId INT FOREIGN KEY REFERENCES Offices(Id),
	Mileage INT
)

CREATE TABLE Orders (
	Id INT PRIMARY KEY IDENTITY,
	ClientId INT FOREIGN KEY REFERENCES Clients(id),
	TownId INT FOREIGN KEY REFERENCES Towns(id),
	VehicleId INT FOREIGN KEY REFERENCES Vehicles(Id),
	CollectionDate DATETIME NOT NULL,
	CollectionOfficeId INT FOREIGN KEY REFERENCES Offices(Id),
	ReturnDate DATETIME,
	--ReturnOfficeId  INT FOREIGN KEY REFERENCES Offices(Id),
	Bill DECIMAL(14, 2),
	TotalMileage INT
)

/* 02 */

INSERT INTO Models VALUES 
('Chevrolet', 'Astro', '2005-07-27 00:00:00.000', 4, 'Economy', 12.60),
('Toyota', 'Solara', '2009-10-15 00:00:00.000', 4, 'Family', 13.80),
('Volvo', 'S40', '2010-10-12 00:00:00.000', 3, 'Average', 11.30),
('Suzuki', 'Swift', '2000-02-03 00:00:00.000', 7, 'Economy', 16.20)

INSERT INTO Orders VALUES
(17,2,52,'2017-08-08' ,30,'2017-09-04' ,42,2360.00,7434),
(78,17,50,'2017-04-22',10,'2017-05-09' ,12,2326.00,7326),
(27,13,28,'2017-04-25' ,21,'2017-05-09' ,34,597.00,1880)

/* 03 */

UPDATE Models
	SET Class = 'Luxury'
	WHERE Consumption > 20

/* 04 */

DELETE FROM Orders
	WHERE ReturnDate IS NULL

/* 05 */

SELECT Manufacturer, Model FROM Models
	ORDER BY Manufacturer, Id DESC

/* 06 */

SELECT FirstName, LastName FROM Clients
	WHERE BirthDate BETWEEN '1977-01-01' AND '1994-12-31'
	ORDER BY FirstName, LastName, Id

/* 07 */

SELECT t.Name AS TownName, o.Name AS OfficeName, o.ParkingPlaces FROM Offices o
	JOIN Towns t
	ON t.Id = o.TownId
	WHERE ParkingPlaces > 25
	ORDER BY t.Name, o.Id
	
/* 08 */

SELECT m.Model, m.Seats, v.Mileage FROM Vehicles v
	JOIN Models m
	ON m.Id = v.ModelId
    WHERE v.Id <> ALL(SELECT o.VehicleId 
                         FROM Orders o 
                        WHERE o.ReturnDate IS NULL)
	ORDER BY v.Mileage, m.Seats DESC, m.Id

/* 09 */

SELECT t.Name, COUNT(*) FROM Towns t
	JOIN Offices o
	ON o.TownId = t.Id
	GROUP BY t.Name, o.TownId
	ORDER BY COUNT(o.TownId) DESC, t.Name

/* 10 */

SELECT m.Manufacturer, m.Model, COUNT(o.Id) AS TimesOrdered FROM Vehicles v
    LEFT JOIN Orders o
	ON o.VehicleId = v.Id
    LEFT JOIN Models m
	ON m.Id = v.ModelId
	GROUP BY  m.Manufacturer, m.Model
	ORDER BY COUNT(o.Id) DESC,  m.Manufacturer DESC, m.Model

/* 11 */

WITH cte_Table AS (
SELECT c.FirstName + ' ' + c.LastName AS Name, m.Class, DENSE_RANK() OVER(PARTITION BY c.FirstName, c.LastName ORDER BY COUNT(m.Class) DESC) AS [Rank] FROM Clients c
	JOIN Orders o
	ON o.ClientId = c.Id
	JOIN Vehicles v
	on v.Id = o.VehicleId
	JOIN Models m
	ON m.Id = v.ModelId
	GROUP BY c.FirstName, c.LastName, m.Class
	)

SELECT cte.Name, cte.Class FROM cte_Table cte
	 WHERE cte.[Rank] = 1
	 ORDER BY cte.Name, cte.Class

/* 12 */

SELECT 
		 CASE 
			WHEN YEAR(c.BirthDate) >= 1970 AND YEAR(c.BirthDate) <= 1979 THEN '70' + char(39) + 's'
			WHEN YEAR(c.BirthDate) >= 1980 AND YEAR(c.BirthDate) <= 1989 THEN '80' + char(39) + 's'
			WHEN YEAR(c.BirthDate) >= 1990 AND YEAR(c.BirthDate) <= 1999 THEN '90' + char(39) + 's'
			ELSE 'Others'
		 END AS AgeGroup, SUM(o.Bill) AS Revenue, AVG(o.TotalMileage) AS AverageMileage
	FROM Clients c
	JOIN Orders o
	ON o.ClientId = c.Id
	GROUP BY 
		 CASE 
			WHEN YEAR(BirthDate) >= 1970 AND YEAR(BirthDate) <= 1979 THEN '70' + char(39) + 's'
			WHEN YEAR(BirthDate) >= 1980 AND YEAR(BirthDate) <= 1989 THEN '80' + char(39) + 's'
			WHEN YEAR(BirthDate) >= 1990 AND YEAR(BirthDate) <= 1999 THEN '90' + char(39) + 's'
			ELSE 'Others'
		 END

/* 13 */

WITH cte_Table AS (
SELECT TOP(7) COUNT(o.VehicleId), m.Manufacturer, AVG(m.Consumption) AS AverageConsumption  FROM Orders o
	JOIN Vehicles v
	ON v.Id = o.VehicleId
	JOIN Models m
	ON m.Id = v.ModelId
	GROUP BY m.Manufacturer
	ORDER BY COUNT(o.VehicleId) DESC
	)

SELECT cte.Manufacturer, cte.AverageConsumption FROM cte_Table cte
