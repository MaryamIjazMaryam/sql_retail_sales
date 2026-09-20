create database sql_project_p2;
DROP TABLE IF EXISTS retail_sales;
create table retail_sales(
transactions_id INT PRIMARY KEY,
sale_date DATE, 
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantiy	INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT 
);

SELECT *FROM retail_sales;
SELECT 
count(*) 
FROM retail_sales;

SELECT *FROM retail_sales
where transactions_id is null;

SELECT *FROM retail_sales
where sale_date is null;

SELECT *FROM retail_sales
where sale_time is null;
-- showing where data is null
SELECT *FROM retail_sales
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
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;
--data cleaning
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
quantiy is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

--total sales
select count(*) as total_sale from retail_sales;
--no of  UNIQUE customers                                                
select count( DISTINCT customer_id) as total_sale from retail_sales;
 --CATAGORY
 select distinct category from  retail_sales;
 -- main data analysis
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
 --Write a SQL query to calculate the total sales (total_sale) for each category.:
 --Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
--**Write a SQL query to find the top 5 customers based on the highest total sales **:
--Write a SQL query to find the number of unique customers who purchased items from each category.:
--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date='2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select *
from retail_sales
where category='Clothing'
and 
to_char(sale_date,'yyyy-MM')='2022-11'
and 
quantiy >=4;

--Write a SQL query to calculate the total sales (total_sale) for each category.:
select category,
sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales group by 1;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age),2) as avg_age from retail_sales
where category ='Beauty';

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales where total_sale>1000;

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category,
gender,
count(*) as total_trans from retail_sales 
group by
category,
gender order by 1;


--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select * from( 
select
extract(year from sale_date) as year,
extract (month from sale_date)as month,
avg(total_sale)as average_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc )
from retail_sales
group by 1,2) as t1 where rank =1; 
 
--**Write a SQL query to find the top 5 customers based on the highest total sales **:
select
customer_id,
sum(total_sale)as total_sales
from retail_sales group by 1
order by 2 desc
limit 5;

--Write a SQL query to find the number of unique customers who purchased items from each category.:
select
category,
count( distinct customer_id) as uniquecustomer 
from retail_sales
group by category;






--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift