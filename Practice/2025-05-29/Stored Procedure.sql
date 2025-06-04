2025-05-28 

--Stored Procs 
/*
CREATE PROCEDURE <<ProcedureName >>
AS 
BEGIN 
  << SQL logic here >>
END 
*/
/*
 1. It can return the data
 2. In publish the data into another table
 */

CREATE PROCEDURE usp_GetProductById 

    @ProductID INT 
AS 
BEGIN 

    SELECT 
		ProductID, Name, ProductNumber, ListPrice 
    FROM
		Production.Product 
    WHERE ProductID = @ProductID; 
END 

EXEC usp_GetProductById @ProductID = 1; 


--	1.	Create a stored procedure to list all employees from HumanResources.Employee. 

SELECT * FROM HumanResources.Employee;

CREATE PROCEDURE usp_GetAllEmployees
AS	
BEGIN
	SELECT * FROM HumanResources.Employee
END;

EXEC dbo.usp_GetAllEmployees

--  2.	Write a procedure to get employee details by their BusinessEntityID. 
GO
CREATE PROCEDURE usp_GetEmployeeDetail
	@BusinessEntityID INT
AS
BEGIN
	SELECT * 
	FROM 
		HumanResources.Employee hre
	WHERE hre.BusinessEntityID=@BusinessEntityID
END;
EXEC dbo.usp_GetEmployeeDetail @BusinessEntityID=10;

--	3.	Create a stored procedure to get all products from a specific ProductSubcategoryID. 
SELECT * FROM production.product;
GO
CREATE PROCEDURE usp_GetAllProductsFromSpecificSubcategoryID
	@ProductSubcategoryID INT
AS
BEGIN
	SELECT * FROM production.product pp
	WHERE pp.ProductSubcategoryID=@ProductSubcategoryID
END;

EXEC dbo.usp_GetAllProductsFromSpecificSubcategoryID @ProductSubcategoryID=17;

--	4.	Create a procedure that takes a job title and hire date and returns matching employees. 
SELECT * FROM HumanResources.Employee

DROP PROCEDURE IF EXISTS usp_GetJobTitleAndHireDateOfEmployees
GO
CREATE PROCEDURE usp_GetJobTitleAndHireDateOfEmployees
	@BusinessEntityID INT
AS
BEGIN
	SELECT
		JobTitle,HireDate,BusinessEntityID
	FROM
		HumanResources.Employee
	WHERE BusinessEntityID=@BusinessEntityID
END;

EXEC dbo.usp_GetJobTitleAndHireDateOfEmployees @BusinessEntityID=12;


--	5.	Write a procedure that returns all customers from Sales.Customer who are in a given territory. 

SELECT * FROM Sales.Customer;

CREATE PROCEDURE usp_GetAllCustomers
	@TerritoryID INT
AS
BEGIN
	SELECT * FROM Sales.Customer sc
	WHERE TerritoryID=@TerritoryID
END;

EXEC dbo.usp_GetAllCustomers @TerritoryID=4;

--	6.	Write a procedure to list all sales orders placed after a given date. 
SELECT * FROM Sales.SAlesOrderHeader;
SELECT * FROM Sales.SalesOrderDetail;

DROP PROCEDURE IF EXISTS  usp_GetAllSalesOrdersGivenDate;
CREATE PROCEDURE usp_GetAllSalesOrdersGivenDate
AS
BEGIN
	SELECT * FROM Sales.SalesOrderHeader
	WHERE OrderDate>'2012-05-31'
END;

EXEC dbo. usp_GetAllSalesOrdersGivenDate

--	7.	Create a procedure that returns all products with stock less than a given quantity (from Production.ProductInventory). 

SELECT * FROM Production.ProductInventory;

CREATE PROCEDURE usp_GetAllProductsLessThenGivenQuantity
AS
BEGIN
	SELECT * FROM Production.ProductInventory
	WHERE Quantity<300
END;

