
/* 01 */

SELECT COUNT(*) AS Count FROM WizzardDeposits

/* 02 */

SELECT MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits

/* 03 */

SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits
	GROUP BY DepositGroup

/* 04 */

SELECT TOP(2) DepositGroup FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize)

/* 05 */

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
	GROUP BY DepositGroup
	
/* 06 */

SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

/* 07 */

SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount)  < 150000
	ORDER BY SUM(DepositAmount) DESC

/* 08 */

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator
	ORDER BY MagicWandCreator  ASC, DepositGroup ASC

/* 09 */
	
SELECT 
	CASE
		WHEN Age BETWEEN 0 AND 10  Then '[0-10]'
		WHEN Age BETWEEN 11 AND 20  Then '[11-20]'
		WHEN Age BETWEEN 21 AND 30  Then '[21-30]'
		WHEN Age BETWEEN 31 AND 40  Then '[31-40]'
		WHEN Age BETWEEN 41 AND 50  Then '[41-50]'
		WHEN Age BETWEEN 51 AND 60  Then '[51-60]'
		ELSE '[61+]'
	END	
	AS AgeGroup,
	COUNT(*) AS WizardCount
FROM WizzardDeposits
GROUP BY
	CASE
		WHEN Age BETWEEN 0 AND 10  Then '[0-10]'
		WHEN Age BETWEEN 11 AND 20  Then '[11-20]'
		WHEN Age BETWEEN 21 AND 30  Then '[21-30]'
		WHEN Age BETWEEN 31 AND 40  Then '[31-40]'
		WHEN Age BETWEEN 41 AND 50  Then '[41-50]'
		WHEN Age BETWEEN 51 AND 60  Then '[51-60]'
		ELSE '[61+]'
	END	

/* 10 */

SELECT LEFT(FirstName, 1) AS FirstLetter FROM WizzardDeposits
	WHERE DepositGroup = 'Troll Chest'
	GROUP BY LEFT(FirstName, 1)
	ORDER BY FirstLetter

/* 11 */

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) FROM WizzardDeposits
	WHERE DepositStartDate > '01-01-1985'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired ASC

/* 12 */

SELECT SUM(XX.DIFF) AS SumDifference
FROM (SELECT DepositAmount - (SELECT DepositAmount FROM WizzardDeposits WHERE Id = g.Id + 1) 
AS DIFF FROM WizzardDeposits g) AS XX

/* 13 */

SELECT DepartmentID, SUM(Salary) AS TotalSalary FROM Employees
	GROUP BY DepartmentID
	ORDER BY DepartmentID

/* 14 */

SELECT DepartmentID, MIN(Salary) AS MinimumSalary FROM Employees
	WHERE DepartmentID IN(2,5,7) AND Hiredate > '01/01/2000'
	GROUP BY DepartmentID

/* 15 */

SELECT * INTO Emp FROM Employees 
	WHERE Salary > 30000

DELETE FROM Emp
	WHERE ManagerID = 42

UPDATE Emp
	SET Salary += 5000
	WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary FROM Emp
	GROUP BY DepartmentID

/* 16 */

SELECT DepartmentID, MAX(Salary) AS MaxSalary FROM Employees
	GROUP BY DepartmentID
	HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

/* 17 */

SELECT COUNT(*) AS Count FROM Employees
	WHERE ManagerID IS NULL

/* 18 */

SELECT DepartmentID, 
	(SELECT DISTINCT Salary FROM Employees WHERE DepartmentID = e.DepartmentID ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY) AS ThirdHighestSalary
	FROM Employees e
		WHERE (SELECT DISTINCT Salary FROM Employees WHERE DepartmentID = e.DepartmentID ORDER BY Salary DESC OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY) IS NOT NULL
		GROUP BY DepartmentID

/* 19 */

SELECT Top(10) FirstName, LastName, DepartmentID FROM Employees e
	WHERE Salary > 
	(SELECT AVG(Salary) FROM Employees GROUP BY DepartmentID HAVING DepartmentID = e.DepartmentID)
	ORDER BY DepartmentID 