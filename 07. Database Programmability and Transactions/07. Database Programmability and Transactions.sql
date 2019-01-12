
/* 01 */

USE SoftUni

CREATE PROC usp_GetEmployeesSalaryAbove35000 AS
	SELECT e.FirstName, e.LastName FROM Employees e
	WHERE e.Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000

/* 02 */

CREATE PROC usp_GetEmployeesSalaryAboveNumber  (@param DECIMAL(18,4)) AS
	SELECT e.FirstName, e.LastName FROM Employees e
	WHERE e.Salary >= @param

EXEC usp_GetEmployeesSalaryAboveNumber 48100

/* 03 */

CREATE PROC usp_GetTownsStartingWith (@param VARCHAR(50)) AS
	SELECT t.Name AS Town FROM Towns t
	WHERE Name LIKE @param + '%'

EXEC usp_GetTownsStartingWith 'b'

/* 04 */

CREATE PROC usp_GetEmployeesFromTown (@townName VARCHAR(50)) AS
	SELECT e.FirstName, e.LastName FROM Employees e
	JOIN Addresses a
	ON a.AddressID = e.AddressID
	JOIN Towns t
	ON t.TownID = a.TownID
	WHERE t.Name LIKE @townName

EXEC usp_GetEmployeesFromTown 'Sofia'

/* 05 */

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(50)
As
BEGIN
	DECLARE @result VARCHAR(50);
	IF @salary < 30000 SET @result= 'Low'
	ELSE IF @salary <= 50000 SET @result= 'Average'
	ELSE SET @result= 'High'
	RETURN @result;
END

/* 06 */

CREATE PROC usp_EmployeesBySalaryLevel(@param VARCHAR(50)) AS
	SELECT FirstName, LastName FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @param

EXEC usp_EmployeesBySalaryLevel 'High';

/* 07 */

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(50)) 
RETURNS BIT 
AS
	BEGIN
		DECLARE @i INT = 1
		WHILE (@i <= LEN(@word))
			BEGIN
				IF CHARINDEX(SUBSTRING(@word, @i, 1), @setOfLetters)=0
					BEGIN
						RETURN 0
					END
				SET @i+=1;
			END
		RETURN 1
	END

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')

/* 08 */

BACKUP DATABASE SoftUni
TO DISK = 'C:\Users\Dima Dimova\Desktop\DB\SoftUni.bak';
/*
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT) AS
	

	ALTER TABLE Employee DROP CONSTRAINT FK_Employees_Adresses
	ALTER TABLE Employee DROP CONSTRAINT FK_Employees_Departments
	ALTER TABLE Employee DROP CONSTRAINT FK_Employees_Employees

	ALTER TABLE Departments DROP CONSTRAINT FK_Departments_Employees

	DELETE FROM Departments WHERE DepartmentID = @departmentId
	DELETE FROM Employees WHERE DepartmentID = @departmentId
	SELECT COUNT(*) FROM Employees WHERE DepartmentID = @departmentId

EXEC usp_DeleteEmployeesFromDepartment 7
select * from Employees

*/
RESTORE DATABASE SoftUni
   FROM DISK = 'C:\Users\Dima Dimova\Desktop\DB\SoftUni.bak'

/* 09 */

USE Bank

CREATE PROC usp_GetHoldersFullName AS
	SELECT a.FirstName + ' ' +a.LastName AS [Full Name] FROM AccountHolders a

EXEC usp_GetHoldersFullName

/* 10 */

CREATE PROC usp_GetHoldersWithBalanceHigherThan(@number DECIMAL(15,2)) AS
	SELECT a.FirstName, a.LastName FROM AccountHolders a
	JOIN ACCOUNTS acc ON acc.AccountHolderId = a.Id 
	GROUP BY a.FirstName, a.LastName 
	HAVING SUM(acc.Balance) > @number

/* 11 */

DROP FUNCTION ufn_CalculateFutureValue

CREATE FUNCTION ufn_CalculateFutureValue (@I DECIMAL(15,2), @R FLOAT,@T INT)
RETURNS DECIMAL(15,4)
AS
	BEGIN
		RETURN  @I*(POWER((1+ @R), @T))
	END

SELECT dbo.ufn_CalculateFutureValue(1000,0.1,5)

/* 12 */

DROP PROC usp_CalculateFutureValueForAccount

