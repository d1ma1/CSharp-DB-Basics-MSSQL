
/* 01 */
create database Supermarket

use Supermarket

create table Categories(
	Id int primary key identity,
	Name nvarchar(30) not null
)

create table Items(
	Id int primary key identity,
	Name nvarchar(30) not null,
	Price decimal(15,2) not null,
	CategoryId int foreign key references Categories(Id)
)

create table Employees(
	Id int primary key identity,
	FirstName nvarchar(50) not null,
	LastName nvarchar(50) not null,
	Phone nvarchar(12) check(len(phone)=12),
	Salary decimal(15,2) not null
)

create table Orders(
	Id int primary key identity,
	DateTime Date,
	EmployeeId int foreign key references Employees(Id)
)

create table OrderItems(
	OrderId int foreign key references Orders(Id),
	ItemId int foreign key references Items(Id),
	Quantity int not null check(Quantity >=1),
	CONSTRAINT PK_OrderItems PRIMARY KEY (OrderId,ItemId)
)

create table Shifts(
	Id int not null identity,
	EmployeeId int foreign key references Employees(Id),
	CheckIn date not null,
	CheckOut date not null,
	CONSTRAINT PK_Shifts PRIMARY KEY (Id,EmployeeId)
)

/* 02 */

INSERT INTO Employees VALUES
('Stoyan','Petrov','888-785-8573',500.25),
('Stamat','Nikolov','789-613-1122',999995.25),
('Evgeni','Petkov','645-369-9517',1234.51),
('Krasimir','Vidolov','321-471-9982',50.25)

INSERT INTO Items VALUES
('Tesla battery',154.25,8),
('Chess',30.25,8),
('Juice',5.32,1),
('Glasses',10,8),
('Bottle of water',1,1)

/* 03 */

select * from Items

UPDATE Items
	SET Price = Price + Price*27/100
	WHERE categoryId IN(1, 2, 3)

/* 04 */

DELETE FROM OrderItems
	WHERE OrderId=48

/* 05 */

SELECT Id, FirstName FROM Employees
	WHERE Salary > 6500
	Order by FirstName, Id

/* 06 */

SELECT FirstName + ' ' + LastName AS [Full Name], Phone AS [Phone Number] FROM Employees
 WHERE Phone LIKE '3%'
 ORDER BY FirstName, Phone

/* 07 */

select FirstName, LastName, COUNT(o.Id) AS Count from Employees e
	join Orders o On o.EmployeeId = e.Id
	group by  FirstName, LastName
	order by  COUNT(o.id) desc,  FirstName

/* 08 */

SELECT e.FirstName, e.LastName, AVG(DATEDIFF(HOUR, s.CheckIn, s.CheckOut)) AS [Work hours] FROM Employees e 
	JOIN Shifts s ON e.Id = s.EmployeeId
	GROUP BY  e.FirstName, e.LastName, e.Id
	HAVING AVG(DATEDIFF(hour,  s.CheckIn, s.CheckOut)) >7
	ORDER BY [Work hours] DESC, e.Id

/* 09 */

SELECT TOP(1) oi.OrderId AS OrderId, SUM(i.Price*oi.Quantity) AS [TotalPrice] FROM Items i
	JOIN OrderItems oi ON oi.ItemId = i.Id
	GROUP BY oi.OrderId
	ORDER BY [TotalPrice] DESC

/* 10 */

SELECT TOP(10) oi.OrderId AS OrderId, MAX(i.Price) AS ExpensivePrice, MIN(i.Price) AS CheapPrice FROM Items i
	JOIN OrderItems oi ON oi.ItemId = i.Id
	GROUP BY oi.OrderId
	ORDER BY MAX(i.Price) DESC, oi.OrderId 

/* 11 */

SELECT DISTINCT e.Id, e.FirstName, e.LastName FROM Employees e
	JOIN Orders o ON o.EmployeeId = e.Id
	ORDER BY e.Id

