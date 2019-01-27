
/* 01 */

CREATE TABLE Users(

	Id INT PRIMARY KEY IDENTITY,
	Username NVARCHAR(30) NOT NULL UNIQUE,
	Password NVARCHAR(50) NOT NULL,
	Name NVARCHAR(50),
	Gender CHAR(1) CHECK (Gender in ('F','M')),
	BirthDate DATE,
	Age INT,
	Email NVARCHAR(50) NOT NULL
)

CREATE TABLE Departments(

	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

CREATE TABLE Employees(

	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(25),
	LastName NVARCHAR(25),
	Gender CHAR(1) CHECK(Gender IN('M','F')),
	BirthDate DATE,
	Age INT,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Categories(

	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NUll,
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Status(

	Id INT PRIMARY KEY IDENTITY,
	Label NVARCHAR(30) NOT NUll,
)

CREATE TABLE Reports(
	Id INT PRIMARY KEY IDENTITY,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	StatusId INT FOREIGN KEY REFERENCES Status(Id),
	OpenDate DATE NOT NULL,
	CloseDate DATE,
	Description NVARCHAR(200),
	UserId  INT FOREIGN KEY REFERENCES Users(Id),
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
)

/* 02 */

INSERT INTO Employees(FirstName, LastName, Gender, BirthDate, DepartmentId) VALUES
('Marlo','O’Malley','M','9/21/1958',1),
('Niki','Stanaghan','F','11/26/1969',4),
('Ayrton','Senna','M','03/21/1960 ',9),
('Ronnie','Peterson','M','02/14/1944',9),
('Giovanna','Amati','F','07/20/1959',5)

INSERT INTO Reports VALUES
(1,1,'04/13/2017',NULL,'Stuck Road on Str.133',6,2),
(6,3,'09/05/2015','12/06/2015','Charity trail running',3,5),
(14,2,'09/07/2015',NULL,'Falling bricks on Str.58',5,2),
(4,3,'07/03/2017','07/06/2017','Cut off streetlight on Str.11',1,1)

/* 03 */

UPDATE Reports
	SET StatusId = 2
	WHERE StatusId = 1 AND CategoryId = 4

/* 04 */

DELETE FROM Reports
	WHERE StatusId = 4

/* 05 */

SELECT Username, Age FROM Users
	ORDER BY Age, Username DESC

/* 06 */

SELECT Description, OpenDate FROM Reports
	WHERE EmployeeId IS NULL
	ORDER BY OpenDate, Description

/* 07 */

SELECT e.FirstName, e.LastName, r.Description, CONVERT(char(10),r.OpenDate,126) AS OpenDate FROM Employees e
	JOIN Reports r
	ON r.EmployeeId = e.Id
	ORDER BY e.Id, r.OpenDate, r.Id

/* 08 */

SELECT c.Name, COUNT(*) AS ReportsNumber FROM Reports r
	JOIN Categories c
	ON c.Id = r.CategoryId
	GROUP BY c.Name
	ORDER BY  COUNT(*) DESC, c.Name

/* 09 */

SELECT c.Name, COUNT(*) FROM Departments d
	JOIN Categories c
	ON c.DepartmentId = d.Id
	JOIN Employees e
	ON e.DepartmentId = d.Id
	GROUP BY c.Name
	ORDER BY c.Name

/* 10 */

SELECT e.FirstName + ' ' + e.LastName AS Name, COUNT(r.UserId) AS [Users Number] FROM Employees e
	LEFT JOIN Reports r
	ON r.EmployeeId = e.Id
	GROUP BY e.FirstName, e.LastName
	ORDER BY  COUNT(r.UserId) DESC, e.FirstName, e.LastName

/* 11 */

SELECT r.OpenDate, r.Description, u.Email AS [Reporter Email] FROM Reports r
	JOIN Categories c
	ON c.Id = r.CategoryId
	JOIN Departments d
	ON d.Id = c.DepartmentId
	JOIN Users u
	ON u.Id = r.UserId
	WHERE r.CloseDate IS NULL AND LEN(r.Description) > 20 AND r.Description LIKE '%str%'
		AND d.Name IN ('Infrastructure', 'Emergency', 'Roads Maintenance')
	ORDER BY r.OpenDate, u.Email, r.Id

/* 12 */

SELECT DISTINCT c.Name AS [Category Name] FROM Users u
	JOIN Reports r ON r.UserId = u.Id
	JOIN Categories c ON c.Id = r.CategoryId
	WHERE MONTH(r.OpenDate) = MONTH(u.BirthDate) AND DAY(r.OpenDate) = DAy(u.BirthDate)
	ORDER BY c.Name

/* 13 */

SELECT u.Username FROM Users u
	JOIN Reports r ON r.UserId = u.Id
	WHERE (u.Username LIKE '[0-9]%' AND CAST(r.CategoryId AS varchar(1))= LEFT(u.Username,1))
		OR (u.Username LIKE '%[0-9]' AND CAST(r.CategoryId AS varchar(1))= RIGHT(u.Username,1))
	ORDER BY  u.Username

/* 14 */

SELECT e.FirstName + ' ' + e.LastName AS [Name], 
		CAST(COUNT(r.CloseDate) AS varchar(1)) +'/'+ CAST(COUNT(r.OpenDate) AS varchar(1)) AS [Closed Open Reports] FROM Employees e
	JOIN Reports r ON r.EmployeeId = e.Id
	WHERE (YEAR(r.OpenDate) = 2016 AND YEAR(r.CloseDate) IS NULL) oR YEAR(r.CloseDate) = 2016
	GROUP BY e.FirstName, e.LastName, r.EmployeeId
	ORDER BY e.FirstName, e.LastName, r.EmployeeId

/* 15 */

SELECT d.Name, ISNULL(CAST(AVG(DATEDIFF(DAY, OpenDate, CloseDate)) AS varchar(10)),'no info') FROM Reports r
	JOIN Categories c ON c.Id = r.CategoryId
	JOIN Departments d ON d.Id = c.DepartmentId
	GROUP BY d.Name
	ORDER BY d.Name

/* 16 */

/* 17 */

CREATE FUNCTION udf_GetReportsCount(@employeeId INT, @statusId INT) 
RETURNS INT
AS
BEGIN
	RETURN (
		SELECT COUNT(*) FROM Reports 
		WHERE StatusId = @statusId AND EmployeeId = @employeeId
	)
END

/* 18 */

DROP PROC usp_AssignEmployeeToReport

CREATE PROC usp_AssignEmployeeToReport(@employeeId INT, @reportId INT) AS
BEGIN
if ( (SELECT DepartmentId FROM Employees WHERE Id = @employeeId) =
		 (SELECT c.DepartmentId FROM Reports r JOIN Categories c ON c.Id = r.CategoryId WHERE r.Id = @reportId))
		UPDATE Reports
		SET EmployeeId = @employeeId
		WHERE Id = @reportId
	ELSE
		BEGIN
			RAISERROR('Employee doesn''t belong to the appropriate department!', 16, 1)
			RETURN
		END
END
		
EXEC usp_AssignEmployeeToReport 17, 2;
SELECT EmployeeId FROM Reports WHERE id = 2

/* 19 */

CREATE TRIGGER close_reports ON Reports
AFTER UPDATE AS
	BEGIN 
		UPDATE Reports
		SET StatusId = 3
		WHERE Id = (SELECT Id
		    FROM inserted AS i
		    WHERE CloseDate IS NOT NULL)
	END

UPDATE Reports
SET CloseDate = GETDATE()
WHERE EmployeeId = 5;

/* 20 */


