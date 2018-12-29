/* Problem 1 */

CREATE DATABASE Minions

/* Problem 2 */

CREATE TABLE Minions (
	Id INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	Age INT
)

CREATE TABLE Towns (
	Id INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL
)

/* Problem 3 */

ALTER TABLE Minions
ADD TownId INT

ALTER TABLE Minions
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)

/* Problem 4 */

INSERT INTO Towns (Id, [Name]) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions (Id, [Name], Age, TownId) VALUES
(1, 'Kevin', 22, 1),
(2, 'BOB', 15, 3),
(3, 'Steward', NULL, 2)

/* Problem 5 */

DELETE FROM Minions

/* Problem 6 */

DROP TABLE Minions
DROP TABLE Towns

/* Problem 7 */

CREATE TABLE People (
	Id INT UNIQUE IDENTITY NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(2),
	Height  float(15),
	[Weight] FLOAT(15),
	Gender CHAR(1) NOT NULL CHECK (Gender IN('m', 'f')),
	Birthdate DATE NOT NULL,
	Biography NVARCHAR(max)
)

ALTER TABLE People
ADD CONSTRAINT PK_People
   PRIMARY KEY(Id) 

INSERT INTO People ([Name], Picture, Height, [Weight], Gender, Birthdate, Biography) VALUES 
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')
('Dima', NULL,12.5,1.33, 'f', '01-25-1980', 'Student in SofUni ....')

/* Problem 8 */

CREATE TABLE Users (
	Id INT UNIQUE IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] NVARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(2),
	LastLoginTime DATE,
	IsDeleted BIT NOT NULL 
)

ALTER TABLE Users
	ADD CONSTRAINT PK_Users PRIMARY KEY (Id)

INSERT INTO Users (Username,[Password], ProfilePicture, LastLoginTime, IsDeleted) VALUES
	('Klara', 1213141516, NULL, '01/01/2018', 0),
	('Petrov', 1213141516, NULL, '01/01/2018', 0),
	('Goshov', 1213141516, NULL, '01/01/2018', 0),
	('Milev', 1213141516, NULL, '01/01/2018', 0),
	('Ceco', 1213141516, NULL, '01/01/2018', 0)

SELECT * FROM Users

/* Problem 9 */

ALTER TABLE Users
	DROP CONSTRAINT PK_Users

ALTER TABLE Users
	ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

/* Problem 10 */

ALTER TABLE Users
	ADD CONSTRAINT CHK_Password CHECK (LEN([Password]) > 4)

/* Problem 11 */

ALTER TABLE Users
	ADD CONSTRAINT df_Time DEFAULT GETDATE() FOR LastLoginTime;

/* Problem 12 */

ALTER TABLE Users
	DROP CONSTRAINT PK_Users

ALTER TABLE Users
	ADD CONSTRAINT PK_Users PRIMARY KEY (Id)

ALTER TABLE Users
	ADD CONSTRAINT uq_Username UNIQUE(Username)

ALTER TABLE Users
	ADD CONSTRAINT ch_Username CHECK(LEN(Username) > 2)

/* Problem 13 */

CREATE DATABASE Movies

CREATE TABLE Directors(
	Id INT PRIMARY KEY NOT NULL,
	DirectorName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(500)
)

CREATE TABLE Genres(
	Id INT PRIMARY KEY NOT NULL,
	GenreName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(500)
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY NOT NULL,
	CategoryName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(500)
)

CREATE TABLE Movies(
	Id INT PRIMARY KEY,
	Title NVARCHAR(30) NOT NULL,
	DirectorId INT FOREIGN KEY(Id) REFERENCES Directors(Id),
	CopyrightYear INT NOT NULL,
	[Length] TIME,
	GenreId INT FOREIGN KEY(Id) REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY(Id) REFERENCES Categories(Id),
	Rating INT,
	Notes NVARCHAR(500)
)

