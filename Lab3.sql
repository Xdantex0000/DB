-- 1. Використовуючи SELECT двічі, виведіть на екран своє ім’я, прізвище та по-батькові одним результуючим набором. 
SELECT 'Eugen' || ' ' || 'Zaginaylo' AS FullName
union
select 'Eugen' || ' ' || 'Zaginaylo' as FullName;
-- 2. Порівнявши власний порядковий номер в групі з набором із всіх номерів в групі, вивести на екран ;-) якщо він менший за усі з них, або :-D в протилежному випадку.
-- 3. Не використовуючи таблиці, вивести на екран прізвище та ім’я усіх дівчат своєї групи за вийнятком тих, хто має спільне ім’я з студентками іншої групи. 
select * from (values ('Olena'),('Alena'),('Olya'),('Irina') ,('Vladislava'))v(name)
except select * from (values ('Olya'),('Irina'))v(i);
-- 4. Вивести усі рядки з таблиці Numbers (Number INT). Замінити цифру від 0 до 9 на її назву літерами. Якщо цифра більше, або менша за названі, залишити її без змін. 
select Number,
case
when number = 0 then 'zero'
when number = 1 then 'one'
when number = 2 then 'two'
when Number = 3 then 'three'
when Number = 4 then 'four'
when Number = 5 then 'five'
when Number = 6 then 'six'
when Number = 7 then 'seven'
when Number = 8 then 'eight'
when Number = 9 then 'nine'
end number
from Numbers;
-- 5. Навести приклад синтаксису декартового об’єднання для вашої СУБД
SELECT * FROM Orders cross join Customers;
									   
-- Часть 2
-- 1. Вивисти усі замовлення та їх службу доставки. В залежності від ідентифікатора служби доставки, переіменувати її на таку, що відповідає вашому імені, прізвищу, або по-батькові.
select  "CompanyName" , suppliers."SupplierID",orders."OrderID",
case  when suppliers."SupplierID" between 1 and 10 then 'Eugen'
       when suppliers."SupplierID" between 11 and 20 then 'Zaginaylo'
  when suppliers."SupplierID" between 21 and 29 then 'Olexandrovich'
end as CompanyName
from orders
join order_details ON order_details."OrderID" =orders."OrderID"
join products On products."ProductID" = order_details."ProductID"
join suppliers on suppliers."SupplierID" = products."SupplierID";
-- 2. Вивести в алфавітному порядку усі країни, що фігурують в адресах клієнтів, працівників, та місцях доставки замовлень.
select "Country" from customers
union select "Country" from employees
union select "ShipCountry" from orders
order by "Country";
-- 3. Вивести прізвище та ім’я працівника, а також кількість замовлень, що він обробив за перший квартал 1998 року.
select "FirstName", "LastName", count(orders."EmployeeID")
from employees join orders
on employees."EmployeeID" = orders."EmployeeID" and  date_part('month',"OrderDate") BETWEEN 1 and 3 and date_part('year',"OrderDate") = 1998
group by orders."EmployeeID", "FirstName","LastName";
-- 4. Використовуючи СTE знайти усі замовлення, в які входять продукти, яких на складі більше 100 одиниць, проте по яким немає максимальних знижок.
with zakaz as (
  select * from order_details
), zakaz2 as (
  select "OrderID"
  from zakaz
  where "Quantity" =100
  )
select *
from orders
where "OrderID" in(select "OrderID" from zakaz2);
-- 5. Знайти назви усіх продуктів, що не продаються в південному регіоні.
Select "ProductName" from products
join order_details on products."ProductID" = order_details."ProductID"
join orders on orders."OrderID"=order_details."OrderID"
join territories on orders."ShipCity" = territories."TerritoryDescription" and "RegionID" !=4 and "UnitsInStock"=0;