EXEC dbo.usp_GetAllProductsLessThenGivenQuantity;


--	8.	Write a procedure that returns vendors from Purchasing.Vendor based on CreditRating input. 
SELECT * FROM Purchasing.Vendor;

CREATE PROCEDURE usp_GetVendorsBsedOnCreditRating
	@CreditRating INT
AS
BEGIN
	SELECT * FROM Purchasing.Vendor
	Where CreditRating=@CreditRating
END;

EXEC dbo.usp_GetVendorsBsedOnCreditRating @CreditRating=2;


--	9.	Create a procedure to get all transactions for a given product from Production.TransactionHistory. 

SELECT * FROM Production.TransactionHistory;

CREATE PROCEDURE usp_GetAllTransactionsBasedOnProduct
	@ProductID INT
As
BEGIN
	SELECT * FROM Production.TransactionHistory
	WHERE ProductID=@ProductID
END;

EXEC dbo.usp_GetAllTransactionsBasedOnProduct @ProductID=711;

--	10.	Create a procedure that lists all addresses in a given city from Person.Address. 
SELECT * FROM Person.Address;

DROP PROCEDURE usp_GetAllAddressBasedOnCity;
CREATE PROCEDURE usp_GetAllAddressBasedOnCity
	@City varchar(15)
AS
BEGIN
	SELECT * FROM Person.Address
	WHERE City=@City
END;

EXEC dbo.usp_GetAllAddressBasedOnCity @City=Portland;

 

2025-05-29 

 

-- 1. Write a query to list the top 10 employees (HumanResources.Employee) along with their job title and hire date. 
SELECT * FROM HumanResources.Employee;

CREATE PROCEDURE usp_GetTOP10Employees
AS
BEGIN
	SELECT 
		BusinessEntityID,JobTitle,HireDate
	FROM HumanResources.Employee
END;

EXEC dbo.usp_GetTOP10Employees;

-- 2. Write a query to find all customers (Sales.Customer) from the United Kingdom. 
SELECT * FROM Sales.SAlesTerritory;
SELECT * FROM Sales.Customer;

CREATE PROCEDURE usp_FindAllCustomersFromUK
	@TerritoryName varchar(15)
AS
BEGIN
	SELECT
		sc.CustomerID,
		sst.TerritoryID,
		sst.Name As TerritoryName
	FROM
		Sales.Customer sc
		LEFT JOIN Sales.SalesTerritory sst ON sc.TerritoryId=sst.TerritoryId
	WHERE sst.Name=@TerritoryName
END;

EXEC dbo.usp_FindAllCustomersFromUK @TerritoryName='United Kingdom';

-- 3. Create a new table Training.EmployeeNotes with columns: BusinessEntityID, Note, and CreatedDate. 

DROP SCHEMA if exists Traning
CREATE SCHEMA Training
DROP TABLE if exists Training.EmployeeNotes;
CREATE TABLE Training.EmployeeNotes
(
	business_entity_id INT not null,
	note hierarchyid,
	created_date datetime
);

--4. Insert 3 sample rows into Training.EmployeeNotes for existing employees from HumanResources.Employee. 

SELECT * FROM HumanResources.Employee;

WITH TrainingEmployeeNotes AS
(
	SELECT 
		hre.BusinessEntityID ,
		hre.OrganizationNode,
		hre.HireDate,
		ROW_NUMBER() OVER (ORDER BY BusinessEntityID) As Row
	FROM
		HumanResources.Employee hre
	--WHERE hre.ROW<=3
)
INSERT INTO Training.EmployeeNotes(business_entity_id,note,created_date)
SELECT
	ten.BusinessEntityID,
	ten.OrganizationNode,
	ten.HireDate
FROM
	TrainingEmployeeNotes ten;

SELECT * FROM Training.EmployeeNotes
	

--5. Write a query to delete all records in Training.EmployeeNotes where Note is null or empty. 