CREATE PROCEDURE usp_CalculateFutureValueForAccount (@AccountId INT, @IR DECIMAL(15,4))
AS
	SELECT acc.Id AS [Account Id],
		 ah.FirstName AS [First Name], 
		 ah.LastName AS [Last Name],
		 acc.Balance AS [Current Balance],
		 dbo.ufn_CalculateFutureValue(acc.Balance,@IR,5) AS [Balance in 5 years]
	FROM Accounts acc
	JOIN AccountHolders ah
	ON ah.Id = acc.AccountHolderId
	WHERE acc.Id= @AccountId

EXEC usp_CalculateFutureValueForAccount 1, 0.1

/* 13 */

DROP DATABASE Diablo 
USE Diablo 

CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(50))
RETURNS TABLE 
AS
	RETURN (
		SELECT SUM(Cash) AS SumCash FROM 
		(SELECT  ug.Cash, ROW_NUMBER() OVER(ORDER BY CASH DESC) AS row_num
			FROM UsersGames AS ug
			JOIN GAMES g
			ON g.Id = ug.GameId
			WHERE g.Name = @gameName) AS AllGameRows
			WHERE row_num%2 =1
    )

SELECT * FROM dbo.ufn_CashInUsersGames('Lily Stargazer')

/* 14 */

Use Bank

CREATE TABLE Logs(
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id), 
	OldSum DECIMAL(15,2) NOT NULL,
	NewSum DECIMAL(15,2) NOT NULL
)

CREATE TRIGGER Log_change ON Accounts
 AFTER UPDATE
 AS 
 BEGIN
	INSERT INTO Logs (AccountId, OldSum, NewSum)
	SELECT i.Id, d.Balance, i.Balance FROM inserted i
	JOIN deleted d
	ON d.Id = i.Id
END

/* 15 */

CREATE TABLE NotificationEmails(
	Id INT PRIMARY KEY IDENTITY, 
	Recipient INT FOREIGN KEY REFERENCES Accounts(Id),
	Subject NVARCHAR(50), 
	Body NVARCHAR(50)
)

CREATE TRIGGER SendEmail ON Logs
AFTER INSERT
AS
	INSERT INTO NotificationEmails
	SELECT AccountId, 
		'Balance change for account: ' + CAST(AccountId AS varchar(20)),
		'On ' + CONVERT(VARCHAR(50), GETDATE(), 100) +' your Balance was changed from '+
			 CAST(OldSum AS varchar(20)) + ' to ' + CAST(NewSum AS varchar(20)) + '.'
	FROM inserted

/* 16 */

CREATE PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15,4)) AS
	
	BEGIN TRANSACTION

		UPDATE Accounts
		SET Balance += @MoneyAmount
		WHERE Id = @AccountId

	COMMIT

/* 17 */

CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(15,4)) AS
	
	BEGIN TRANSACTION

		UPDATE Accounts
		SET Balance -= @MoneyAmount
		WHERE Id = @AccountId

		DECLARE @Balance DECIMAL(15,4) = (SELECT Balance FROM Accounts WHERE Id = @AccountId)

		IF (@Balance - @MoneyAmount<0) 
			BEGIN
				RAISERROR('Invalid operation', 16, 2)
				ROLLBACK
			END

	COMMIT
	
/* 18 */

CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15,4)) AS

	EXEC usp_WithdrawMoney @SenderId, @Amount
	EXEC usp_DepositMoney @ReceiverId, @Amount

/* 19 */

USE Diablo

/* 20 */

/* 21 */

USE SoftUni

CREATE PROC usp_AssignProject(@emloyeeId INT, @projectID INT) AS
	
	BEGIN TRANSACTION
		INSERT INTO EmployeesProjects VALUES
		(@emloyeeId, @projectID)

		DECLARE @count INT = (SELECT COUNT(ProjectID) FROM EmployeesProjects WHERE EmployeeId = @emloyeeId )
		IF (@count > 3)
			BEGIN
				ROLLBACK
				RAISERROR('The employee has too many projects!', 16, 1)
			END
	COMMIT

/* 22 */

CREATE TABLE Deleted_Employees(
	 EmployeeId INT PRIMARY KEY IDENTITY, 
	 FirstName NVARCHAR(50) NOT NULL,
	 LastName NVARCHAR(50) NOT NULL, 
	 MiddleName NVARCHAR(50), 
	 JobTitle NVARCHAR(50), 
	 DepartmentId INT FOREIGN KEY REFERENCES Departments(DepartmentId),
	 Salary DECIMAL(15,2)
) 

CREATE TRIGGER Fired ON Employees 
AFTER DELETE
AS
	INSERT INTO Deleted_Employees 
	SELECT d.FirstName, d.LastName, d.MiddleName, d.JobTitle, d.DepartmentID, d.Salary
	FROM deleted d