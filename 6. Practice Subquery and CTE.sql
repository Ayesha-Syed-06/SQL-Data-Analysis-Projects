USE Sample_db;
SELECT *
FROM employees;

-- Q1- write a query to find premium customers from superstore data. 
	-- Premium customers are those who have 
		-- done more orders than average no of orders per customer.
	WITH cte as(
    SELECT customer_id,COUNT(DISTINCT order_id) AS orderid
    FROM superstore
    GROUP BY customer_id
    )
    SELECT *
    FROM cte
    WHERE orderid>(SELECT AVG(orderid)
					FROM cte);
    
    
    
    WITH cte as(
    SELECT customer_id,COUNT(DISTINCT order_id) AS total_orders
    FROM superstore
    GROUP BY customer_id
    )
    SELECT *
    FROM cte
    WHERE total_orders>(SELECT AVG(total_orders)
						FROM cte);
    
        
        

-- Q2- write a query to find employees whose salary 
	-- is more than average salary of employees in their department
    -- SUB QUERY
		SELECT e.*,d.avg_salary
		FROM employees AS e
		LEFT JOIN (SELECT department_id,AVG(salary) AS avg_salary
					FROM employees
					GROUP BY department_id) AS d
		ON e.department_id=d.department_id
		WHERE e.salary>d.avg_salary;
	-- CTE
    WITH cte as (
    SELECT department_id,AVG(salary) as Avg_sal
    FROM employees
    GROUP BY department_id
    )
	SELECT e.*
    FROM employees AS e
    LEFT JOIN cte AS c
    ON e.department_id=c.department_id
    WHERE e.salary>c.Avg_sal;
-- Q3- write a query to find employees whose age 
	-- is more than average age of all the employees.
SELECT *
FROM employees
WHERE emp_age>(SELECT AVG(emp_age) AS avg_sal
				FROM employees);
-- CTE
WITH cte as(SELECT AVG(emp_age) AS avg_age
				FROM employees)
SELECT *
FROM employees
WHERE emp_age>(SELECT avg_age FROM cte);

-- Q4- write a query to print emp name, salary and dep id 
	-- of highest salaried employee in each department 
    
    -- SUB QUERY
    SELECT e.emp_name,e.salary,d.department_id,d.max_sal
    FROM employees AS e
    LEFT JOIN (SELECT department_id,MAX(salary) AS max_sal
				FROM employees
				GROUP BY department_id) AS d
    ON e.department_id=d.department_id
    WHERE e.salary=d.max_sal;
    
    -- CTE
    WITH cte1 as(
    SELECT department_id,MAX(salary) AS max_sal
    FROM employees
    GROUP BY department_id
    )
    SELECT e.emp_name,e.salary,c.department_id,c.max_sal
    FROM employees AS e
    LEFT JOIN cte1 AS c
    ON e.department_id=c.department_id
    WHERE e.salary=c.max_sal;

-- Q5- write a query to print emp name, salary and dep id of 
	-- highest salaried employee overall

-- CTE
WITH cte1 as(
    SELECT category,product_id,SUM(quantity) AS total_quantity
    FROM superstore
    GROUP BY category,product_id
    ),
    cte2 as(
    SELECT category,MAX(total_quantity) AS max_quantity
    FROM cte1
    GROUP BY category
    )
    SELECT c1.*
    FROM cte1 AS c1
    LEFT JOIN cte2 AS c2
    ON c1.category=c2.category
    WHERE c1.total_quantity=c2.max_quantity;
    
 -- Using subqueries   
    
SELECT *
FROM (SELECT category,product_id,SUM(Quantity) AS total_quantity,SUM(Sales) AS total_sales
    FROM superstore
	GROUP BY category,product_id
    ) AS xyz
    LEFT JOIN (SELECT category,MAX(total_quantity) AS MAX_Quantity
				FROM (SELECT category,product_id,SUM(Quantity) AS total_quantity,SUM(Sales) AS total_sales
					FROM superstore
					GROUP BY category,product_id
					) AS abc
					GROUP BY category AS def)
                    ON xyz.category=def.category
                    WHERE xyz.total_quantity=def.max_Quantity;
    
    
    SELECT *,
    ROW_NUMBER() OVER (ORDER BY emp_id) AS rn
    FROM employees;
    
     SELECT *,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY emp_id) AS rn
    FROM employees;
    
    SELECT *,
    RANK() OVER (ORDER BY salary DESC) AS rn
    FROM employees;
    
    SELECT *,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS rn
    FROM employees;
    
    WITH cte AS(
        SELECT *,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS rn
    FROM employees
    )
    SELECT *
    FROM cte
    WHERE rn=3;
    
WITH cte AS(    
		SELECT *
		FROM employees
		WHERE salary<>(SELECT MAX(salary)
						FROM employees)
			)
	SELECT *
    FROM cte
    WHERE salary=(SELECT MAX(salary)
					FROM cte);
                    
                
SELECT MAX(salary)
FROM employees;

SELECT *,
LAG(salary) OVER(ORDER BY emp_id) AS lagsalary
FROM employees;

SELECT *,
LAG(salary,2) OVER(ORDER BY emp_id) AS lagsalary
FROM employees;

SELECT *,
LAG(salary) OVER(PARTITION BY department_id ORDER BY emp_id) AS lagsalary
FROM employees;
    
SELECT *,
LEAD(salary) OVER(ORDER BY emp_id) AS lagsalary
FROM employees;

SELECT *,
LEAD(salary,2) OVER(ORDER BY emp_id) AS lagsalary
FROM employees;


SELECT *,
LEAD(salary) OVER(ORDER BY salary) AS lagsalary
FROM employees;
-- SUM, MIN, MAX, AVG
SELECT *,
SUM(salary) OVER(ORDER BY emp_id) AS cumulativesalary
FROM employees;

SELECT *,
SUM(salary) OVER(ORDER BY salary,emp_id) AS cumulativesalary
FROM employees;

SELECT *,
SUM(salary) OVER(PARTITION BY department_id ORDER BY salary,emp_id) AS cumulativesalary
FROM employees;

SELECT *,
MAX(salary) OVER(ORDER BY emp_id) AS MAX_sal
FROM employees;

SELECT *,
MIN(salary) OVER(ORDER BY emp_id) AS MAX_sal
FROM employees;

-- If you want max salary for every department without ORDER_BY
SELECT *,
MAX(salary) OVER(PARTITION BY department_id) AS MAX_sal
FROM employees;

SELECT *,
AVG(salary) OVER(PARTITION BY department_id) AS AVG_sal
FROM employees;

SELECT *,
COUNT(*) OVER(PARTITION BY department_id) AS count
FROM employees;


-- Order of writing
-- PRECEDING
-- CURRENT ROW
-- FOLLOWING

SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS New_col
FROM employees;

SELECT *,
SUM(salary) OVER(ORDER BY emp_id ROWS BETWEEN  CURRENT ROW AND 2 FOLLOWING ) AS New_col
FROM employees;






    
    
    
    
    
    
    