USE Sample_DB;

SELECT *
FROM superstore;

SELECT DISTINCT Ship_Mode
FROM superstore;

-- Q1. What is the difference between COUNT(*), COUNT(expression), 
		-- and COUNT(DISTINCT expression)?
        
        
        
-- Q2. Do basic Exploratory data analysis (EDA) of the dUSE Sample_DB;

SELECT *
FROM superstore;

SELECT DISTINCT Ship_Mode
FROM superstore;

-- Q1. What is the difference between COUNT(*), COUNT(expression), 
		-- and COUNT(DISTINCT expression)?
        
        
        
-- Q2. Do basic Exploratory data analysis (EDA) of the dataset. For example-        -- ETA  Extract Transform and Load
		-- How many rows do we have?
        SELECT COUNT(*) as n_Rows
        FROM superstore;
        
        -- How many orders were placed?
        SELECT COUNT(DISTINCT order_id)
        FROM superstore;
        
		-- How many customers do we have?
        SELECT COUNT(DISTINCT customer_id)
        FROM superstore;
        
		-- How much profit did we make in total?
		SELECT COUNT(DISTINCT order_date)
        FROM superstore;
        
        -- How many days orders were placed?
        SELECT COUNT(DISTINCT order_date)
        FROM superstore;
        
		-- What was the highest and lowest sales per quantity ?
		SELECT MAX(Sales/quantity), MIN(Sales/quantity)
        FROM superstore;
        
-- Q3- Write a query to get total profit, first order date and latest order date for each category
SELECT category,SUM(profit),
MIN(order_date) as min_date,
MAX(order_date) as max_date
FROM superstore
GROUP BY category;

-- Q4. How many orders were placed on each day?
SELECT order_date,count(DISTINCT(order_id))
FROM superstore
GROUP BY order_date;

-- Q5. How many orders were placed for each type of Ship mode? 
    SELECT ship_mode,count(DISTINCT order_id)
    FROM superstore
    GROUP BY ship_mode;
    
-- Q6. How many orders were placed on each day for Furniture Category?
SELECT order_date,category,COUNT(DISTINCT Order_ID) as New_col
FROM superstore
WHERE Category="Furniture"
GROUP BY order_date;


-- Q7. How many orders were placed per day 

		-- for the days when sales was greater than 1000?
        SELECT order_date,COUNT(DISTINCT Order_id)
        FROM superstore
        WHERE sales>1000
        GROUP BY order_date;
        -- using where is wrong
        
        SELECT order_date,COUNT(DISTINCT Order_id)
        FROM superstore
		GROUP BY order_date
		HAVING SUM(sales)>1000;
        
     

-- Q8. What will below codes return? What is the issue here?
		SELECT category, sub_category, SUM(profit) AS profit
		FROM superstore
		GROUP BY category;
-- GROUP BY should have aggregated cols in the select statement but the above select sataement doesnot have aggregated col  for subcategory im select

		SELECT category, SUM(profit) AS profit
		FROM superstore
		GROUP BY category, sub_category;
     -- this result is also not correct because cols providing in groupby shld be in ur select and vice versa but in above case sub_category in group_by is not present in select tatement
	
-- Q9. How many Sub categories and products are there for each categories?
		SELECT category,COUNT(DISTINCT Sub_Category),COUNT(DISTINCT(Product_id))
		FROM superstore
		GROUP BY category;
	

-- Q10. Find sales, profit and Quantites sold for each categories.
		SELECT category,COUNT(sales),SUM(profit),COUNT(quantity)
		FROM superstore
		GROUP BY category;

-- Q11. Write a query to find top 5 sub categories in west region by total quantity sold
		SELECT Sub_Category
        FROM superstore
        WHERE Region="West"
        GROUP BY Sub_Category
        ORDER BY SUM(Quantity) DESC
        LIMIT 5;
        
-- Q12. Write a query to find total sales for each region and ship mode combination for orders in year 2020
SELECT Region,Ship_Mode,SUM(Sales)
FROM superstore
WHERE Order_Date>="2020-01-01" AND Order_Date<="2020-12-31"
GROUP BY Region,Ship_Mode;

-- Q13. Find quantities sold for combination of each category and subcategory
SELECT Category,Sub_Category,COUNT(Quantity)
FROM superstore
GROUP BY Category,Sub_Category;

-- Q14. Find quantities sold for combination of each category and subcategory 
		-- when quantity sold is greater than 2
        SELECT Category,Sub_Category,COUNT(Quantity)
		FROM superstore
		GROUP BY Category,Sub_Category
		HAVING COUNT(Quantity)>2;     
        -- WHERE not HAVING

-- Q15. Find quantities sold for combination of each category and subcategory 
		-- when quantity sold in the combination is greater than 100
		SELECT Category,Sub_Category,COUNT(Quantity)
		FROM superstore
		GROUP BY Category,Sub_Category
		HAVING COUNT(Quantity)>100;
-- Q16. Write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category
		SELECT Sub_Category,MAX(Profit) AS max_profit, AVG(Profit) AS avg_profit
        FROM superstore
        GROUP BY Sub_Category
		HAVING AVG(Profit)>MAX(Profit)/10;
-- AVG(Profit)>(MAX(Profit))/2;
-- Q17. Create the exams table with below script
-- Write a query to find students who have got same marks in Physics and Chemistry.


CREATE TABLE exams 
(student_id int, 
subject varchar(20), 
marks int);


INSERT INTO exams VALUES 
(1,'Chemistry',91),
(1,'Physics',91),
(1,'Maths',92),
(2,'Chemistry',80),
(2,'Physics',90),
(3,'Chemistry',80),
(3,'Maths',80),
(4,'Chemistry',71),
(4,'Physics',54),
(5,'Chemistry',79);

SELECT *
FROM exams;

SELECT student_id
FROM exams
WHERE subject IN ("Physics","Chemistry")
GROUP BY student_id
HAVING COUNT(*)=2 AND COUNT(DISTINCT(marks))=1;