INSERT INTO Directors VALUES 
(1, 'Tarantino', NULL),
(2, 'Tarantino', NULL),
(3, 'Krieger', NULL),
(4, 'Tarantino', NULL),
(5, 'Tarantino', NULL)

INSERT INTO Genres VALUES 
(1, 'comedy', NULL),
(2, 'triller', NULL),
(3, 'drama', NULL),
(4, 'krimi', NULL),
(5, 'romance', NULL)

INSERT INTO Categories VALUES 
(1, 'cat1', 'afafa'),
(2, 'cat2', NULL),
(3, 'cat3', NULL),
(4, 'cat4', NULL),
(5, 'cat5', NULL)

INSERT INTO Movies VALUES 
(1, 'The age of Adaline', 3, 2015, '1:52:00', 5, 1, 10, NULL),
(2, 'The age of Adaline', 3, 2015, '1:52:00', 5, 1, 10, NULL),
(3, 'The age of Adaline', 3, 2015, '1:52:00', 5, 1, 10, NULL),
(4, 'The age of Adaline', 3, 2015, '1:52:00', 5, 1, 10, NULL),
(5, 'The age of Adaline', 3, 2015, '1:52:00', 5, 1, 10, NULL)

/* Problem 14 */

CREATE DATABASE CarRental

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	CategoryName NVARCHAR(50) NOT NULL,
	DailyRate DECIMAL(15,2),
	WeeklyRate DECIMAL(15,2),
	MonthlyRate DECIMAL(15,2),
	WeekendRate DECIMAL(15,2)
)

INSERT INTO Categories VALUES
('CatName1', 18.1, 22,44,666),
('CatName2', 18.1, 22,44,666),
('CatName3', 18.1, 22,44,666)

CREATE TABLE Cars (
	Id INT PRIMARY KEY IDENTITY,
	PlateNumber NVARCHAR(20) NOT NULL UNIQUE,
	Manufacturer NVARCHAR(30) NOT NULL,
	Model NVARCHAR(30) NOT NULL,
	CarYear INT NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Doors INT,
	Picture VARBINARY(max),
	Condition NVARCHAR(500),
	Available BIT NOT NULL
)

INSERT INTO Cars VALUES
	('AE1288FD', 'Audi', 'A6', 2000, 1, 4, NULL, NULL, 0),
	('AE1288FK', 'Audi', 'A6', 2000, 1, 4, NULL, NULL, 0),
	('AE1288FS', 'Audi', 'A6', 2000, 1, 4, NULL, NULL, 0)

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Title NVARCHAR(30),
	Notes NVARCHAR(500)
)

INSERT INTO Employees VALUES
	('Gosho', 'Goshev', 'Tehnik', NULL),
	('Gosho', 'Goshev', 'Техник', NULL),
	('Gosho', 'Goshev', 'Tehnik', NULL)

CREATE TABLE Customers(
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber INT NOT NULL,
	FullName NVARCHAR(50) NOT NULL,
	[Address] NVARCHAR(100),
	City NVARCHAR(30),
	ZIPCode INT,
	Notes NVARCHAR(200)
)

INSERT INTO Customers VALUES
	(1919, 'Ivan Ivanov', NULL, 'Sofia', 1000, 'хх'),
	(1919, 'Ivan Ivanov', NULL, 'Sofia', 1000, ''),
	(1919, 'Ivan Ivanov', NULL, 'Sofia', 1000, '  ')

CREATE TABLE RentalOrders(
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id), 
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id), 
	CarId INT FOREIGN KEY REFERENCES Cars(Id), 
	TankLevel INT, 
	KilometrageStart INT, 
	KilometrageEnd INT,
	TotalKilometrage AS KilometrageEnd - KilometrageStart, 
	StartDate DATE, 
	EndDate DATE, 
	TotalDays AS DATEDIFF(DAY,StartDate, EndDate),
	RateApplied INT, 
	TaxRate INT,
	OrderStatus BIT NOT NULL, 
	Notes NVARCHAR(200)
)

INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, TaxRate, OrderStatus, Notes) VALUES
	(2, 2, 3, 20, 30000,  4000, '2007-08-08', '2007-08-10', 123, 234, 0, NULL),
	(2, 2, 3, 20, 30000,  4000, '2007-08-08', '2007-08-10', 123, 234, 0, NULL),
	(2, 2, 3, 20, 30000,  4000, '2007-08-08', '2007-08-10', 123, 234, 0, NULL)

/* Problem 15 */

CREATE DATABASE Hotel

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY, 
	FirstName NVARCHAR(20) NOT NULL,
	LastName  NVARCHAR(20) NOT NULL,
	Title NVARCHAR(50), 
	Notes  NVARCHAR(200)
)

INSERT INTO Employees VALUES 
	('Ivan', 'Ivanov', 'Pikolo', 'A good picolo'),
	('Maria', 'Ivanova', 'Reception', NULL),
	('Ivan', 'Petrov', 'Second Pikolo', 'Not so good picolo')

CREATE TABLE Customers (
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(20) NOT NULL,
	LastName  NVARCHAR(20) NOT NULL,
	PhoneNumber NVARCHAR(10),
	EmergencyName NVARCHAR(50),
	EmergencyNumber INT,
	Notes  NVARCHAR(200)
)

INSERT INTO Customers  VALUES 
	('John','Stamatov','0886633311', 'Test1', 123, NULL),
	('Krasi','Kolev','0886623311', 'Test2', 123, NULL),
	('Vanq','Stamatova','0896633311', 'Test3', NULL, NULL)

CREATE TABLE RoomStatus (
	RoomStatus NVARCHAR(20) PRIMARY KEY NOT NULL,
	Notes  NVARCHAR(200)
)

INSERT INTO RoomStatus (RoomStatus, Notes) VALUES 
	('reserved', NULL),
	('free', NULL),
	('occupied', NULL)

CREATE TABLE RoomTypes (
	RoomType NVARCHAR(20) PRIMARY KEY NOT NULL,
	Notes  NVARCHAR(200)
)

INSERT INTO RoomTypes (RoomType, Notes) VALUES 
	('one person', NULL),
	('two persons', NULL),
	('appartment', NULL)

CREATE TABLE BedTypes (
	BedType NVARCHAR(20) PRIMARY KEY NOT NULL,
	Notes  NVARCHAR(200)
)

INSERT INTO BedTypes (BedType, Notes) VALUES 
	('single', NULL),
	('double', NULL),
	('sofa', NULL)

CREATE TABLE Rooms (
	RoomNumber INT PRIMARY KEY IDENTITY,
	RoomType NVARCHAR(20) FOREIGN KEY REFERENCES RoomTypes(RoomType),
	BedType NVARCHAR(20) FOREIGN KEY REFERENCES BedTypes(BedType),
	Rate INT,
	RoomStatus NVARCHAR(20) FOREIGN KEY REFERENCES RoomStatus(RoomStatus),
	Notes  NVARCHAR(200)
)

INSERT INTO Rooms VALUES 
	('one person', 'single', 7, 'free',NULL),
	('two persons', 'single', 7, 'free',NULL),
	('one person', 'single', 7, 'free',NULL)

CREATE TABLE Payments (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	PaymentDate DATE,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	FirstDateOccupied DATE,
	LastDateOccupied DATE,
	TotalDays INT,
	AmountCharged INT,
	TaxRate INT,
	TaxAmount INT,
	PaymentTotal INT,
	Notes  NVARCHAR(200)
)

