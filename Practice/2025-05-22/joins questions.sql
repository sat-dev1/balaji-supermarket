2025-05-22 

USE AdventureWorks2022;

 --1. List all sales orders (Sales.SalesOrderHeader) along with customer names from Sales.Customer. 
	
SELECT top 5 * from Sales.SalesOrderHeader;
SELECT top 5 * FROM sales.customer;

SELECT 
	sso.SalesOrderID,sso.DueDate,sso.CustomerID,sso.TotalDue,sc.CustomerID 
FROM 
	sales.SalesOrderHeader sso
	LEFT JOIN sales.Customer sc 
ON sso.CustomerID = sc.CustomerID

--2. Show all products (Production.Product) and their subcategory names (Production.ProductSubcategory). 

SELECT top 5 * FROM  Production.Product;
SELECT top 5 * from Production.ProductSubcategory;

SELECT
	spp.*, spps.Name 
FROM
	Production.Product spp
LEFT JOIN  	Production.ProductSubcategory spps
ON spp.ProductSubcategoryID = spps.ProductSubcategoryID
WHERE spps.ProductSubcategoryID is NOT NULL;

--3. Get ProductID, Name, and ListPrice for all products along with their category name. 

SELECT top 5 * FROM Production.product;
SELECT top 5 * FROM Production.ProductSubcategory;
SELECT top 5 * FROM Production.ProductCategory;

SELECT 
	pp.ProductID,pp.NAME,pp.ListPrice,ppc.Name
FROM  Production.product pp
LEFT JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID 
LEFT JOIN  Production.ProductCategory ppc ON pps.ProductCategoryID = ppc.ProductCategoryID
	

--4. List all employees (HumanResources.Employee) with their corresponding department name (HumanResources.EmployeeDepartmentHistory, HumanResources.Department). 

SELECT top 5 * FROM HumanResources.Employee;
SELECT top 5 * FROM HumanResources.EmployeeDepartmentHistory;
SELECT top 5 * FROM HumanResources.Department;

SELECT hre.BusinessEntityID,hre.JobTitle,hre.BirthDate,hrd.Name AS DepartmentName
FROM HumanResources.Employee hre
LEFT JOIN  HumanResources.EmployeeDepartmentHistory hredh ON hre.BusinessEntityID = hredh.BusinessEntityID
LEFT JOIN  HumanResources.Department hrd ON hredh.DepartmentID = hrd.DepartmentID

--5. Show a list of all vendors (Purchasing.Vendor) and the products they supply.
	
SELECT top 5 * FROM Purchasing.ProductVendor; 
SELECT top 5 * FROM Production.Product;
	
SELECT
	ppv.BusinessEntityID,ppv.StandardPrice,pp.ProductID,pp.NAME AS ProductName
FROM Purchasing.ProductVendor ppv
LEFT JOIN Production.Product pp ON ppv.ProductID = pp.ProductID

--6. Show SalesOrderID, OrderDate, and CustomerID using a FULL OUTER JOIN between Sales.SalesOrderHeader and Sales.Customer. 

SELECT 
	ssoh.SalesOrderID,ssoh.OrderDate,sc.CustomerID
FROM
	Sales.SalesOrderHeader ssoh
FULL OUTER JOIN Sales.Customer sc ON ssoh.CustomerID = sc.CustomerID;


--7. Retrieve all customers (Sales.Customer) and SalesOrderIDs , even if they haven’t placed orders. 
	
SELECT sc.CustomerID,sc.StoreID,ssoh.SalesOrderID,ssoh.purchaseOrderNumber,ssoh.SalesOrderNumber
FROM
	Sales.SalesOrderHeader ssoh
LEFT JOIN Sales.Customer sc ON ssoh.CustomerID = sc.CustomerID

--8. Get all employees and their job titles and add a column using CASE to label them as ‘Senior’ if JobTitle contains ‘Manager’, else ‘Staff’. 

SELECT top 5 * FROM HumanResources.Employee
	
SELECT hre.BusinessEntityID,hre.JobTitle,
CASE
	WHEN OrganizationLevel = 2 THEN 'senior'
	ELSE 'Staff'
END  AS OrganizationNameName
FROM HumanResources.Employee hre

--9. List first 20 customer full names (Person.Person) using CONCAT(FirstName, ' ', LastName) who have placed at least one order. 
	
SELECT top 5 * from Person.Person;
SELECT top 5 * from Sales.SalesOrderHeader;
SELECT TOP 5 * FROM Sales.Customer

