--sql retail sales analysis
create database sql_project_retail;

create table retail_sales
	(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantity int,
	price_per_unit float,
	cogs float,
	total_sale float

	);


select * from retail_sales
 limit 10;

-- check to see if we have null entries
-- data cleaning
select * from retail_sales
 where transactions_id is null
 or
 sale_date is null
 or
 sale_time is null
 or
 gender is null
 or
 category is null
 or
 quantity is null
 or
 cogs is null
 or
 total_sale is null;

 -- deleting the null rows
 delete from retail_sales
 where transactions_id is null
 or
 sale_date is null
 or
 sale_time is null
 or
 gender is null
 or
 category is null
 or
 quantity is null
 or
 cogs is null
 or
 total_sale is null;


 -- how many sales do we have 
 select count(*) as total_sale from retail_sales;

-- how many unique customers do we have?
select count(distinct customer_id) from retail_sales; -- disticn gives us the unique number and removes duplicates

-- which categories do we have?
select distinct category from retail_sales;

--data analysis & business findings

--Q1. Write a sql query to retrive alll columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date ='2022-11-05';

--Q2. Write a sql query to retrive all transactions where the category is 'clothing' and the quantity sold is more than the 3 in the month of Nov2022
select *
from retail_sales
where category='Clothing'
	and to_char(sale_date,'yyyy-mm')='2022-11'
	and quantity >= 4;

--Q3. write a sql query to calculate the total sales for each category

select category, sum(total_sale) as total_sales, count(*) as total_orders
from retail_sales
group by category;

--Q4. write a sql query to find the average age of customers who purchased items from the "beauty" category
select round(avg(age),2) from retail_sales
 where category='Beauty';

--Q5. write a sql query to find all transactions where the total_sale is greater tha 1000
select * from retail_sales
where total_sale>1000;

--Q6. awrite a query to find the total number of transactions made by each gender in each category
select count(transactions_id) as transactions , category, gender from retail_sales
group by category,gender
order by 2;

--Q7. wrire a query to calculate the average sale for each month. Find out best selling month in each year
select * from
	(
	select extract(year from sale_date) as year, 
		extract(month from sale_date) as month,
		avg(total_sale) as sale,
		rank () over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1,2
    ) as s1
 where rank = 1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by total_sales desc
limit 5 ;
	
--Q.9 Write a SQL to find the number of unique customers who purchased items from each category.

select count(distinct customer_id) as customer_count, category
from retail_sales
group by 2


--Q.10 Write a SQL to create each shift and number of orders (example Morning<=12, etc)

with hourly_sales as (
select *,
	case 
		when extract(hour from sale_time) < 12 then 'morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from retail_sales)
select shift,
	count(*) as total_orders
from hourly_sales
group by shift