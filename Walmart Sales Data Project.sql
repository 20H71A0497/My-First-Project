SELECT * FROM walmartsalesdata.sales;

select 
     time,
     (case 
         when time between "00:00:00" and "12:00:00" then "Morning"
         when time between "12:01:00" and "16:00:00" then "Afternoon"
         else "Evening"
	  end
      ) as time_of_day
from sales;

   -----------------------------------------------time_of_day----------------------------------------------------
ALTER TABLE sales  Add column time_of_day varchar (20);

update sales 
SET time_of_day = (
 CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END 
);

--------------------------------------------------------------------------------------------------------------

--------day_name--------------
alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);
--------------------------------------------------------------------------------------------------------------


-------month_name
select
     date,
     monthname(date)
from sales;

alter table sales add column month_name varchar(10);

UPDATE sales
SET month_name = monthname(date);

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------Generic-----------------------------------------------------

----------How many unique cities does the data have?---

SELECT 
    DISTINCT CITY
FROM SALES;

----------In which city is each branch located?----------------

SELECT 
     DISTINCT branch
FROM sales;

SELECT 
     DISTINCT city,
     branch
FROM sales;

--------------------------------------------------------------------------------------------------------------
----------------------------------------------------Product---------------------------------------------------

---------How many uniue product lines does the data have?----------------

SELECT COUNT(DISTINCT product_line) AS NO_OF_PROD_LINES
FROM sales;

--------------------------------------------------------------------------------------------------------------
---------------------------What is the most common payment method?--------------------------------------------

SELECT 
     payment_method,
     COUNT(payment_method) AS Cnt
FROM sales
GROUP BY payment_method
ORDER BY Cnt DESC;
--------------------------------------------------------------------------------------------------------------

------------------------------------What is the most selling product line?------------------------------------

SELECT 
     product_line,
     COUNT(product_line) AS Cnt
from sales
GROUP BY product_line
ORDER BY Cnt DESC;

--------------------------------------------------------------------------------------------------------------

----------------------------------------What is the total revenue by month?-----------------------------------

SELECT
     month_name AS month,
     SUM(total) AS Total_revenue
FROM sales
GROUP BY month_name
ORDER BY Total_revenue DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------What month had the largest COGS?---------------------------------------------

SELECT 
     month_name AS month,
     SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

--------------------------What product line had the largest revenue?------------------------------------------

SELECT
     product_line,
     SUM(total) AS Total_revenue
FROM sales
GROUP BY product_line
ORDER BY Total_revenue DESC;

------------------------------What is the city with the largest revenue?--------------------------------------

SELECT
     city,
     SUM(total) AS Total_revenue
FROM sales
GROUP BY city
ORDER BY Total_revenue DESC;

---------------------------------What product line had the largest VAT?---------------------------------------

SELECT
     product_line,
     SUM(VAT) AS Largest_VAT
FROM sales
GROUP BY product_line
ORDER BY Largest_VAT DESC;

----Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales------

with CTE as(
select `Product Line`, sum(Total) as Total_sum, avg(Total) as Total_avg 
from sales
group by `Product Line`
)

select `Product Line`, Total_avg, 
case( 
    when Total_avg > 322.97 then "Good"
else "Bad"
end as Performance
from CTE
order by `Product Line`;



----------------------Which branch sold more products than average product sold?------------------------------

select branch, sum(quantity) as qty 
from sales
group by branch
having qty > (select avg(`sum(quantity)`)
from 
     (select branch, sum(quantity)
	 from sales
     group by branch
     order by branch desc) as avg_prod_sold_by_branch);
     
-------------------------------What is the most common product line by gender?--------------------------------

SELECT
     gender,
     product_line,
	 count(product_line) as common_product
from Sales
group by gender, product_line
order by common_product desc;

--------------------------------What is the average rating of each product line?------------------------------

SELECT
     product_line,
     ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- -----------------------------------------------------------------------------------------------------------
-- -----------------------------------------------Sales-------------------------------------------------------
-- -----------------------Number of sales made in each time of the day per weekday----------------------------

SELECT
     time_of_day,
     count(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- -----------------------Which of the customer types brings the most revenue?--------------------------------
SELECT
     customer_type,
     ROUND(SUM(Total), 2) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- -------------------Which city has the largest tax percent/ VAT (Value Added Tax)?--------------------------

SELECT 
     city,
     AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- -------------------------------Which customer type pays the most in VAT?-----------------------------------

SELECT 
     customer_type,
     AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;
     

-- --------------------------How many unique customer types does the data have?-------------------------------

SELECT
     distinct customer_type
FROM sales;

-- ---------------------How many unique payment methods does the data have?-----------------------------------

SELECT
     DISTINCT payment_method
FROM sales;

-- ----------------------------------Which customer type buys the most?---------------------------------------

select customer_type, sum(total) as total_bought
from sales 
group by customer_type
order by total_bought desc;

-- ---------------------------What is the gender of most of the customers?------------------------------------

SELECT
     gender,
     COUNT(*) AS cnt
FROM sales
GROUP BY gender
ORDER BY cnt DESC;

-- --------------------------------What is the gender distribution per branch?--------------------------------

SELECT
     gender,
     COUNT(*) AS cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY cnt DESC;

-- -----------------------Which time of the day do customers give most ratings?-------------------------------

SELECT
     time_of_day,
     AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- ------------------Which time of the day do customers give most ratings per branch?-------------------------

SELECT
     time_of_day,
     AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- -----------------------------Which day fo the week has the best avg ratings?-------------------------------

SELECT
     day_name,
     AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- ------------------Which day of the week has the best average ratings per branch?---------------------------

SELECT
     day_name,
     AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY day_name
ORDER BY avg_rating DESC;
     

     