SELECT TOP 20 
	pp.FirstName,
	pp.MiddleName,
	pp.LastName,
	CONCAT (FirstName, ' ', MiddleName, ' ', LastName) As FullName
FROM
	Person.Person pp
JOIN Sales.Customer sc ON pp.BusinessEntityID = sc.PersonID
LEFT JOIN (SELECT DISTINCT CustomerID FROM sales.SalesOrderHeader) dc ON dc.CustomerID = sc.CustomerID;


--10. List product names where the ProductNumber starts with ‘BK’ using LEFT(ProductNumber, 2) and join with their subcategory. 
SELECT top 5 * FROM Production.ProductSubcategory;
	
SELECT pp.Name AS ProductName,pp.ProductNumber,pps.ProductSubcategoryID,pps.Name,CONCAT (left(ProductNumber,2),pps.Name)AS NewName
FROM 
	Production.product pp
JOIN Production.ProductSubcategory pps 
ON	pp.ProductSubcategoryID = pps.ProductSubcategoryID
WHERE pp.ProductNumber Like 'BK%'  
 

--11. List SalesOrderID, CustomerID, FirstName, LastName, OrderDate using joins between Sales.SalesOrderHeader, Sales.Customer, Person.Person. 
SELECT top 5 * FROM Sales.SalesOrderHeader
SELECT top 5 * FROM Sales.Customer
SELECT top 5 * FROM Person.Person
SELECT top 5 * from Person.BusinessEntityContact;
	--way 1
SELECT sc.CustomerID,ssoh.SalesOrderID,ssoh.OrderDate,pp.FirstName,pp.LastName
FROM sales.Customer sc
LEFT JOIN Person.BusinessEntityContact pbec ON sc.PersonID = pbec.PersonID
LEFT JOIN Sales.SalesOrderHeader ssoh ON sc.CustomerID = ssoh.CustomerID 
LEFT JOIN Person.Person pp ON pp.BusinessEntityID = pbec.BusinessEntityID

SELECT sc.CustomerID,ssoh.SalesOrderID,ssoh.OrderDate,pp.FirstName,pp.LastName
FROM sales.Customer sc
FULL OUTER JOIN Person.BusinessEntityContact pbec ON sc.PersonID = pbec.PersonID
FULL OUTER JOIN Sales.SalesOrderHeader ssoh ON sc.CustomerID = ssoh.CustomerID 
FULL OUTER JOIN Person.Person pp ON pp.BusinessEntityID = pbec.BusinessEntityID

	--way 2
	
SELECT sc.CustomerID,ssoh.SalesOrderID,ssoh.OrderDate,pp.FirstName,pp.LastName
FROM Person.Person pp
LEFT JOIN Person.BusinessEntityContact pbec ON pp.BusinessEntityID = pbec.BusinessEntityID
LEFT JOIN sales.Customer sc ON sc.PersonID = pbec.PersonID 
LEFT JOIN Sales.SalesOrderHeader ssoh ON sc.CustomerID = ssoh.CustomerID


--12. For each product, show product name, subcategory, and category name using 3 joins. 
SELECT top 5 * FROM Production.Product
SELECT top 5 * FROM Production.ProductCategory;
SELECT top 5 * FROM Production.ProductSubcategory;
	--Same
SELECT
	pp.Name AS ProductName,
	pps.Name As SubcategoryName,
	ppc.Name As CategoryName
FROM 
	Production.Product pp
LEFT JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID 
JOIN Production.ProductCategory ppc ON pps.ProductCategoryID = ppc.ProductCategoryID

	SELECT pp.Name AS ProductName,pps.Name As SubcategoryName,ppc.Name As CategoryName
	FROM Production.Product pp
	JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID 
	JOIN Production.ProductCategory ppc ON pps.ProductCategoryID = ppc.ProductCategoryID

	--SAME
	SELECT pp.Name AS ProductName,pps.Name As SubcategoryName,ppc.Name As CategoryName
	FROM Production.Product pp
	LEFT JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID 
	LEFT JOIN Production.ProductCategory ppc ON pps.ProductCategoryID = ppc.ProductCategoryID
	
	SELECT pp.Name AS ProductName,pps.Name As SubcategoryName,ppc.Name As CategoryName
	FROM Production.Product pp
	FULL OUTER JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID 
	FULL OUTER JOIN Production.ProductCategory ppc ON pps.ProductCategoryID = ppc.ProductCategoryID

	 

