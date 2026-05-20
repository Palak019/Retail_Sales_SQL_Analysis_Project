-- Schema
drop table if exists retail;
create table retail(
Order_Id INT,
Order_Date Date,
Ship_Mode VARCHAR(30),
Segment VARCHAR(30),
Country VARCHAR(30),
City VARCHAR(30),
State VARCHAR(30),
Postal_Code VARCHAR(30),
Region VARCHAR(30),
Category VARCHAR(30),
Sub_Category VARCHAR(30),
Product_ID VARCHAR(30),
Cost_Price DECIMAL,
List_Price DECIMAL,
Quantity INT,
Discount_Percentage INT
);
-- data Exploration

-- count of rows
select count(*) from retail;

-- sample data
select * from retail
limit 10;

-- null values
Select * from retail
where Order_Id IS null
or
Order_Date is null
or
Ship_Mode is null
or
Segment is null
or
Country is null
or
City is null
or
State is null
or
Postal_Code is null
or
Region is null
or
Category is null
or
Sub_Category is null
or
Product_ID is null
or
Cost_Price is null
or
List_Price is null
or
Quantity is null
or
Discount_Percentage is null;

-- categories
select distinct(category)
from retail
order by category;

-- sub categories
select distinct(sub_category)
from retail
order by sub_category;

--duplicate rows
select * ,
Count(*)
from retail
group by order_id,order_date,Ship_Mode,Segment,Country,City,State,Postal_Code,Region,Category,Sub_Category,Product_ID,Cost_Price,List_Price,Quantity,Discount_Percentage
having count(*)>1;

--Ship mode
select distinct(ship_mode)
from retail
order by ship_mode;

--Check zero values
SELECT *
FROM retail
WHERE cost_price = 0
   OR list_price = 0
   OR quantity = 0
   OR discount_percentage = 0;

-- check negative values 
select * 
from retail
where cost_price < 0
   OR list_price < 0
   OR quantity < 0
   OR discount_percentage < 0;

--Check Derived Logic
select * 
from retail
where cost_price > list_price;

--Find overall date range
SELECT 
    MIN(order_date) AS earliest_date,
    MAX(order_date) AS latest_date
FROM retail;

--data cleaning

--Set cost_price = NULL where value is 0
update retail
set cost_price = null
where cost_price = 0;

--Set list_price = NULL where value is 0
update retail
set list_price = null
where list_price = 0;

--Replace inconsistent ship_mode values with 'unknown'
update retail
set ship_mode = 'unknown'
where ship_mode = 'N/A'
or ship_mode = 'Not Available';

--split table

--customer table 
create table customers as
select distinct 
segment,
country,
city,
state,
postal_code,
region
from retail;

--Add customer_id
ALTER TABLE customers
ADD COLUMN customer_id SERIAL PRIMARY KEY;

--product table
create table products as
select distinct
    product_id,
    category,
    sub_category
from retail;

--Make product_id primary key
ALTER TABLE products
ADD PRIMARY KEY (product_id);

--orders table
create table orders as
select distinct
    order_id,
    order_date,
    ship_mode,
    segment,
    country,
    city,
    state,
    postal_code,
    region
from retail;

--Add customer_id column
ALTER TABLE orders
ADD COLUMN customer_id INT;

--Map customer_id
UPDATE orders o
SET customer_id = c.customer_id
FROM customers c
WHERE 
    o.segment = c.segment
    AND o.country = c.country
    AND o.city = c.city
    AND o.state = c.state
    AND o.postal_code = c.postal_code
    AND o.region = c.region;

--Remove duplicate customer columns
ALTER TABLE orders
DROP COLUMN segment,
DROP COLUMN country,
DROP COLUMN city,
DROP COLUMN state,
DROP COLUMN postal_code,
DROP COLUMN region;

select * from orders;
--Order_details table
CREATE TABLE order_details AS
SELECT
    order_id,
    product_id,
    cost_price,
    list_price,
    quantity,
    discount_percentage
FROM retail;

--basic analysis

--Total number of orders in the dataset
select count(distinct(order_id)) 
from orders;

--Total quantity sold
select sum(quantity) as total_quantity_sold
from order_details;

--Total revenue
select sum(list_price*quantity) as total_revenue
from order_details
where list_price is not null;

--Average order value
select avg(order_value) as average_order_value
from(
   	select order_id,sum(list_price*quantity) as order_value
	from order_details
	where list_price is not null
	group by order_id
);

--Number of unique customers
select count(distinct(customer_id))
from customers;

--Number of unique products
select count(distinct(product_id)) as unique_products
from products;

--Category & Segment Analysis

--Total sales by category
select p.category , sum(od.list_price*od.quantity) as total_sales
from products p 
join order_details od
on p.product_id=od.product_id 
where od.list_price is not null
group by p.category;

--Total sales by sub-category
select p.sub_category , sum(od.list_price*od.quantity) as total_sales
from products p 
join order_details od
on p.product_id=od.product_id 
where od.list_price is not null
group by p.sub_category;