CREATE PROCEDURE usp_DeleteNullRowInTrainingEmployyeeNotes
AS
BEGIN
	DELETE FROM Training.EmployeeNotes WHERE note IS NULL
END;

EXEC usp_DeleteNullRowInTrainingEmployyeeNotes;

SELECT * FROM Training.EmployeeNotes 
  

--1. Write a JOIN query to list all employees with their full name, job title, and department name 
--(from Person.Person, HumanResources.Employee, HumanResources.EmployeeDepartmentHistory, and HumanResources.Department). 

SELECT * FROM Person.Person
SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM HumanResources.Department

CREATE PROCEDURE usp_ListAllEmployeesWithFullName
AS
BEGIN
SELECT 
	CONCAT(pp.FirstName,' ',pp.MiddleName,' ',pp.LastName)AS EmployeeName,
	hre.JobTitle,
	hrd.Name AS DepartmentName
FROM
	HumanResources.Employee hre
	LEFT JOIN Person.Person pp ON hre.BusinessEntityID = pp.BusinessEntityID
	LEFT JOIN HumanResources.EmployeeDepartmentHistory hredh ON pp.BusinessEntityID = hredh.BusinessEntityID
	LEFT JOIN HumanResources.Department hrd ON hredh.DepartmentID = hrd.DepartmentID

--2. Write a LEFT JOIN to show all employees and any notes from Training.EmployeeNotes. 

SELECT * FROM Training.EmployeeNotes
CREATE PROCEDURE usp_ShowAllEmployeesBasedOnNotes
	@Note hierarchyid
AS
BEGIN
	SELECT 
		hre.BusinessEntityID,
		ten.note
	FROM
		HumanResources.Employee hre
		LEFT JOIN Training.EmployeeNotes ten ON hre.BusinessEntityID = ten.business_entity_Id
		WHERE ten.note = @Note
END;

EXEC dbo.usp_ShowAllEmployeesBasedOnNotes @Note=0x7ADB18;

--3. Create a view vwRecentHires that lists employees hired after 2018. 
--error
SELECT * FROM HumanResources.Employee;

CREATE VIEW [vwRecentHires] AS

SELECT * 
FROM
	(
		SELECT 
			BusinessEntityID,
			DATEPART(year,HireDate) AS DatePartYear	
		FROM HumanResources.Employee
	) dpy
WHERE 
	dpy.DatePartYear>2018;

SELECT * FROM [vwRecentHires];	 


--4. Write a query to find products (Production.Product) that are not yet sold (i.e., no entries in Sales.SalesOrderDetail). 

SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail

Drop PROCEDURE if exists usp_FindProductsNotSold
CREATE PROCEDURE usp_FindProductsNotSold
AS
BEGIN
	SELECT 
		pp.ProductID,
		pp.Name AS ProductName
	FROM
		Production.Product pp
	WHERE ProductID Not IN (SELECT ProductID FROM Sales.SalesOrderDetail);
END;
EXEC dbo.usp_FindProductsNotSold;


--5. Create a stored procedure usp_GetEmployeeByTitle that takes JobTitle as input and returns all matching employees. 

SELECT * FROM HumanResources.Employee;
DROP PROCEDURE if exists usp_GetEmployeeByTitle
CREATE PROCEDURE usp_GetEmployeeByTitle
	@JobTitle nvarchar(50)
AS
BEGIN
	SELECT
		BusinessEntityID,
		JobTitle
	FROM
		HumanResources.Employee
	WHERE JobTitle=@JobTitle
END;
EXEC dbo.usp_GetEmployeeByTitle @JobTitle='Design Engineer';
EXEC dbo.usp_GetEmployeeByTitle @JobTitle='Production Technician - WC60';				

--6. Write a subquery to find customers (Sales.Customer) who have placed more than the average number of orders. 
SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SAlesOrderDetail

SELECT 
	sc.CustomerID,
	ssod.OrderQty	