INSERT INTO Payments VALUES 
	(1, NULL, 1, NULL, NULL, 5, 123, 11,1,1234, NULL),
	(1, NULL, 1, NULL, NULL, 5, 123, 11,1,1234, NULL),
	(1, NULL, 1, NULL, NULL, 5, 123, 11,1,1234, NULL)

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	DateOccupied DATE,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
	RoomNumber INT,
	RateApplied INT,
	PhoneCharge NVARCHAR(10),
	Notes  NVARCHAR(200)
)

INSERT INTO Occupancies VALUES 
	(1, NULL, 1, 2, 11, '023344', NULL),
	(1, NULL, 1, 2, 11, '023344', NULL),
	(1, NULL, 1, 2, 11, '023344', NULL)


/* Problem 16 */

CREATE DATABASE SoftUni

CREATE TABLE Towns (	
	Id INT IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

ALTER TABLE Towns
	ADD CONSTRAINT pr_Key PRIMARY KEY (Id)

CREATE TABLE Addresses (	
	Id INT IDENTITY,
	AddressText NVARCHAR(50),
	TownId INT
)

ALTER TABLE Addresses
	ADD CONSTRAINT pr_Key_Adresses PRIMARY KEY (Id)

ALTER TABLE Addresses
	ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)

CREATE TABLE Departments (	
	Id INT IDENTITY,
	Name NVARCHAR(50) NOT NULL
)

ALTER TABLE Departments
	ADD CONSTRAINT pr_Key_Departments PRIMARY KEY (Id)

CREATE TABLE Employees (	
	Id INT IDENTITY,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50) NOT NULL,
	JobTitle  NVARCHAR(50) NOT NULL,
	DepartmentId INT,
	HireDate DATE,
	Salary DECIMAL(15,2),
	AddressId INT
)

ALTER TABLE Employees
	ADD CONSTRAINT pr_Key_Employees PRIMARY KEY (Id)

ALTER TABLE Employees
	ADD FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)

ALTER TABLE Employees
	ADD FOREIGN KEY (AddressId) REFERENCES Addresses(Id)

/* Problem 17 */

BACKUP DATABASE SoftUni
	TO DISK = 'C:\Users\Dima Dimova\Desktop\DB\SoftUni.bak';

DROP DATABASE SoftUni

RESTORE DATABASE SoftUni  
   FROM DISK = 'C:\Users\Dima Dimova\Desktop\DB\SoftUni.bak'; 

/* Problem 18 */

INSERT INTO Towns VALUES
	('Sofia'),
	('Plovdiv'),
	('Varna'),
	('Burgas')

INSERT INTO Departments VALUES
	('Engineering'),
	('Sales'),
	('Marketing'),
	('Software Development'),
	('Quality Assurance')

INSERT INTO Employees(FirstName,  MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary) VALUES
	('Ivan','Ivanov','Ivanov', '.NET Developer', 4, '02/01/2013', 3500.00),
	('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '03/02/2004', 4000.00),
	('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '08/28/2016', 525.25),
	('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '12/09/2007', 3000.00),
	('Peter', 'Pan', 'Pan', 'Intern', 3, '08/28/2016', 599.88)

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Name],JobTitle, Departments.[Name], HireDate, Salary FROM Employees
	JOIN Departments
	ON Departments.Id = DepartmentId;

/* Problem 19 */

SELECT * FROM Towns

SELECT * FROM Departments 

SELECT * FROM Employees 

/* Problem 20 */

SELECT * FROM Towns ORDER BY [Name]

SELECT * FROM Departments ORDER BY [Name]

SELECT * FROM Employees ORDER BY Salary DESC

/* Problem 21 */

SELECT [Name] FROM Towns ORDER BY [Name]

SELECT [Name] FROM Departments ORDER BY [Name]

SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

/* Problem 22 */

UPDATE Employees SET Salary = Salary * 1.1

SELECT Salary FROM Employees

/* Problem 23 */

UPDATE Payments SET TaxRate = TaxRate * 0.97

SELECT TaxRate FROM Payments

/* Problem 23 */

DELETE FROM Occupancies 