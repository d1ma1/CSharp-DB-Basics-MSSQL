
/* 01 */

SELECT FirstName, LastName FROM Employees
	WHERE FirstName LIKE 'SA%'

/* 02 */

SELECT FirstName, LastName FROM Employees
	WHERE LastName LIKE '%ei%'

/* 03 */

SELECT FirstName FROM Employees
	WHERE DepartmentID IN(3,10) AND YEAR(HireDate) BETWEEN 1995 AND 2005

/* 04 */

SELECT FirstName, LastName FROM Employees
	WHERE JobTitle NOT LIKE '%engineer%'

/* 05 */

SELECT Name from Towns
	WHERE LEN(Name) =5 OR LEN(Name) =6
	ORDER BY Name

/* 06 */

SELECT TownId, Name from Towns
	WHERE Name LIKE 'M%' OR Name LIKE 'K%' OR Name LIKE 'B%' OR Name LIKE 'E%' 
	ORDER BY Name

/* 07 */

SELECT TownId, Name from Towns
	WHERE Name NOT LIKE 'R%' AND Name NOT LIKE 'B%' AND Name NOT LIKE 'D%' 
	ORDER BY Name

/* 08 */

CREATE VIEW  V_EmployeesHiredAfter2000 AS
	SELECT FirstName, LastName FROM Employees
	WHERE YEAR(HireDate)>2000

/* 09 */

SELECT FirstName, LastName FROM Employees
	WHERE LEN(LastName) = 5

/* 10 */

SELECT CountryName, IsoCode FROM Countries
	WHERE LEN(CountryName) - LEN(REPLACE(CountryName,'a','')) >=3
	ORDER BY IsoCode

/* 11 */

SELECT p.PeakName, r.RiverName, LOWER(p.PeakName + SUBSTRING(r.RiverName, 2, LEN(r.RiverName)-1)) AS mix
FROM Peaks AS p, Rivers AS r
	WHERE RIGHT(p.PeakName,1) = LEFT(r.RiverName,1)
	ORDER BY mix

/* 12 */

SELECT TOP(50) Name, FORMAT(Start, 'yyyy-MM-dd') AS Start FROM Games
	WHERE YEAR(Start) = 2011 OR  YEAR(Start) = 2012
	ORDER BY Start, Name

/* 13 */

SELECT UserName, SUBSTRING(Email, CHARINDEX('@', Email)+1, 50) AS [Email Provider] FROM Users
	ORDER BY [Email Provider], UserName

/* 14 */

SELECT Username, IpAddress FROM Users
	WHERE IpAddress LIKE '___.1%.%.___'
	ORDER BY Username

/* 15 */

SELECT Name, 
	CASE
		WHEN DATEPART(HOUR, Start) >=0 AND DATEPART(HOUR, Start) <12 Then 'Morning'
		WHEN DATEPART(HOUR, Start) >=12 AND DATEPART(HOUR, Start) <18 Then 'Afternoon'
		ELSE 'Evening'
	END	
	AS [Part of the Day],
	CASE
		WHEN Duration <=3 Then 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6 Then 'Short'
		WHEN Duration IS NULL Then 'Extra Long'
		ELSE 'Long'
	END	
	AS Duration
 FROM Games
 ORDER BY Name, Duration, [Part of the Day]

/* 16 */

SELECT ProductName, OrderDate, DATEADD(DAY, 3, OrderDate) AS [Pay Due], DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
  FROM Orders

/* 17 */

CREATE TABLE People(
	Id INT PRIMARY KEY IDENTITY, 
	Name NVARCHAR(50) NOT NULL, 
	Birthdate DATE NOT NULL
)

INSERT INTO People VALUES
	('Victor','2000-12-07 00:00:00.000'),
	('Steven','1992-09-10 00:00:00.000'),
	('Stephen','1910-09-19 00:00:00.000'),
	('John','2010-01-06 00:00:00.000')

SELECT Name, DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
	DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],	
	DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],	
	DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
	FROM People

SELECT * FROM People
