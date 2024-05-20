USE Sample_db;

CREATE TABLE IF NOT EXISTS employees(
emp_id INT,
emp_name VARCHAR(20),
department_id INT,
salary INT,
manager_id INT,
emp_age INT
);

SELECT * FROM employees;

INSERT INTO employees VALUES 
(1, 'Ankit', 100, 10000, 4, 30),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 10000,4,37),
(4, 'Rohit', 100, 5000, 2, 16),
(5, 'Mudit', 200, 12000, 6,55),
(6, 'Agam', 200, 12000,2, 14),
(7, 'Sanjay', 200, 9000, 2,13),
(8, 'Ashish', 200,5000,2,12),
(9, 'Mukesh',300,6000,6,51),
(10, 'Rakesh',300,7000,6,50);

CREATE TABLE department(
dep_id INT,
dep_name VARCHAR(20)
);
SELECT *
FROM employees  AS e
INNER JOIN department AS d
ON e.department_id=d.dep_id;



SELECT department_id
FROM employees
INTERSECT 
SELECT dep_id
FROM department;

INSERT INTO department VALUES
(100, 'Analytics'),
(300, 'IT');

SELECT *
FROM department;

-- How to join 2 tables without joins
SELECT *
FROM <table1>, <table2>
WHERE <condition>
</condition></table2></table1>;

SELECT *
FROM employees,department
WHERE employees.department_id=department.dep_id;

-- Q1. Given EMPLOYEES and DEPARTMENT table. How many rows will be returned after using Inne,left, right, full outer joins
    -- Inner join 6, Left join 10, Right Join 6, Full Outer Join 10
-- Q2. Create new column for department name in the EMPLOYEES table
	SELECT e.*,d.dep_id
    FROM employees as e
    LEFT JOIN department as d
    ON e.department_id=d.dep_id;
    

-- Q3. In case if the department does not exist, the default department should be "NA".
	SELECT e.*,d.dep_name,
	CASE WHEN d.dep_id IS NULL THEN "NA" ELSE d.dep_name END AS new_col
	FROM employees AS e
	LEFT JOIN department AS d
	ON e.department_id=d.dep_id;
    
-- Q4. Find employees which are in Analytics department.


	SELECT e.emp_name,d.dep_name
	FROM employees AS e
	LEFT JOIN department AS d
	ON e.department_id=d.dep_id
	WHERE d.dep_name="Analytics";

	SELECT e.*,d.dep_name
	FROM employees as e
    LEFT JOIN department as d
    ON e.department_id=d.dep_id
    WHERE d.dep_name="Analytics";
    
-- Q5. Find the managers of the employees | joining table with itself is known as self join
	SELECT e.*,m.emp_name AS manager_name
	FROM employees AS e
	LEFT JOIN employees AS m
	ON e.manager_id=m.emp_id;

	SELECT e.*,m.emp_name
	FROM employees AS e
	LEFT JOIN employees AS m
	ON e.manager_id=m.emp_id;

-- Q6. Find all employees who have the salary more than their manager salary.
	SELECT e.emp_name,e.salary,m.emp_name,m.salary
	FROM employees AS e
	LEFT JOIN employees AS m
	ON e.manager_id=m.emp_id
	WHERE e.salary>m.salary;

	SELECT e.*,m.salary
	FROM employees AS e
	LEFT JOIN employees AS m
	ON e.manager_id=m.emp_id
	WHERE e.salary > m.salary;

-- Q7. Find number of employees in each department               CAreful wile using count mostly used with NULL not with col_name
	SELECT dep_id,COUNT(*)
	FROM employees AS e
	LEFT JOIN department AS d
	ON e.department_id=d.dep_id
	GROUP BY d.dep_id;

	SELECT d.dep_name,COUNT(*)
	FROM employees AS e
	LEFT JOIN department AS d
	ON e.department_id=d.dep_id
	GROUP BY d.dep_name;

-- Q8. Find the highest paid employee in each department
SELECT e.emp_name,s.department_id,max_salary
FROM employees AS e
LEFT JOIN(SELECT department_id,MAX(salary) AS max_salary
		FROM employees
		GROUP BY department_id) AS s
		ON e.department_id=s.department_id
WHERE e.salary=max_salary;

-- Q9. Which department recieves more salary


SELECT *
FROM (SELECT dep_name,SUM(salary) AS salary_sum
					FROM employees AS e
                    LEFT JOIN department AS d
                    ON e.department_id=d.dep_id
					GROUP BY dep_name) AS abc
WHERE salary_sum=(SELECT MAX(salary_sum) AS max_salary
					FROM (SELECT dep_name,SUM(salary) AS salary_sum
							FROM employees AS e
							LEFT JOIN department AS d
							ON e.department_id=d.dep_id
							GROUP BY dep_name) AS abc);
-- WITH CTE
WITH cte1 as(
SELECT dep_name,SUM(salary) AS salary_sum
FROM employees AS e
LEFT JOIN department AS d
ON e.department_id=d.dep_id
GROUP BY dep_name
)
SELECT *
FROM cte1
WHERE salary_sum=(SELECT MAX(salary_sum) AS max_salary 
					FROM cte1);


-- Q10. What is cross join? What it can be used for?
SELECT *
FROM employees
CROSS JOIN department;