FROM
	Sales.Customer sc
	LEFT JOIN Sales.SalesOrderHeader ssoh ON sc.CustomerID = ssoh.CustomerID
	LEFT JOIN Sales.SalesOrderDetail ssod ON ssoh.SalesOrderID = ssod.SalesOrderID
Having (SELECT AVG(ssod.OrderQty) FROM Sales.SalesOrderDetail)
Group BY
	sc.CustomerID,
	ssod.OrderQty


--7. Write a query to get top 3 best-selling products by quantity from Sales.SalesOrderDetail. 

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Production.Product

SELECT TOP 3
	ssod.ProductID,
	ssod.OrderQty,
	pp.Name AS ProductName
FROM
	Sales.SalesOrderDetail ssod
	LEFT JOIN Sales.SalesOrderHeader ssoh ON ssod.SalesOrderID = ssoh.SalesOrderID
	LEFT JOIN Production.Product pp ON pp.ProductId=ssod.ProductID

Order BY OrderQty DESC
  	


--8. Write a stored procedure usp_GetCustomerOrders that takes a CustomerID and returns order details
--(from Sales.SalesOrderHeader and Sales.SalesOrderDetail). 

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
GO
CREATE PROCEDURE usp_GetCustomerOrders
	@CustomerID INT
AS
BEGIN
	SELECT 
		ssod.SalesOrderID,
		ssod.SalesOrderDetailID,
		ssod.OrderQty,
		ssod.ProductID,
		ssoh.CustomerID,
		ssoh.SalesOrderNumber,
		ssoh.OrderDate,
		ssoh.DueDate,
		ssoh.ShipDate
	FROM Sales.SalesOrderDetail ssod
	LEFT JOIN Sales.SalesOrderHeader ssoh ON ssod.SalesOrderID = ssoh.SalesOrderID
	WHERE ssoh.CustomerID=@CustomerID
END;

EXEC dbo.usp_GetCustomerOrders @CustomerID=29825;


--9. Update all employees with the title Production Technician to have a new title Technician - Production. 

SELECT * FROM HumanResources.Employee

Update HumanResources.Employee 
SET JobTitle='Technician - Production'
WHERE JobTitle='Production Technician';

--10. Truncate the Training.EmployeeNotes table. 

SELECT * FROM Training.EmployeeNotes

Truncate Table Training.EmployeeNotes


--11. Write a query that shows the number of employees in each department. 

	SELECT * FROM HumanResources.Employee
	SELECT * FROM HumanResources.EmployeeDepartmentHistory
	SELECT * FROM HumanResources.Department

	SELECT 
		COUNT(*) AS NoOfEmployee,
		hredh.DepartmentID,
		hrd.Name
	FROM 
		HumanResources.EmployeeDepartmentHistory hredh
		LEFT JOIN HumanResources.Department hrd ON hredh.DepartmentID = hrd.DepartmentID
	GROUP BY
		hredh.DepartmentID,
		hrd.Name
		

--12. Create a view showing products and their list prices where the list price is above the average price. 

	SELECT * FROM Production.Product

	CREATE VIEW ListProductsAboveAvg As
	SELECT
		ProductId,
		Name AS ProductName,
		ListPrice
	FROM Production.Product
	WHERE ListPrice >(SELECT  AVG(ListPrice) AS Avg_Price FROM Production.Product);

	SELECT * FROM ListProductsAboveAvg;

--13. Write a query that returns customers with multiple email addresses (Person.EmailAddress). 

SELECT * FROM Person.EmailAddress
SELECT * FROM Person.Person

SELECT BusinessEntityID
FROM Person.EmailAddress
WHERE EmailAddress>(SELECT Distinct EmailAddress AS SingleEmailAddress FROM Person.EmailAddress)

SELECT  EmailAddress AS SingleEmailAddress FROM Person.EmailAddress
SELECT Distinct EmailAddress AS SingleEmailAddress FROM Person.EmailAddress

Method 1
SELECT 
	BusinessEntityID,
	EmailAddress,
	COUNT(EmailAddressID)ASNoOfEmailAddress
