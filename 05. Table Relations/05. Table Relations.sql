/* 1 */
CREATE DATABASE Relations

CREATE TABLE Passports(
	PassportID INT PRIMARY KEY,
	PassportNumber NVARCHAR(20) NOT NULL
)

CREATE TABLE Persons(
	PersonID INT PRIMARY KEY,
	FirstName NVARCHAR(20) NOT NULL,
	Salary DECIMAL (15,2),
	PassportID INT FOREIGN KEY REFERENCES Passports(PassportID)
)

INSERT INTO Passports VALUES
(101,'N34FG21B'),
(102,'K65LO4R7'),
(103,'ZE657QP2')

INSERT INTO Persons VALUES 
(1,'Roberto','43300.00','102'),
(2,'Tom','56100.00','103'),
(3,'Yana','60200.00','101')

/* 2 */

CREATE TABLE Manufacturers(
	ManufacturerID INT PRIMARY KEY,
	Name NVARCHAR(50),
	EstablishedOn DATETIME2
)

CREATE TABLE Models(
	ModelID INT PRIMARY KEY,
	Name NVARCHAR(50),
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers VALUES
(1,'BMW','07/03/1916'),
(2,'Tesla','01/01/2003'),
(3,'Lada','01/05/1966')

INSERT INTO Models VALUES
(101,'X1','1'),
(102,'i6','1'),
(103,'Model S','2'),
(104,'Model X','2'),
(105,'Model 3','2'),
(106,'Nova','3')

/* 3 */

CREATE TABLE Students(
	StudentID INT PRIMARY KEY,
	Name NVARCHAR(30) NOT NULL
)

CREATE TABLE Exams(
	ExamID INT PRIMARY KEY,
	Name NVARCHAR(30) NOT NULL
)

CREATE TABLE StudentsExams(
	StudentID INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT NOT NULL FOREIGN KEY REFERENCES Exams(ExamID),
)

ALTER TABLE StudentsExams
	ADD CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentID, ExamID)

INSERT INTO Students VALUES
(1, 'Mila'),
(2,'Toni'),
(3,'Ron')

INSERT INTO Exams VALUES
(101,'SpringMVC'),
(102,'Neo4j'),
(103,'Oracle 11g')

INSERT INTO StudentsExams VALUES
(1,'101'),
(1,'102'),
(2,'101'),
(3,'103'),
(2,'102'),
(2,'103')

/* 4 */

CREATE TABLE Teachers(
	TeacherID INT NOT NULL PRIMARY KEY,
	Name NVARCHAR(30) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101)

/* 5 */

CREATE DATABASE Store

USE Store

CREATE TABLE Cities(
	CityID INT PRIMARY KEY,
	Name VARCHAR(50)
)

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY,
	Name VARCHAR(50),
	Birthday DATE,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders(
	OrderID INT PRIMARY KEY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE ItemTypes(
	ItemTypeID INT PRIMARY KEY,
	NAME VARCHAR(50)
)

CREATE TABLE Items(
	ItemID INT PRIMARY KEY,
	Name VARCHAR(50),
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE OrderItems(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID),

	CONSTRAINT PR_OrderItems 
	PRIMARY KEY (OrderID, ITemID)
)

/* 6 */

CREATE DATABASE University

USE University

CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY,
	SubjectName NVARCHAR(50)
)

CREATE TABLE Majors(
	MajorID INT PRIMARY KEY,
	Name NVARCHAR(50)
)

CREATE TABLE Students(
	StudentID INT PRIMARY KEY,
	StudentNumber INT NOT NULL,
	StudentName NVARCHAR(50) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Agenda(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),

	CONSTRAINT PK_Students_Subjects
	PRIMARY KEY(StudentID, SubjectID)
)

CREATE TABLE Payments(
	PaymentID INT PRIMARY KEY,
	PaymentDate DATE,
	PaymantAmount INT NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

/* 7 */

/* 8 */

/* 9 */