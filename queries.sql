-- Query 1: Top Products by Revenue
SELECT p.ProductName, 
       SUM(od.UnitPrice * od.Quantity) AS revenue
FROM Products p
JOIN  [Order Details] od on p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY revenue DESC
LIMIT 10;

-- Query 2: Sales by Country
SELECT sum(od.UnitPrice * od.Quantity) AS highest_sales,c.Country
from Orders o
join [Order Details] as od on o.OrderID = od.OrderID
JOIN Customers as c on o.CustomerID=c.CustomerID
group by c.Country
ORDER BY highest_sales desc
limit 10;

-- Query 3: Top Employees by Sales
select SUM(od.UnitPrice * od.Quantity) AS revenue,e.FirstName,e.LastName
from Orders o 
join [Order Details] as od on o.OrderID = od.OrderID
join Employees e on o.EmployeeID = e.EmployeeID
group by e.FirstName,e.LastName
order by revenue desc
limit 10;

-- Query 4: Sales by Category
SELECT SUM(od.UnitPrice * od.Quantity) AS revenue, c.CategoryName
from Products p
join [Order Details] od on p.ProductID = od.ProductID
JOIN Categories c on p.CategoryID=c.CategoryID
group by c.CategoryName
order by revenue desc
limit 10;

-- Query 5: Monthly Revenue Trend
SELECT SUM(od.UnitPrice * od.Quantity) AS revenue, strftime('%Y-%m',OrderDate)AS MR
from Orders o 
join [Order Details] od on o.OrderID = od.OrderID
GROUP BY MR
ORDER BY MR ASC;

-- Query 6: 
SELECT categoryname,ProductName,
rank() over ( PARTITION by categoryname order by r.revenue  DESC) as ranking
FROM Products p
join Categories C on p.CategoryID = C.CategoryID
join (
  select productid,sum(unitprice*quantity) as revenue
  from [Order Details]
  group by productid)as r 
  on p.ProductID=r.ProductID

--Query 7 : Running total each month
SELECT month, revenue,
SUM(revenue) OVER (ORDER BY month) AS running_total
FROM (
SELECT strftime('%Y-%m', OrderDate) AS month,
SUM(od.UnitPrice * od.Quantity) AS revenue
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY month
) monthly;