FROM
	Person.EmailAddress
GROUP BY
	BusinessEntityID,
	EmailAddress

	
Method 2

SELECT * 
FROM 
	Person.Person
WHERE BusinessEntityID IN
(
	SELECT 
		BusinessEntityID
	FROM
		Person.EmailAddress
	GROUP BY
		BusinessEntityID
	HAVING COUNT(distinct EmailAddress) > 1
)
--14. Write a stored procedure to insert a note for a given employee ID, with parameters: @BusinessEntityID, @Note. 
Method 1

CREATE  PROCEDURE usp_InsertANote

	@BusinessEntityID INT,
	@Note hierarchyid

AS
BEGIN
	INSERT INTO Traning.EmployeeNotes(business_entity_id,Note)
	SELECT 324324 business_entity_id, 'worked' UNION ALL
	SELECT 21323,'Left'
	WHERE business_entity_id = @BusinessEntityID
END;

EXEC dbo.usp_InsertANote



Method 2
DROP PROCEDURE If Exists  usp_InsertANote
CREATE  PROCEDURE usp_InsertANote
	@BusinessEntityID INT,
	@Note varchar(30)
AS
BEGIN
	INSERT INTO Traning.EmployeeNotes
	(
		BusinessEntityID,
		Note
	)
VALUES (@BusinessEntityID,@Note)
END;

EXEC dbo.usp_InsertANote @BusinessEntityID=1,@Note='ContractEmployee'

Method 3
DROP PROCEDURE If Exists  usp_InsertANote
CREATE  PROCEDURE usp_InsertANoteFromExistingTable
	@BusinessEntityID INT,
	@Note hierarchyid
AS
BEGIN
	INSERT INTO Traning.EmployeeNotes
	(
		business_entity_id,
		note
	)
SELECT 
	hre.BusinessEntityID,
	hre.OrganizationNode
FROM HumanResources.Employee hre
WHERE BusinessEntityID=@BusinessEntityID
END;

EXEC dbo.usp_InsertANoteFromExistingTable @BusinessEntityID=1,@Note='10OX';

--15. Write a stored procedure that returns all products whose name contains a user-supplied keyword (using LIKE and @SearchTerm). 

Select * FROM Production.Product

SELECT 
	ProductId,Name
FROM 
	Production.Product
WHERE Name Like '%user-supplied%';

 

 

--1. Write a query to return all customers who have never placed an order. 
	SELECT * FROM Sales.SalesOrderDetail
	SELECT * FROM Sales.SalesOrderHeader
	SELECT * FROM Sales.Customer
	
SELECT 
	sc.CustomerID,
	ssoh.SalesOrderID
FROM
	Sales.Customer sc
	LEFT JOIN Sales.SalesOrderHeader ssoh ON sc.CustomerID = ssoh.CustomerID
WHERE SalesOrderID IS NULL


--2. Write a stored procedure to return the highest-value order placed in a given year. 
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader

--Method 1
DROP PROCEDURE if Exists usp_Highest_value_Order
CREATE PROCEDURE usp_Highest_value_Order
	@YEAR datetime
AS
BEGIN
	SELECT
		ssod.SalesOrderID,
		ssoh.OrderDate,
		ssod.LineTotal,
		MAX(ssod.LineTotal)AS High_Value_Order,
		YEAR(ssoh.OrderDate)AS YEAR
	FROM
		Sales.SalesOrderDetail ssod
	 LEFT JOIN Sales.SalesOrderHeader ssoh ON ssod.SalesOrderID = ssoh.SalesOrderID
	WHERE YEAR(ssoh.OrderDate)=@YEAR 
	GROUP BY 
		ssod.SalesOrderID,
		ssoh.OrderDate,
		ssod.LineTotal
END;

EXEC dbo.usp_Highest_value_Order @YEAR=2012


--3. Create a stored procedure that accepts a SalesPersonID and returns 
--total sales amount, number of customers handled, and average order size. 
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderDetail

DROP PROCEDURE if exists usp_ReturnSalesPersonDetail
CREATE PROCEDURE usp_ReturnSalesPersonDetail
	@SalesPersonID INT
AS
BEGIN
SELECT 
	ssoh.SalesPersonID,
	--COUNT(SalesPersonID)AS CountOfSalesPersonID,
	SUM(ssoh.SubTotal)AS Total_Sales_Amount,
	COUNT(ssoh.CustomerID)AS No_Of_Customer,
	--ssoh.CustomerID,
	AVG(ssod.OrderQty)AS Order_Size
	--ssod.OrderQty
FROM	
	Sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.SalesOrderDetail ssod ON ssoh.SalesOrderID = ssod.SalesOrderID
	WHERE SalesPersonID=@SalesPersonID
GROUP BY
	ssoh.SalesPersonID,
	ssod.OrderQty,
	ssoh.CustomerID
END;

EXEC dbo.usp_ReturnSalesPersonDetail @SalesPersonID=276;

--4. Create a stored procedure that returns a list of inactive products (not sold in last 2 years). 
SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader


SELECT  
	pp.ProductID,
	pp.Name,
	DATEADD(YEAR,-2, GETDATE())AS 2_Year_Back
FROM
	Production.Product pp
WHERE  DATEADD(YEAR,-2, GETDATE())
		
	   
--5. Create a stored procedure to return employee tenure in years and months for each employee.

SELECT * FROM HumanResources.Employee

CREATE PROCEDURE usp_ReturntenureYearsOfEmployee
AS
BEGIN
	SELECT 
		BusinessEntityID,
		HireDate,
		DATEDIFF(YEAR,HireDate,GETDATE())AS Employee_Working_Years,
		DATEDIFF(Month,HireDate,GETDATE())AS Employee_Working_Months
	FROM	
		 HumanResources.Employee
	WHERE
		HireDate < DATEADD(YEAR, -10, GETDATE())
END;

EXEC dbo.usp_ReturntenureYearsOfEmployee;
	
	   
--6. Create a stored procedure usp_PromoteEmployee that changes an employee�s job title. 

SELECT * FROM HumanResources.Employee

CREATE PROCEDURE usp_PromoteEmployee
AS
BEGIN
	UPDATE HumanResources.Employee
	SET JobTitle='HRA'
	WHERE
		BusinessEntityID = 4
END;

EXEC dbo.usp_PromoteEmployee;


--7. Create a view showing top 5 customers based on total purchase amount. 
SELECT * FROM Purchasing.PurchaseOrderDetail
SELECT * FROM Purchasing.Vendor
SELECT * FROM Purchasing.ProductVendor

CREATE VIEW TOP_5_Customers_Total_Purchase_Amount AS
	SELECT TOP 5
		pv.BusinessEntityID,
		pv.Name,
		SUM(LineTotal)As Total_Purchase_Amount
	FROM	
		Purchasing.Vendor pv
	LEFT JOIN Purchasing.ProductVendor ppv ON pv.BusinessEntityID = ppv.BusinessEntityID
	LEFT JOIN Purchasing.PurchaseOrderDetail ppod ON ppod.ProductID = ppv.ProductID
	GROUP BY
		pv.BusinessEntityID,
		pv.Name

SELECT * FROM TOP5CustomersTotalPurchaseAmount
 
--8. Write a query to find duplicate customers based on email or name (hint: use GROUP BY and HAVING). 
SELECT * FROM Purchasing.Vendor




SELECT * FROM Person.EmailAddress
SELECT * FROM Person.Person

SELECT
	ped.EmailAddress,
	CONCAT(pp.FirstName,' ',pp.MiddleName,' ',pp.LastName)As CustomersName,
	COUNT(*) AS Count_Of_Email_Occurrences
FROM	
	Person.Person pp
	LEFT JOIN Person.EmailAddress ped ON pp.BusinessEntityID = ped.BusinessEntityID