--13. Show all employees with their full name and department name, and calculate how many years 
--they’ve worked at the company using DATEDIFF(YEAR, HireDate, GETDATE()). 

	SELECT TOP 5 * FROM HumanResources.Department;
	SELECT TOP 5 * FROM HumanResources.EmployeeDepartmentHistory
	SELECT TOP 5 * FROM Person.Person;

	SELECT pp.BusinessEntityID,hrd.DepartmentID,hrd.Name AS DepartmentName, CONCAT (FirstName, ' ', MiddleName, ' ', LastName) As EmployeeFullName
	FROM Person.Person pp
	LEFT JOIN HumanResources.EmployeeDepartmentHistory hedh ON pp.BusinessEntityID = hedh.BusinessEntityID
	LEFT JOIN HumanResources.Department hrd ON hedh.DepartmentID = hrd.DepartmentID 

	SELECT pp.BusinessEntityID,hrd.DepartmentID,hrd.Name AS DepartmentName, CONCAT (FirstName, ' ', MiddleName, ' ', LastName) As EmployeeFullName
	FROM Person.Person pp
	FULL OUTER JOIN HumanResources.EmployeeDepartmentHistory hedh ON pp.BusinessEntityID = hedh.BusinessEntityID
	FULL OUTER JOIN HumanResources.Department hrd ON hedh.DepartmentID = hrd.DepartmentID 


--14. List all vendors and how many products they supply using COUNT(*) and GROUP BY (join Purchasing.Vendor and Purchasing.ProductVendor). 
	
		SELECT TOP 5 * FROM Purchasing.ProductVendor
		SELECT TOP 5 * FROM Purchasing.Vendor

		SELECT
			ppv.BusinessEntityID,
			COUNT(*) AS NO_Of_products
		FROM	
			Purchasing.ProductVendor ppv
			LEFT JOIN Purchasing.Vendor pv ON ppv.BusinessEntityID = pv. BusinessEntityID
		GROUP BY 
			ppv.BusinessEntityID

--15. Retrieve all orders with OrderDate, TotalDue, and a derived column that 
--shows whether the order is “High Value” if TotalDue > 1000, else “Normal” using CASE. 
	
	SELECT TOP 5 * FROM Sales.SalesOrderHeader
	SELECT 
		OrderDate,
		TotalDue,
	CASE
		WHEN TotalDue>1000 THEN 'High Value'
		ELSE 'Normal'
	END AS OrderValue
	FROM
		Sales.SalesOrderHeader 

	
--16. Show a list of salespeople (Sales.SalesPerson) and their territory names (join Sales.SalesTerritory). 
	
	SELECT TOP 5 * FROM Person.Person;
	SELECT TOP 5 * FROM Sales.SalesPerson;
	SELECT TOP 5 * FROM Sales.SalesTerritory;
	
	SELECT 
		ssp.BusinessEntityID,
		CONCAT (FirstName, ' ', MiddleName,' ' , LastName) AS SalesPeolple,
		sst.Name AS TeritoryName,
		sst.TerritoryID
	FROM	
		Person.Person pp
	LEFT JOIN Sales.SalesPerson ssp ON pp.BusinessEntityID = ssp.BusinessEntityID
	LEFT JOIN Sales.SalesTerritory sst ON sst.TerritoryID = ssp.TerritoryID
	WHERE ssp.BusinessEntityID IS NOT NULL

--17. List customers and show only the last 4 characters of their AccountNumber using RIGHT(AccountNumber, 4). ----Doubt

	SELECT * FROM Sales.Customer
	
	SELECT 
		sc.CustomerID,
		RIGHT (AccountNumber,4)NewAccountNumber
	FROM 
		Sales.Customer sc

--18. Show top 10 products with their vendor name, product name, and list price sorted by ListPrice desc. 

	SELECT * FROM Production.Product
	SELECT * FROM Purchasing.vendor

	SELECT 
		pv.Name AS VendorName,
		pp.ProductID,
		pp.Name As ProductName,
		pp.ListPrice
	FROM
		Production.Product pp,
		Purchasing.Vendor pv
	ORDER BY 
		ListPrice DESC
		
--19. List each order’s SalesOrderID, customer full name, and how many days ago it was placed using DATEDIFF(DAY, OrderDate, GETDATE()). 

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.Customer
SELECT * FROM Person.Person

