select	LastName, 
		FirstName, 
		rank () over (	partition by lastname 
						order by firstname) as NameRank
from person.person
where lastName ='Adams' and FirstName like 'j%'
order by LastName, FirstName 

- Continuing on copy the query and add another column called NameDenseRank in which you rank the results with the DENSE_RANK function, so that for each last name, there is an internal ranking according to the alphabetical order of the first name. 
Examine the differences in the results between RANK and DENSE_RANK.

select	LastName, 
		FirstName, 
		rank () over ( partition by lastname 
	 			 order by firstname) as NameRank,
		dense_rank () over ( partition by lastname 
					order by firstname) as NameDenseRank
from person.person
where lastName ='Adams' and FirstName like 'j%'
order by LastName, FirstName

-Display the orders generated on the dates 01/01/2013-02/01/2013, based on the Order heading table. Rate each days orders from the order with the highest SubTotal amount (rating 1) to the lowest. If there are orders with identical amounts, they receive the same rating, 
and then the rating continues from the next number.

select	LastName, 
		FirstName, 
		rank () over ( partition by lastname 
	 			 order by firstname) as NameRank,
		dense_rank () over ( partition by lastname 
					order by firstname) as NameDenseRank
from person.person
where lastName ='Adams' and FirstName like 'j%'
order by LastName, FirstName

-Write a query that displays a line for each month of the year (i.e.,a line for each of the months: January 2011, February 2011 ... January 2012, February 2012...), and rank the months of each year separately according to the total sales (SubTotal) in that month. (2011 has its own ranking, and the ranking starts again for 2012.) 
Sort the query results by year, and ranking.

select	year (OrderDate) as 'Year',
		month(OrderDate)as 'Month',
		sum (SubTotal) as MonthlyTotalAmount,
		rank() over (	partition by year (OrderDate)
						order by sum (SubTotal) desc) as MonthRank
from sales.SalesOrderHeader
group by year (OrderDate), month(OrderDate)
order by year (OrderDate), MonthRank

- Write a query that shows 
the ProductID, Name, ListPrice, ProductSubcategoryID and the difference 
between the list price and the average list price of all the products in 
the same sub-category for each product in the Production.Product table. 
Sort it by subcategory, in ascending order. 
Include in the calculation of the average list price 
only products with a ListPrice and with ProductSubcategoryID 
that is not NULL
 
 select	p.ProductID,
		p.[name],
		p.ListPrice,
		p.ProductSubcategoryID,
		p.ListPrice - ac.avgCategoryPrice as diff
from Production.Product p
join (
	select	ProductSubcategoryID,
	avg (ListPrice) avgCategoryPrice
	from Production.Product
	where ListPrice <> 0 and ProductSubcategoryID is not null
	group by ProductSubcategoryID
) ac
on p.ProductSubcategoryID = ac.ProductSubcategoryID
order by p.ProductSubcategoryID

- Write a query that displays the first name,last name,Job Title and the number of employees in that department from the HumanResources.Employee table. Use the HumanResources.Employee and Person.Person tables. Note: This may be solved in several ways. One way includes a link between the internal and outer query, without using Exists. Another solution 
uses Unrelated Nested Queries. A preview of the results:

--option A
select p.LastName, p.FirstName, e.JobTitle, (
	select count (*) from HumanResources.Employee 
	where JobTitle = e.JobTitle
) as AmountInDepartment
from HumanResources.Employee e
left join Person.Person p on p.BusinessEntityID = e.BusinessEntityID

--option B
select  p.LastName, p.FirstName, e.JobTitle, dc.AmountInDepartment
from HumanResources.Employee e 
left join Person.Person p on p.BusinessEntityID = e.BusinessEntityID
join (	
	select JobTitle, count (*) as AmountInDepartment
	from HumanResources.Employee
	group by JobTitle 
) dc

on dc.JobTitle = e.JobTitle

- Continuing from the previous question, examine the results. What is the range of differences? That is, what is the lowest difference and what is the highest difference?
To answer this question, simply sort the results of the previous query according to the value in the Diff column.

select 	h.SalesOrderID, h.SubTotal, d.LinesSum,
		h.SubTotal - d.LinesSum as Diff
from Sales.SalesOrderHeader h
left join (	select	SalesOrderID, 
	SUM (LineTotal) as LinesSum
	from sales.SalesOrderDetail
	group by SalesOrderID 
) d
on d.SalesOrderID = h.SalesOrderID
where h.SubTotal - d.LinesSum <> 0
order by h.SubTotal - d.LinesSum

-Continuing from the previous question, examine the results of the previous query. Note that there are many order 
lines that do not have any differences, which is great. Add an instruction to the query to display only the lines 
with a difference (Diff). A preview of the results:

select 	h.SalesOrderID, 
		h.SubTotal, 
		d.LinesSum,
		h.SubTotal - d.LinesSum as Diff
from Sales.SalesOrderHeader h
left join (
	select	SalesOrderID, 
	SUM (LineTotal) as LinesSum
	from sales.SalesOrderDetail
	group by SalesOrderID 
) d
on d.SalesOrderID = h.SalesOrderID
where h.SubTotal - d.LinesSum <> 0

