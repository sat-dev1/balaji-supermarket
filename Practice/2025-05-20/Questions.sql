use AdventureWorks2022
GO
-- 1. Retrieve all columns from the Person.Person table.

SELECT top 100 * FROM Person.Person


-- 2. Show the FirstName, LastName, and BusinessEntityID from Person.Person. 

SELECT FirstName,LastName,BusinessEntityID FROM Person.person;


-- 3. Find all people whose FirstName is 'John'. 

SELECT * FROM Person.Person where FirstName = 'John'


-- 4. Find all products from Production.Product that have a Color of 'Red'. 

select top 100 * from  Production.Product

select * from om Production.Product where Color='Red';


--5. List all products with a ListPrice greater than 1000. 

select * from om Production.Product where ListPrice>1000


--6. Show the Name and StandardCost of products that cost less than 500.

select  Name,StandardCost from om Production.Product where StandardCost<500


--7. Find all products that are not black or blue in color. 

select * from Production.Product where color != 'black' or color <> 'blue'

select * from Production.Product where Color not in('black','blue');


--8. List all products where SafetyStockLevel is between 500 and 1000. 

select * from  Production.Product where safetystocklevel between 500 and 1000


--9. Retrieve all FirstNames from Person.Person that start with the letter ‘A’. 

select top 5 * from Person.Person
select firstname from Person.Person where firstname like 'A%'


--10. Show the Name and ListPrice of products where ListPrice is not equal to 0. 

select name, listprice from production.product where listprice <> 0


-- 11. Count how many people are in the Person.Person table. 
SELECT top 10 * FROM Person.Person
SELECT  COUNT(*) FROM Person.Person
select  count('Sathya') as  total_person from person.person

-- 12. Count how many unique Titles exist in the Person.Person table. 

select distinct count(*) from Person.Person

select count(distinct Title) as total_unique_title from Person.Person


--13. What is the average ListPrice from Production.Product? 

select avg(ListPrice) from Production.Product

--13. Find the maximum and minimum StandardCost from Production.Product.

select min(StandardCost) as minimum_cost from Production.Product
select max(StandardCost) as maximum_cost from Production.Product

select 
	min(StandardCost) as minimum_cost,
	max(StandardCost)as maximum_cost
from
	Production.Product;

	
--14. List all products where ListPrice is greater than the average ListPrice.
select top 5 * from Production.Product
select * from Production.Product
where ListPrice>(select avg(ListPrice)from Production.Product);


--15. Show the total number of products for each color from Production.Product. 
select count(*) as total_products,color
from Production.Product
group by color


--16. Show the total ListPrice for each ProductSubcategoryID from Production.Product. 

select sum(ListPrice)as total_listprice, ProductSubcategoryID
from Production.Product
group by ProductSubcategoryID

--17. Find all colors that have more than 50 products associated with them.

select * from 
(
select color, count(*) NumberOfProducts
from Production.Product
group by color
) a 
where a.NumberOfProducts > 50

select Color, count(*) NumberOfProducts
from Production.Product
group by Color
having count(*) > 50


--18. Count how many people have a MiddleName populated (i.e., not null). 
select * from Person.Person

select middlename, count(*)as total_middlename
from Person.Person
where middlename is not null
group by middlename

select count(*)
from Person.Person
where middlename is not null

--19. Show all rows from Production.Product where ProductNumber contains the letter ‘L’. 

 select * from om Production.Product
 where ProductNumber like '%l%'
 
-- 20. From Production.Product, show Name and ListPrice where ListPrice is in the top 10% of all prices. 
select Name,@@CPU_BUSY L
where ListPrice =

-- 21. From Person.Person, list FirstName and LastName for people where Suffix is null. 
select  Firstname,Lastname from Person.Person
where Suffix is not null

--22. From Production.Product, find all products whose Name ends with 'Bike'. 
select * from Production.Product where name like '%bike';


--23. In Production.Product, show the top 5 most expensive products by ListPrice. 

select top 5 p.Name, p.listprice
from Production.Product p
order by ListPrice desc


--24. In Production.Product, find all ProductSubcategoryIDs where the average StandardCost is greater than 100.
select * from
(
select ProductSubcategoryID, avg(StandardCost)as avg_cost
from Production.Product
group by ProductSubcategoryID) a
where a.avg_cost > 100


--25. Show all Colors where the total ListPrice of products is between 10,000 and 20,000. 

select * from
(
	select Color,sum(ListPrice)as total_price
	from Production.Product
	group by Color) a
where a.total_price between 10000 and 20000


--26. Find how many products have the word 'Mountain' in their name (case insensitive).

select count(*) MName from om Production.Productt where Name like '%Mountain%'


--27. List all Names from Production.Product where the DaysToManufacture is 0 and ListPrice > 1000. 

select * from Production.Product

select Name 
from Production.Product
where DaysToManufacture = 0 and ListPrice > 1000


--28. Count how many people in Person.Person do not have a Title. 
select * from Person.Person
select count(*) from Person.Person
where title is null