GROUP BY
	ped.EmailAddress,
	pp.FirstName,
	pp.MiddleName,
	pp.LastName
HAVING 
	COUNT(*) > 1
	

--9. Write a query to return top 3 countries by total sales amount (using Sales.SalesOrderHeader and Sales.SalesTerritory). 
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesTerritory


SELECT top 3
	ssoh.CustomerID,
	sst.Name AS CountriesName,
	SUM(TotalDue)AS Total_Sales_Amount,
	ssoh.TerritoryID
FROM
	Sales.SalesTerritory sst 
LEFT JOIN Sales.SalesOrderHeader ssoh ON sst.TerritoryID = ssoh.TerritoryID
GROUP BY 
	ssoh.TerritoryID,
	ssoh.CustomerID,
	sst.Name
ORDER BY
	SUM(TotalDue) DESC
		

--10. Write a stored procedure to return a department-wise salary report, including average, min, and max salaries. 
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM HumanResources.EmployeePayHistory

CREATE PROCEDURE usp_GeTDepartment_Wise_Salary
AS
BEGIN
SELECT
	hredh.DepartmentID,
	AVG(hreph.Rate)As Avg_Salary,
	MIN(hreph.Rate)As Minimum_Salary,
	MAX(hreph.Rate)AS Maximum_Salary
FROM	
	HumanResources.EmployeeDepartmentHistory hredh
LEFT JOIN HumanResources.EmployeePayHistory hreph ON  hredh.BusinessEntityID = hreph.BusinessEntityID

GROUP BY
	hredh.DepartmentID
END;
EXEC dbo.usp_GeTDepartment_Wise_Salary;

--11. Write a stored procedure to return products whose names are similar to a given term using CHARINDEX or LIKE. 
SELECT * FROM Production.Product

DROP PROCEDURE if exists usp_ReturnsSimilarProductNames
CREATE PROCEDURE usp_ReturnsSimilarProductNames
	@Name nvarchar(25)
AS
BEGIN
	SELECT 
		ProductID,
		Name AS ProductName
	FROM	
		Production.Product
	WHERE 
		Name Like '%'+@Name+'%' OR
		Name=@Name
END;

EXEC dbo.usp_ReturnsSimilarProductNames @Name ='Race';


--12. Create a procedure that accepts a date range and returns orders placed in that range, grouped by salesperson. 

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesOrderDetail

DROP PROCEDURE if exists usp_GetOrdersDateRange
CREATE PROCEDURE usp_GetOrdersDateRange
	@StartDate DATETIME,
	@EndDate DATETIME
AS
BEGIN
	SELECT 
		ssoh.SalesOrderID,
		ssoh.SalesPersonID,
		ssoh.OrderDate
	FROM	
		Sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.SalesOrderDetail ssod ON ssoh.SalesOrderID = ssod.SalesOrderID
	WHERE	
		OrderDate BETWEEN @StartDate AND @EndDate
	GROUP BY
		ssoh.SalesPersonID,
		ssoh.SalesOrderID,

		ssoh.OrderDate
END;
		
EXEC dbo.usp_GetOrdersDateRange @StartDate='2012-05-01',@EndDate='2013-05-01';

--13. Write a query to show average order value per customer for customers who have placed more than 3 orders. 
SELECT * FROM Sales.SalesOrderHeader

SELECT
	ssoh.CustomerID,
	AVG(SubTotal)AS Avg_Order_Value,
	COUNT(*)AS No_Of_Orders
FROM	
	Sales.SalesOrderHeader ssoh
GROUP BY
	ssoh.CustomerID
HAVING
	COUNT(*) > 3
ORDER BY
	COUNT(*)
	
--14. Create a stored procedure to archive old orders (older than 5 years) into a backup table. 
SELECT * FROM Sales.SalesOrderHeader