/* 12 */

SELECT DISTINCT e.Id, e.FirstName + ' ' + e.LastName AS [Full Name] FROM Employees e
	JOIN Shifts s ON s.EmployeeId = e.Id
	WHERE DATEDIFF(HOUR, s.CheckIn, s.CheckOut) < 4
	ORDER BY e.Id

/* 13 */

SELECT TOP(10) e.FirstName + ' ' + e.LastName AS [Full Name],
	 SUM(i.Price*oi.Quantity) AS [Total Price], SUM(oi.Quantity) AS Items FROM Employees e
	JOIN Orders o ON o.EmployeeId = e.Id
	JOIN OrderItems oi ON oi.OrderId = o.Id
	JOIN Items i ON i.Id = oi.ItemId
		WHERE o.DateTime < '2018-06-15'
	GROUP BY e.Id, e.FirstName, e.LastName
	ORDER BY [Total Price] DESC, Items DESC

/* 14 */

SELECT e.FirstName + ' ' +e.LastName AS [Full Name], 
 CASE WHEN DATEPART(weekday, s.CheckIn) =1 THEN 'Sunday'
	 WHEN DATEPART(weekday, s.CheckIn) =2 THEN 'Monday'
	 WHEN DATEPART(weekday, s.CheckIn) =3 THEN 'Tuesday'
	 WHEN DATEPART(weekday, s.CheckIn) =4 THEN 'Wednesday'
	 WHEN DATEPART(weekday, s.CheckIn) =5 THEN 'Thursday'
	 WHEN DATEPART(weekday, s.CheckIn) =6 THEN 'Friday'
	 WHEN DATEPART(weekday, s.CheckIn) =7 THEN 'Saturday'
 END
 FROM Employees e
	LEFT JOIN Orders o ON o.EmployeeId = e.Id
	JOIN Shifts s ON s.EmployeeId = e.Id
	WHERE DATEDIFF(HOUR, s.CheckIn, s.CheckOut) > 12 AND o.Id IS NULL
	ORDER BY e.Id

/* 15 */

/*
SELECT e.FirstName + ' ' +e.LastName AS [Full Name],
	DATEDIFF(HOUR, s.CheckIn, s.CheckOut) AS WorkHours,
	SUM(i.Price) AS TotalPrice
	 FROM Employees e
	JOIN Shifts s ON s.EmployeeId = e.Id
	JOIN Orders o ON o.EmployeeId = e.Id
	JOIN OrderItems oi ON oi.OrderId = o.Id
	JOIN Items i on i.Id = oi.ItemId
	GROUP BY e.FirstName, e.LastName, s.CheckIn, s.CheckOut 

SELECT SUM(i.Price*oi.Quantity) FROM Employees e
	JOIN Orders o ON o.EmployeeId = e.Id
	JOIN OrderItems oi ON oi.OrderId = o.Id
	JOIN Items i on i.Id = oi.ItemId */

/* 16 */

SELECT DATEPART(day, o.DateTime) AS Day,
	CAST(AVG(i.Price*oi.Quantity) AS decimal (15,2))  AS [Total profit] FROM Orders o
	JOIN OrderItems oi ON oi.OrderId = o.Id
	JOIN Items i on i.Id = oi.ItemId
	GROUP BY DATEPART(day, o.DateTime)
	ORDER BY DATEPART(day, o.DateTime)

/* 17 */

SELECT i.Name, c.Name, SUM(Quantity) AS Count, SUM(Quantity*Price) AS TotalPrice FROM Items i
	LEFT JOIN OrderItems oi ON oi.ItemId = i.Id
	JOIN Categories c On c.Id = i.CategoryId
	GROUP BY i.Name, c.Name
	ORDER BY TotalPrice DESC, Count DESC

/* 18 */

DROP FUNCTION udf_GetPromotedProducts

CREATE FUNCTION udf_GetPromotedProducts(@CurrentDate date, @StartDate date, @EndDate date,
	 @Discount decimal(15,2), @FirstItemId int, @SecondItemId int, @ThirdItemId int)
RETURNS NVARCHAR(500)
AS BEGIN

	DECLARE @FirstItemPrice DECIMAL(15,2) = (SELECT Price FROM Items i WHERE i.Id = @FirstItemId)
	DECLARE  @SecondItemPrice DECIMAl(15,2) = (SELECT Price FROM Items i WHERE i.Id =  @SecondItemId)
	DECLARE @ThirdItemPrice DECIMAL(15,2) = (SELECT Price FROM Items i WHERE i.Id = @ThirdItemId)

	IF (@FirstItemPrice IS NULL OR @SecondItemPrice IS NULL OR @ThirdItemPrice IS NULL)
		BEGIN
			RETURN 'One of the items does not exists!'
		END
	IF (@CurrentDate<= @StartDate OR @CurrentDate >= @EndDate)
		BEGIN
			RETURN 'The current date is not within the promotion dates!'
		END

	DECLARE @FirstItemName NVARCHAR(50) = (SELECT Name FROM Items i WHERE i.Id = @FirstItemId)
	DECLARE  @SecondItemName NVARCHAR(50) = (SELECT Name FROM Items i WHERE i.Id =  @SecondItemId)
	DECLARE @ThirdItemName NVARCHAR(50) = (SELECT Name FROM Items i WHERE i.Id = @ThirdItemId)

	DECLARE @NewFirstItemPrice DECIMAL(15,2) = @FirstItemPrice - (@FirstItemPrice * @Discount / 100)
	DECLARE @NewSecondItemPrice DECIMAL(15,2) = @SecondItemPrice - (@SecondItemPrice * @Discount / 100)
	DECLARE @NewThirdItemPrice DECIMAL(15,2) = @ThirdItemPrice - (@ThirdItemPrice * @Discount / 100)

	RETURN @FirstItemName + ' price: ' + CAST(ROUND(@NewFirstItemPrice,2) as varchar) + ' <-> ' +
		   @SecondItemName + ' price: ' + CAST(ROUND(@NewSecondItemPrice,2) as varchar)+ ' <-> ' +
		   @ThirdItemName + ' price: ' + CAST(ROUND(@NewThirdItemPrice,2) as varchar)
END
	
SELECT dbo.udf_GetPromotedProducts('2018-08-02', '2018-08-01', '2018-08-03',13, 3,4,5)
SELECT dbo.udf_GetPromotedProducts('2018-08-02', '2018-08-01', '2018-08-03',13, 3,4,5)

/* 19 */

DROP PROC usp_CancelOrder

	CREATE PROC usp_CancelOrder(@OrderId int, @CancelDate date) AS

		DECLARE @date date = (SELECT DateTime FROM Orders WHERE Id = @OrderId)

		IF (SELECT Id FROM Orders WHERE Id = @OrderId) IS NULL
			BEGIN
				RAISERROR ('The order does not exist!', 16,1)
			END

		ELSE IF DATEDIFF(DAY,@date,@CancelDate) >3
			BEGIN
				RAISERROR ('You cannot cancel the order!', 16, 1)
			END
		ELSE
			BEGIN
				DELETE FROM OrderItems WHERE OrderId = @OrderId
				DELETE FROM Orders WHERE Id = @OrderId
			END

EXEC usp_CancelOrder 1, '2018-06-02'
SELECT COUNT(*) FROM Orders
SELECT COUNT(*) FROM OrderItems

/* 20 */

CREATE TABLE DeletedOrders(
	OrderId INT NOT NULL,
	 ItemId INT NOT NULL,
	  ItemQuantity INT NOT NULL
)

CREATE TRIGGER tr_Deleted ON OrderItems AFTER DELETE AS
	BEGIN
		INSERT INTO DeletedOrders
		SELECT d.OrderId, d.ItemId, d.Quantity FROM deleted d
	END

