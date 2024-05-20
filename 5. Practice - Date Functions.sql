USE Sample_DB;

CREATE TABLE emp_info (
empno INT,
ename VARCHAR(10),
job VARCHAR(9),
mgr INT,
hiredate DATE,
sal INT,
comm INT,
dept INT);

INSERT INTO emp_info VALUES
    (1,'JOHNSON','ADMIN',6,'1990-12-17',18000,NULL,4),
    (2,'HARDING','MANAGER',9,'1998-02-02',52000,300,3),
    (3,'TAFT','SALES I',2,'1996-01-02',25000,500,3),
    (4,'HOOVER','SALES I',2,'1990-04-02',27000,NULL,3),
    (5,'LINCOLN','TECH',6,'1994-06-23',22500,1400,4),
    (6,'GARFIELD','MANAGER',9,'1993-05-01',54000,NULL,4),
    (7,'POLK','TECH',6,'1997-09-22',25000,NULL,4),
    (8,'GRANT','ENGINEER',10,'1997-03-30',32000,NULL,2),
    (9,'JACKSON','CEO',NULL,'1990-01-01',75000,NULL,4),
    (10,'FILLMORE','MANAGER',9,'1994-08-09',56000,NULL,2),
    (11,'ADAMS','ENGINEER',10,'1996-03-15',34000,NULL,2),
    (12,'WASHINGTON','ADMIN',6,'1998-04-16',18000,NULL,4),
    (13,'MONROE','ENGINEER',10,'2000-12-03',30000,NULL,2),
    (14,'ROOSEVELT','CPA',9,'1995-10-12',35000,NULL,1);

SELECT * FROM emp_info;

SELECT hiredate, 
ADDDATE(hiredate, INTERVAL -10 YEAR) as newDate,
CURRENT_DATE() as currentDate,
CURRENT_TIME() as currentTime,
TIMESTAMPDIFF(YEAR, hiredate, CURDATE()) as differnce,
DAYNAME(hiredate) as Nameofday, -- DAYNAME 
YEAR(hiredate) as nmonth,
HOUR(CURRENT_TIME()) as ntime,
NOW(),
WEEKDAY(CURDATE()) as weekday,
WEEKOFYEAR(CURDATE()) as weekofYear
FROM emp_info;

-- Q1. Decrease one year from Hiredate.
	
    SELECT hiredate,
    ADDDATE(hiredate,INTERVAL -1 YEAR) as New_date
    FROM emp_info;
-- Q2. Calculate the tenure of the employees (in months) in the company.
SELECT empno,hiredate,
TIMESTAMPDIFF(MONTH,hiredate,CURDATE()) AS New_col
FROM emp_info;
-- Q3. Extract Day, Month, Year, Weekday from hiredate.
	
-- Q4. Find employees who were hired on Monday.
SELECT *
FROM emp_info
WHERE DAYNAME(hiredate)="Monday";
-- Q5. Find employees who were hired after 1996.
SELECT *
FROM emp_info
WHERE YEAR(hiredate)>1996;
-- Q6. Find employees who were hired after 1996 and before 1998.
	SELECT *
FROM emp_info
WHERE YEAR(hiredate)>1996 AND YEAR(hiredate)<1998;

-- Q7. Find years where more than 2 employees were hired.
SELECT YEAR(hiredate) as year,COUNT(*) as cnt
FROM emp_info
GROUP BY YEAR(hiredate)
HAVING COUNT(*)>2;

-- SUBQUERY INTRODUCTON
SELECT AVG(total_sales) AS avg_sales_subquery
FROM(	SELECT order_id,SUM(sales) AS total_sales
		FROM superstore
		GROUP BY order_id) AS abc ;
		