--Which category generates highest revenue?
select p.category , sum(od.list_price*od.quantity) as revenue
from products p 
join order_details od
on p.product_id=od.product_id 
where od.list_price is not null
group by p.category
order by revenue desc
limit 1;

--Sales distribution by segment
select c.segment , sum(od.list_price*od.quantity) as sales
from order_details od
join orders o
on od.order_id = o.order_id
join customers c 
on o.customer_id = c.customer_id
where od.list_price is not null
group by c.segment;

--Top 5 sub-categories by revenue
select p.sub_category , sum(od.list_price*od.quantity) as revenue
from products p 
join order_details od
on p.product_id=od.product_id 
where od.list_price is not null
group by p.sub_category
order by revenue desc
limit 5;

--Category with highest average discount
select p.category , avg(od.discount_percentage) as average_discount
from products p
join order_details od
on p.product_id = od.product_id
group by p.category
order by average_discount desc
limit 1;

--Total sales by region
select c.region , sum(od.list_price*od.quantity) as Total_Sales
from order_details od
join orders o
on od.order_id = o.order_id
join customers c
on o.customer_id = c.customer_id
where od.list_price is not null
group by c.region;

--Top 5 cities by sales
select c.city , sum(od.list_price*od.quantity) as Sales
from order_details od
join orders o
on od.order_id = o.order_id
join customers c
on o.customer_id = c.customer_id
where od.list_price is not null
group by c.city
order by Sales desc
limit 5;

--Which state has highest number of orders?
select c.state , count(o.order_id) as total_orders
from orders o
join customers c
on o.customer_id = c.customer_id
group by c.state
order by total_orders desc
limit 1;

--Region with lowest sales
select c.region , sum(od.list_price*od.quantity) as Total_Sales
from order_details od
join orders o
on od.order_id = o.order_id
join customers c
on o.customer_id = c.customer_id
group by c.region
order by Total_Sales
limit 1;

--Average order value per city
SELECT 
    c.city,
    SUM(od.list_price * od.quantity) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM order_details od
JOIN orders o
    ON od.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE od.list_price IS NOT NULL
GROUP BY c.city
ORDER BY avg_order_value DESC;

--Product Analysis

--Top 10 products by revenue
select p.product_id,p.category,p.sub_category,sum(od.list_price*quantity) as revenue
from order_details od
join products p
on od.product_id = p.product_id
where od.list_price is not null
group by p.product_id,p.category,p.sub_category
order by revenue desc
limit 10;

--Top 10 products by quantity sold
select p.product_id,p.category,p.sub_category,sum(od.quantity) as total_quantity
from products p
join order_details od
on p.product_id = od.product_id
group by p.product_id,p.category,p.sub_category
order by total_quantity desc
limit 10;

--Products with highest discount
select p.product_id,p.category,p.sub_category,max(od.discount_percentage) as discount
from products p
join order_details od
on p.product_id = od.product_id
group by p.product_id,p.category,p.sub_category
order by discount desc;

--Least selling products
select p.product_id,p.category,p.sub_category,sum(od.quantity) as total_quantity_sold
from products p
join order_details od
on p.product_id = od.product_id
group by p.product_id,p.category,p.sub_category
order by total_quantity_sold asc
limit 5;

--Shipping Analysis

--Most used shipping mode
select ship_mode,count(*) as total_orders
from orders
group by ship_mode
order by total_orders desc
limit 1;

--Revenue by ship mode
select o.ship_mode,sum(od.list_price*od.quantity) as revenue
from orders o
join order_details od
on o.order_id = od.order_id 
where od.list_price is not null
group by o.ship_mode 
order by revenue desc;

--Quantity handled by ship mode
select o.ship_mode,sum(od.quantity) as total_quantity
from orders o
join order_details od
on o.order_id = od.order_id
group by o.ship_mode
order by total_quantity desc;

--Time-Based Analysis

--Sales by month
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month_num,
    TO_CHAR(o.order_date, 'Mon') AS month,
    SUM(od.list_price * od.quantity) AS sales
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY year, month_num, month
ORDER BY year, month_num;

--Sales by year
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    SUM(od.list_price * od.quantity) AS sales
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY year
ORDER BY year;

--Discount & Pricing Analysis

--Total discount given
SELECT 
    SUM((list_price * discount_percentage / 100) * quantity) AS total_discount
FROM order_details;

--Average discount by category
select p.category , avg(od.discount_percentage) as average_discount 
from order_details od
join products p 
on od.product_id = p.product_id
group by p.category
order by average_discount desc;

--Orders with very high discount (>20%)
select order_id , discount_percentage
from order_details
where discount_percentage >4;

--Does higher discount increase quantity sold?
select discount_percentage , avg(quantity) as avg_quantity_sold
from order_details
group by discount_percentage
order by discount_percentage;

--Total Profit
select sum((list_price-cost_price)*quantity) as profit
from order_details;

--Profit by category
select p.category,sum((od.list_price-od.cost_price)*od.quantity) as profit
from products p
join order_details od
on p.product_id = od.product_id
group by p.category
order by profit desc;