SELECT
	ssoh.SalesOrderID,
	ssoh.OrderDate,
	CONCAT (pp.FirstName,' ',pp.LastName) AS CustomerFullName,
	DATEDIFF(DAY, OrderDATE, GETDATE()) AS NoOfDaysFromOrder
FROM	
	Sales.SalesOrderHeader ssoh
	LEFT JOIN sales.Customer sc ON ssoh.CustomerID = sc.CustomerID
	LEFT JOIN Person.Person pp ON pp.BusinessEntityID = sc.PersonID

--20. Show product name, product number, and category only for products that are not assigned to any subcategory using LEFT JOIN and filter on IS NULL. 
		
SELECT * FROM Production.Product
SELECT * FROM Production.ProductSubcategory

SELECT
	pp.Name AS ProductName,
	pp.ProductID AS ProductNumber,
	pps.ProductSubcategoryID

FROM
	Production.Product pp
LEFT JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
WHERE pps.ProductSubcategoryID IS NULL


--21. Retrieve top 20 orders (SalesOrderHeader) with order date, total due, customer name, salesperson name, and territory. 

SELECT TOP 5 * FROM Sales.SalesOrderHeader;
SELECT TOP 5 * FROM Sales.SalesTerritory;
SELECT TOP 5 * FROM Sales.Customer
SELECT * FROM Person.Person;
SELECT * FROM SAles.SalesPerson

SELECT TOP 20
	ssoh.OrderDate,
	ssoh.TotalDue,
	CONCAT (pp.FirstName,' ',MiddleNAme,' ',LastName) AS CustomerName,
	ssoh.SalesPersonID,
	ssoh.TerritoryID,
	sst.Name AS TerritoryName
FROM
	Sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.Customer sc ON ssoh.CustomerID = sc.CustomerID
	LEFT JOIN Person.Person pp ON pp.BusinessEntityID = sc.PersonID
	LEFT JOIN sales.SalesTerritory sst ON sst.TerritoryID = ssoh.TerritoryID
	
--22. List all employees with department, job title, and manager’s full name by 
--joining Employee, EmployeeDepartmentHistory, Department, and a self join on Employee.ManagerID. 
	
	SELECT TOP 5 * FROM HumanResources.Department
	SELECT TOp 5 * FROM HumanResources.Employee
	SELECT TOP 5 * FROM HumanResources.EmployeeDepartmentHistory

	SELECT
	FROM
		HumanResources.Department hrd
		LEFT JOIN HumanResources.EmployeeDepartmentHistory hredh ON hrd.DepartmentID = hredh.DepartmentID


--23. Show a summary of sales orders: customer name, order date, and order total with a flag: ‘Recent’ if placed in the last 30 days, else ‘Old’. 

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Person.Person

SELECT 
	CONCAT(pp.FirstName,' ',MiddleName,' ',LastName) AS CustomerNAme,
	ssoh.OrderDate,
CASE
	WHEN ssoh.OrderDate <=30 THEN 'Recent'
	ELSE 'Old' 
END AS OrderFlag

FROM
	Person.Person pp
	LEFT JOIN sales.Customer sc ON sc.PersonID = pp.BusinessEntityID
	LEFT JOIN Sales.SalesOrderHeader ssoh ON ssoh.CustomerID = sc.CustomerID
	   
--24. List all product names and the vendor who supplies them; if a product has no vendor, show ‘No Vendor’ using ISNULL() and LEFT JOIN.

SELECT * FROM Production.Product
SELECT * FROM Purchasing.Vendor
SELECT * FROM Purchasing.ProductVendor

SELECT
	pp.Name AS ProductName,
	ISNULL (pv.Name,'No Vendor') AS VendorName
FROM
	Production.Product pp
	LEFT JOIN Purchasing.ProductVendor ppv ON pp.ProductID = ppv.ProductID
	LEFT JOIN Purchasing.Vendor pv ON pv.BusinessEntityID = ppv.BusinessEntityID

--AND ISNULL([t2].[OrderDate], '1900-01-01') = ISNULL([t].[OrderDate], '1900-01-01')

--25. From SalesOrderDetail, SalesOrderHeader, Customer, Person, list all orders and include a derived field to show 'Big Order' if OrderQty > 50. 

SELECT * FROM sales.SalesOrderDetail
SELECT * FROM sales.SalesOrderHeader
SELECT * FROM sales.Customer
SELECT * FROM Person.Person

SELECT
	ssod.OrderQty,
	CASE
	WHEN OrderQty > 50 THEN 'Big Order'
	ELSE 'small Order'
END AS OrderStatus,
	ssoh.SalesOrderID,
	ssod.ProductID,
	ssoh.OrderDate,
	pp.BusinessEntityID,
	sc.PersonID
FROM
	Sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.Customer sc ON ssoh.CustomerID = sc.CustomerID
	LEFT JOIN Person.Person pp ON pp.BusinessEntityID = sc.PersonID
	LEFT JOIN Sales.SalesOrderDetail ssod ON ssod.SalesOrderID = ssoh.SalesOrderID

--26. List all products, their category, and vendor, and show if the product is still being sold (SellEndDate IS NULL) using a CASE statement. 


SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Purchasing.Vendor
SELECT * FROM Purchasing.ProductVendor

SELECT
	pp.ProductID,
	pp.SellEndDate,
	pp.Name AS ProductName,
	ppc.Name AS CategoryName,
	pv.Name As VendorName,
	CASE 
	WHEN SellEndDate IS NULL THEN 'product still on sale'
	ELSE 'product not available'
	END AS Availability
FROM
	Production.Product pp 
	LEFT JOIN  Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
	LEFT JOIN Production.ProductCategory ppc ON pps.ProductCategoryID = ppc.ProductCategoryID
	LEFT JOIN Purchasing.ProductVendor ppv ON ppv.ProductID = pp.ProductID
	LEFT JOIN Purchasing.Vendor pv ON pv.BusinessEntityID = ppv.BusinessEntityID

--27. Show a list of all employees, their department, and how long ago they joined, in months. 
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM Person.Person
SELECT 
	pp.BusinessEntityID,
	CONCAT(pp.FirstName, ' ',LastName) AS Employee,
	hredh.DepartmentID,
	hrd.Name As DepartmentName,
	DATEDIFF(Month, hredh.StartDate, GETDATE()) AS Month
FROM
	HumanResources.EmployeeDepartmentHistory hredh
	LEFT JOIN HumanResources.Department hrd ON hrd.DepartmentID = hredh.DepartmentID
	LEFT JOIN Person.Person pp ON pp.BusinessEntityID = hredh.BusinessEntityID
	

--28. Display all orders with customer name, salesperson, and product name; if any data is missing, still show the record using FULL OUTER JOIN. 

SELECT * FROM Person.Person
SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Purchasing.ProductVendor
SELECT * FROM Sales.SalesOrderDetail

SELECT 
	pp.pro
FROM
	
	Production.product pp
		FULL OUTER JOIN Purchasing.ProductVendor ppv ON pp.productID = ppv.ProductID
		FULL OUTER JOIN Person.Person pps ON pps.BusinessEntityID = ppv.BusinessEntityID


--29. Retrieve all orders where the order was made on a weekend using DATEPART(WEEKDAY, OrderDate) and show customer name and order total. 
SELECT * FROM Sales.SalesOrderHeader
Select * FROM Sales.SalesOrderDetail
SELECT * FROM Person.Person
SELECT * FROM Purchasing.ProductVendor

SELECT 	
	ssoh.SalesOrderID,
	ssoh.OrderDate,
	CONCAT (pp.FirstName,' ',pp.MiddleName,' ',pp.LastName) AS CustomerName,
	DATEPART (WEEKDAY,ssoh.OrderDate) AS WeekEnd
FROM
	sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.SalesOrderDetail ssod ON ssoh.SalesOrderID = ssod.SalesOrderID
	LEFT JOIN Purchasing.ProductVendor ppv ON ppv.ProductID = ssod.ProductID
	LEFT JOIN Person.Person pp ON pp.BusinessEntityID = ppv.BusinessEntityID

	
--30. Show a list of salespeople and their total sales. Use GROUP BY and JOIN SalesOrderHeader with SalesPerson and Person. 
SELECT * FROM sales.SalesOrderHeader
SELECT * FROM sales.SalesPerson
SELECT * FROM person.Person

SELECT 
	ssoh.SalesPersonID,
	COUNT(*) AS TotalSales
FROM
	Sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.SalesPerson ssp ON ssp.BusinessEntityID = ssoh.SalesPersonID
	LEFT JOIN Person.Person pp ON pp.BusinessEntityID = ssp.BusinessEntityID
GROUP BY
	ssoh.SalesPersonID

 

 