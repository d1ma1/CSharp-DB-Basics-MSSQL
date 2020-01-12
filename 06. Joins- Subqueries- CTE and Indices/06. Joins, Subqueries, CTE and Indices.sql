
/* 01 */

USE SoftUni

SELECT	 TOP(5) e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText
  FROM	 Employees e
  JOIN	 Addresses a
    ON	 a.AddressID = e.AddressID
ORDER BY AddressID

/* 02 */

SELECT TOP(50) e.FirstName, e.LastName, t.Name, a.AddressText FROM
	Employees e
	JOIN Addresses a
	ON a.AddressID = e.AddressID
	JOIN Towns t
	ON t.TownID = a.TownID
	ORDER BY FirstName, LastName

/* 03 */

SELECT e.EmployeeID, e.FirstName, e.LastName, d.Name FROM
	Employees e
	JOIN Departments d
	ON d.DepartmentID = e.DepartmentID
	WHERE (d.Name = 'Sales')
	ORDER BY EmployeeID

/* 04 */

SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.Name FROM
	Employees e
	JOIN Departments d
	ON d.DepartmentID = e.DepartmentID
	WHERE (e.Salary > 15000)
	ORDER BY d.DepartmentID

/* 05 */

SELECT TOP(3) e.EmployeeID, e.FirstName FROM Employees e
	LEFT JOIN EmployeesProjects ep
	ON ep.EmployeeID = e.EmployeeID
	WHERE ep.ProjectID IS NULL
	ORDER BY e.EmployeeID

/* 06 */

SELECT e.FirstName, e.LastName, e.HireDate, d.Name FROM Employees e
	JOIN Departments d
	ON d.DepartmentID = e.DepartmentID
	WHERE e.HireDate > '1.1.1999' AND d.Name IN ('Sales', 'Finance')
	ORDER BY e.HireDate

/* 07 */

SELECT TOP(5) e.EmployeeID, e.FirstName, p.Name FROM Projects p
	JOIN EmployeesProjects ep
	ON ep.ProjectID = p.ProjectID
	JOIN Employees e
	ON e.EmployeeID = ep.EmployeeID
	WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
	ORDER BY e.EmployeeID

/* 08 */

SELECT e.EmployeeID, e.FirstName, 
	CASE
		WHEN p.StartDate >= '2005-01-01' THEN NULL
		ELSE p.Name
	END AS ProjectName 
	FROM Projects p
	JOIN EmployeesProjects ep
	ON ep.ProjectID = p.ProjectID
	JOIN Employees e
	ON e.EmployeeID = ep.EmployeeID
	WHERE e.EmployeeID = 24

/* 09 */

SELECT DISTINCT e.EmployeeID, e.FirstName, e.ManagerID, emp.FirstName AS ManagerName
FROM Employees e
	JOIN Employees emp
	ON emp.EmployeeID = e.ManagerID
	WHERE e.ManagerID IN (3, 7)
	ORDER BY e.EmployeeID

/* 10 */

SELECT TOP(50) e.EmployeeID,
   e.FirstName + ' ' + e.LastName AS EmployeeName,
   m.FirstName + ' ' + m.LastName AS ManagerName,
   d.Name AS DepartmentName
FROM Employees e
	JOIN Employees m
	ON m.EmployeeID = e.ManagerID
	JOIN Departments d
	ON d.DepartmentID = e.DepartmentID
	ORDER BY e.EmployeeID

/* 11 */

SELECT MIN(Avg_Salaries.Avg_Salary) AS MinAverageSalary FROM
(SELECT AVG(Salary) AS Avg_Salary FROM Employees
GROUP BY DepartmentID) AS Avg_Salaries

/* 12 */

USE Geography

SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation FROM Peaks p
	JOIN Mountains m
	ON m.Id = p.MountainId
	JOIN MountainsCountries mc
	ON mc.MountainId = m.Id
	WHERE mc.CountryCode = 'BG' AND p.Elevation > 2835
	ORDER BY p.Elevation DESC

/* 13 */

SELECT mc.CountryCode, COUNT(mc.MountainId) FROM Mountains m
	JOIN MountainsCountries mc
	ON mc.MountainId = m.Id
	GROUP BY mc.CountryCode
	HAVING mc.CountryCode IN ('US','BG','RU')

/* 14 */

SELECT TOP(5) c.CountryName, r.RiverName FROM CountriesRivers cr
	JOIN Rivers r
	ON r.Id = cr.RiverId
	RIGHT JOIN Countries c
	ON c.CountryCode = cr.CountryCode
	WHERE c.ContinentCode = 'AF'
	ORDER BY c.CountryName

/* 15 */

WITH v_currency (ContinentCode, CurrencyCode, c_usage) AS
(SELECT ContinentCode, CurrencyCode, COUNT(*) AS c_usage FROM Countries 
	GROUP BY ContinentCode, CurrencyCode
	HAVING COUNT(*) > 1)

SELECT t1.ContinentCode, v1.CurrencyCode, t1.CurrencyUsage FROM
(SELECT v.ContinentCode, MAX(v.c_usage) AS CurrencyUsage
	FROM v_currency v
	GROUP BY v.ContinentCode) AS t1
JOIN v_currency v1
	ON v1.ContinentCode = t1.ContinentCode AND v1.c_usage = t1.CurrencyUsage

/* 16 */

SELECT COUNT(*) AS CountryCode FROM Countries c
	LEFT JOIN MountainsCountries mc
	ON mc.CountryCode = c.CountryCode
	WHERE mc.MountainId IS NULL
	
/* 17 */

SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS HighestPeakElevation, MAX(r.Length) AS LongestRiverLength FROM Countries c
	JOIN CountriesRivers cr
	ON cr.CountryCode = c.CountryCode
	JOIN Rivers r
	ON r.Id = cr.RiverId
	JOIN MountainsCountries mc
	ON mc.CountryCode = c.CountryCode
	JOIN Mountains m
	ON m.Id = mc.MountainId
	JOIN Peaks p
	ON p.MountainId = m.Id
	GROUP BY c.CountryName
	ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName

/* 18 */

/* --> 
WITH cst_Table(Country, Peak, Elevation, Mountain) AS
(SELECT c.CountryName, p.PeakName, MAX(p.Elevation), m.MountainRange FROM Countries c
	LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
	LEFT JOIN Mountains m ON m.Id = mc.MountainId
	LEFT JOIN Peaks p ON p.MountainId = m.Id
	GROUP BY c.CountryName, p.PeakName, m.MountainRange )
	*/