CREATE PROCEDURE usp_GETOlderOrder
AS
BEGIN
	SELECT 
		MIN(ssoh.OrderDate) AS Older_Order,
		ssoh.SalesOrderID,
		ssod.OrderQty
	FROM
		Sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.SalesOrderDetail ssod ON ssoh.SalesOrderID = ssod.SalesOrderID
	GROUP BY
		ssoh.SalesOrderID,
		ssoh.OrderDate,
		ssod.OrderQty
	ORDER BY
		ssoh.OrderDate 
END;
	
EXEC dbo.usp_GETOlderOrder;

--sample
SELECT 
	ssoh.SalesOrderID,
	ssoh.OrderDate,
	DATEDIFF(OrderDate,-5,GETDATE())AS No_Of_Years
FROM
	Sales.SalesOrderHeader ssoh
GROUP BY
	ssoh.SalesOrderID,
	ssoh.OrderDate
Having 
	DATEDIFF(OrderDate,-5,GETDATE())

--NO_OF_YearsFrom_OrderPlaced
SELECT 
	SalesOrderID,
	OrderDate,
	DATEDIFF(YEAR,OrderDate,GETDATE())AS No_Of_Years
FROM
	Sales.SalesOrderHeader ssoh
WHERE 
	DATEDIFF(YEAR,OrderDate,GETDATE())>5
	
	
--15. Write a query to find employees who have worked in more than one department (use EmployeeDepartmentHistory). 
SELECT * FROM HumanResources.EmployeeDepartmentHistory


	SELECT
		BusinessEntityID,
		COUNT(*)AS MoreThenOneDepartment
	FROM	
		HumanResources.EmployeeDepartmentHistory
	GROUP BY
		BusinessEntityID
	HAVING 
		COUNT(*)>1


--16. Create a procedure to insert a new product with a default product subcategory (use Production.Product and Production.ProductSubcategory). 
SELECT * FROM Production.Product
SELECT * FROM Production.ProductSubcategory

CREATE PROCEDURE usp_InsertNewProduct
	@ProductID INT
AS
BEGIN
	INSERT INTO dbo.ProduductSubcategoryID
	(
		ProductID,
		ProductSubcategotryID,
	)
	   
	SELECT 
	Production.Product pp 
LEFT JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID


--17. Write a query to return sales by product category, even if some categories have no sales. 
SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM SAles.SalesOrderHeader

SELECT 
	ssoh.SalesOrderID,
	ppc.ProductCategoryID,
	ssod.LineTotal
FROM
	Production.ProductCategory ppc
LEFT JOIN Production.ProductSubcategory pps ON ppc.ProductCategoryID = pps.ProductCategoryID
LEFT JOIN Production.Product pp ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
LEFT JOIN Sales.SalesOrderDetail ssod ON pp.ProductID = ssod.ProductID
LEFT JOIN Sales.SalesOrderHeader ssoh ON ssod.SalesOrderID = ssoh.SalesOrderID
GROUP BY
	ssoh.SalesOrderID,
	ppc.ProductCategoryID,
	ssod.LineTotal
--WHERE 
	--ppc.ProductCategoryID IS NULL
ORDER BY
	ppc.ProductCategoryID


--18. Create a view that lists products, their categories, and subcategories using appropriate joins. 
SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory


CREATE VIEW usp_ListProducts AS

SELECT
	pp.ProductID,
	pp.NAme AS ProductName,
	ppc.Name AS ProductCategoryName,
	pps.Name AS ProductSubcategoryName
	
FROM
	Production.Product pp 
LEFT JOIN Production.ProductSubcategory pps ON pp.ProductSubcategoryID = pps.ProductSubcategoryID
LEFT JOIN Production.ProductCategory ppc  ON ppc.ProductCategoryID = pps.ProductCategoryID

SELECT * FROM usp_ListProducts;
	
--19. Write a stored procedure that generates a report of top 5 employees by total hours worked (use HumanResources.EmployeePayHistory as needed). 

--20. Write a stored procedure to find employees promoted within the last 2 years (based on title change in EmployeeDepartmentHistory). 

 