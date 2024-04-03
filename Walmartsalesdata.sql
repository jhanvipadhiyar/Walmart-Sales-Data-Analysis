-- ---------------------------- Revenue And Profit Calculations------------------------ --
-- COGS=unitsPrice* quantity
-- VAT= 5% * COGS
-- total(gross,ales)=VAT+COGS
-- grossprofit(grossincome)=total(gross,ales)-COGS
-- Gross Margin =gross income/total income

create database IF not EXISTS salesDataWalmart;
create table if not exists sales(
	invoice_id VARCHAR(30) NOT NULL primary key,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type varchar(300) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT FLOAT(6,4) NOT NULL,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_mode varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9) not null,
    gross_income decimal(12,4) not null,
    rating float(2,1) not null);
    
    
    

------------------------------------------------------	 Feature Enginneering-------------------------------------------------------


select 
	time,
    (case
		when `time` between "00:00:00" and "12:00:00" then "MORNING"
        when `time` between "12:01:00" and "16:00:00" then "AFTERNOON"
        else "EVENING"
   END)AS time_of_date
FROM sales ;   

ALTER TABLE SALES ADD COLUMN time_of_day varchar(20);
alter table sales drop column time_of_date;

update sales 
set time_of_day = (
	CASE
		when `time` between "00:00:00" and "12:00:00" then "MORNING"
        when `time` between "12:01:00" and "16:00:00" then "AFTERNOON"
        else "EVENING"
	END
);
    
SELECT 
	date,
    DAYNAME(date)
    from sales;
    
alter table sales add column day_name varchar(20);
update sales
set day_name=DAYNAME(date);  


select 
	date,
    monthname(date)
    from sales;
    
alter table sales add column month_name varchar(20);
update sales
set month_name = monthname(date);

  -- ------------------ Generic--------------------- --
  -- How Many unique city dose data have? --
  
  select distinct(city) from sales;
   select distinct(branch) from sales;
   -- -- In which city is each branch?-- --
   select 
		distinct city,
        branch
	from sales;
    
 -- -------------------------Product----------------------- --
 -- How many unique product lines does the data have? --
  select 
		count(distinct product_line)
	from sales;
    
-- what is the most common payment method?--
select 
	payment_mode,
	count(payment_mode) as cnt
from sales
group by payment_mode
order by cnt desc;

-- what is your most selling product line --
select 
	product_line,
    count(product_line) as cnt
from sales
group by product_line
order by cnt DESC;

-- What is the total revenue by month? --
select 
	month_name,
    sum(total) as totalamt
from sales
group by month_name
order by totalamt DESC;

-- What month had the largest cogs?--
select 
	month_name ,
    max(cogs) 
from sales
group by month_name
order by cogs DESC ;

-- What product line had the largest revenue? --
select 
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue DESC;

-- What is the city with the largest revenue?--
select 
	city,
    sum(total) as largest_revenue
from sales
group by city
order by largest_revenue DESC;

-- what product line had the largest vat(tax)? --
select
	product_line,
    sum(VAT) as largest_VAT
from sales
group by product_line
order by largest_VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good","Bad".Good if it is greater than average sales.--
select product_line,total from sales;
alter table sales
	add column review varchar(20);
update sales 
set review = (
	CASE
		when total > avg(total) then "GOOD"
		else "BAD"
	END
);

-- which branch sold more products than averge product sold? --
select 
	branch,
    sum(quantity) as qty
from sales
group by branch
HAVING SUM(quantity)>(select avg(quantity) from sales);

-- what is the most common product line by gender? --
select 
	gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender,product_line
order by total_cnt DESC;

-- What is the average rating of each product line? --
select 
	product_line,
    round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating DESC;

-- ----------------------------------Sales------------------------------- --
-- number of sales made in each time of the day per weekday? --
select day_name from sales;
select 
	day_name,time_of_day,
    sum(total) as sales
from sales
where day_name="Monday" 
group by day_name,time_of_day
order by sales;

-- which of the customer types brings the most revenue?-- 
select 
	customer_type,
    sum(total) as revenue
from sales
group by customer_type
order by revenue DESC;

-- Which city has the largest tax percet/VAT(Value Added Tax)?--
select
	city,
    avg(VAT) AS largest_vat
FROM sales
group by city
order by largest_vat desc;

-- which customer type pays the most in VAT? --
select 
	customer_type,
    AVG(VAT) AS PAY
from sales
group by customer_type
order by PAY desc;

-- ----------------------------------CUSTOMER---------------------------------------------- --

-- How many unique customer types does the data have?
select Distinct(customer_type) from sales;

-- How Many unique payment methods does the data have? --
select distinct(payment_mode) from sales;

-- What is the most common customer type? --
select 
	customer_type,
    count(customer_type) as cnt_customertype
from sales
group by customer_type
order by cnt_customertype DESC;

-- which customer type buys the most? --
select 
	customer_type,
    sum(total) as most_buys
from sales
group by customer_type
order by most_buys DESC;
    
-- What is the gender of most of the customer? --
select 
		gender,
        count(*) as most_gender
from sales
group by gender
order by most_gender DESC;

-- what is the gender distribution per branch? --
select 
		gender,
        count(gender) as dist_cnt
from sales
WHERE branch="A"
group by gender
order by dist_cnt DESC;

-- which time of the day do customers give most ratings?--
select 
	time_of_day,
    rating,
    count(*) as mst_rating
from sales
group by time_of_day
order by rating desc;

-- which time of the day do ustomers give most ratings per branch?--
select 
	time_of_day,
    avg(rating) as avg_rating
from sales
where branch="A"
group by time_of_day
order by avg_rating DESC;

-- Which day of week has the best rating?--
select 
	day_name,
    avg(rating) as best_rating
from sales
group by day_name
order by best_rating DESC;

-- WHICH DAY OF THE WEEK HAVE THE BEST AVERAGE RATING PER BRANCH?--
select 
	day_name,
	avg(rating) as best_rating
from sales
where branch ="B"
group by day_name
order by best_rating DESC;

--



 
 
    