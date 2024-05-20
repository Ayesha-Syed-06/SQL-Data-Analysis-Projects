USE Sample_DB;

CREATE TABLE UserActivity
(
username VARCHAR(20) ,
activity VARCHAR(20),
startDate DATE,
endDate DATE
);

INSERT INTO UserActivity VALUES 
('Alice','Travel','2020-02-12','2020-02-20'),
('Alice','Dancing','2020-02-21','2020-02-23'),
('Alice','Travel','2020-02-24','2020-02-28'),
('Bob','Travel','2020-02-11','2020-02-18');

-- Get the second most recent activity. If there is only one activity then return that one also.

SELECT*
FROM useractivity;

WITH cte AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY username ORDER BY startdate DESC) AS rn,
COUNT(activity)OVER(PARTITION BY username) AS cnt
FROM useractivity
)
SELECT *
FROM cte 
WHERE rn=2 OR cnt<2;


WITH cte AS(
SELECT *,
DENSE_RANK() OVER(PARTITION BY username ORDER BY startdate DESC) AS New_col,
COUNT(*) OVER(PARTITION BY username) AS cnt
FROM useractivity
)

SELECT *
FROM cte
WHERE NEW_col=2 OR cnt=1;
-- WHERE NEW_col=2 OR cnt<2;




-------------------------------------------------------------


CREATE TABLE exams (
	student_id INT, 
	subject VARCHAR(20), 
	marks INT
	);

INSERT INTO exams VALUES 
(1,'Chemistry',91),
(1,'Physics',91),
(1,'Maths',81),
(2,'Chemistry',80),
(2,'Physics',90),
(3,'Chemistry',80),
(4,'Chemistry',71),
(4,'Physics',54),
(4,'Maths',64);

-- Find students with same marks in Physics and Chemistry


SELECT *
FROM exams;

WITH cte AS(
SELECT *,LAG(marks)OVER(PARTITION BY student_id) AS lagmarks
FROM exams
WHERE Subject IN ("Physics","Chemistry")
)
SELECT *
FROM cte
WHERE marks=lagmarks;





WITH cte AS(
SELECT *,
LAG(marks) OVER(PARTITION BY(student_id)) as lagmarks
FROM exams
WHERE subject IN ("physics","Chemistry")
)

SELECT *
FROM cte
WHERE marks=lagmarks;


--------------------------------------------------------------------------------

CREATE TABLE covid(
city VARCHAR(50),
days DATE,
cases INT);

INSERT INTO covid VALUES
('DELHI','2022-01-01',100),
('DELHI','2022-01-02',200),
('DELHI','2022-01-03',300),
('MUMBAI','2022-01-01',100),
('MUMBAI','2022-01-02',100),
('MUMBAI','2022-01-03',300),
('CHENNAI','2022-01-01',100),
('CHENNAI','2022-01-02',200),
('CHENNAI','2022-01-03',150),
('BANGALORE','2022-01-01',100),
('BANGALORE','2022-01-02',300),
('BANGALORE','2022-01-03',200),
('BANGALORE','2022-01-04',400);

-- Find cities with increasing number of covid cases every day.
SELECT * FROM covid;

WITH cte AS(
SELECT *,
cast(DENSE_RANK() OVER(PARTITION BY city ORDER BY(days)) AS signed)-
cast(DENSE_RANK() OVER(PARTITION BY city ORDER BY(cases)) AS signed) AS diff
FROM covid
) 
SELECT city
FROM cte
GROUP BY city
HAVING COUNT(DISTINCT diff)=1;

WITH cte AS(
SELECT *,
cast(DENSE_RANK()OVER(PARTITION BY city ORDER BY days) AS signed)-
cast(DENSE_RANK()OVER(PARTITION BY city ORDER BY cases)AS signed) AS diff
FROM covid
)
SELECT city,COUNT(DISTINCT diff) AS cnt
FROM cte
GROUP BY city
HAVING COUNT(DISTINCT diff) =1;

-------------------------------------------------------------------------

CREATE TABLE students(
 studentid INT NULL,
 studentname NVARCHAR(255) NULL,
 subject NVARCHAR(255) NULL,
 marks INT NULL,
 testid INT NULL,
 testdate DATE NULL
);

INSERT INTO students VALUES 
(2,'Max Ruin','Subject1',63,1,'2022-01-02'),
(3,'Arnold','Subject1',95,1,'2022-01-02'),
(4,'Krish Star','Subject1',61,1,'2022-01-02'),
(5,'John Mike','Subject1',91,1,'2022-01-02'),
(4,'Krish Star','Subject2',71,1,'2022-01-02'),
(3,'Arnold','Subject2',32,1,'2022-01-02'),
(5,'John Mike','Subject2',61,2,'2022-11-02'),
(1,'John Deo','Subject2',60,1,'2022-01-02'),
(2,'Max Ruin','Subject2',84,1,'2022-01-02'),
(2,'Max Ruin','Subject3',29,3,'2022-01-03'),
(5,'John Mike','Subject3',98,2,'2022-11-02');

SELECT * FROM students;
-- Write a SQL query to get the list of students who scored above average marks in each subject
WITH cte AS(
SELECT *,
AVG(marks) OVER(PARTITION BY subject) AS avg_marks
FROM students
)
SELECT *
FROM cte
WHERE marks>avg_marks;

-- Write a SQL query to get the percentage of students who scored 90 or above in any subject 
	-- amongst total students
SELECT 100.0*((SELECT COUNt(DISTINCT studentid) AS cnt
FROM students
WHERE marks>90)/
(SELECT COUNT(DISTINCT studentid) AS cnt1
FROM students)) AS percent;

SELECT 100.0*(SELECT COUNT(DISTINCT studentid) AS cnt90
			FROM students
			WHERE marks>90)/(SELECT COUNT(DISTINCT studentid) AS cnt
								FROM students) AS percent;

-- Write a SQL query to get the second highest and second lowest marks for each subject
WITH cte AS(
SELECT *,
DENSE_RANK() OVER(PARTITION BY subject ORDER BY marks DESC) AS high,
DENSE_RANK() OVER(PARTITION BY subject ORDER BY marks ASC) AS low
FROM students
)

SELECT *
FROM cte
WHERE high=2 OR low=2;
			
WITH cte AS(
            SELECT *,
            DENSE_RANK()OVER (PARTITION BY SUBJECT ORDER BY marks ASC) AS a_rank, 
			DENSE_RANK()OVER (PARTITION BY SUBJECT ORDER BY marks DESC) AS d_rank
			FROM students
            )
SELECT *
FROM cte
WHERE a_rank=2 OR d_rank=2;
-- For each student and test, identify if their marks increased or decreased from the previous test.
WITH cte AS(
SELECT*,
lead(marks) OVER(PARTITION BY studentid ORDER BY testdate) AS leadmarks         
FROM students
)
SELECT *,
CASE WHEN marks<leadmarks THEN "Increased" 
	WHEN leadmarks IS NULL THEN NULL
    ELSE "decreased" END AS result
FROM cte;

----------------------------------------------------------------

CREATE TABLE icc_world_cup
(
Team_1 VARCHAR(20),
Team_2 VARCHAR(20),
Winner VARCHAR(20)
);

INSERT INTO icc_world_cup values
('India','SL','India'),
('SL','Aus','Aus'),
('SA','Eng','Eng'),
('Eng','NZ','NZ'),
('Aus','India','India');

SELECT * FROM icc_world_cup;

-- Create three columns - Matches_played, No_of_wins, No_of_losses
WITH cte AS(
SELECT team_1, CASE WHEN team_1=Winner THEN 1 ELSE 0 END AS win
FROM icc_world_cup
UNION ALL
SELECT team_2, CASE WHEN team_2=Winner THEN 1 ELSE 0 END AS win
FROM icc_world_cup
)
SELECT team_1, COUNT(team_1) AS played,
SUM(win) AS wins,
COUNT(team_1)-SUM(win) AS lose
FROM cte
GROUP BY team_1;



-----------------------------------------------------------------

 
CREATE TABLE events (
ID INT,
event VARCHAR(255),
YEAR INt,
GOLD VARCHAR(255),
SILVER VARCHAR(255),
BRONZE VARCHAR(255)
);

INSERT INTO events VALUES 
(1,'100m',2016, 'Amthhew Mcgarray','donald','barbara'),
(2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith'),
(3,'500m',2016, 'Charles','Nichole','Susana'),
(4,'100m',2016, 'Ronald','maria','paula'),
(5,'200m',2016, 'Alfred','carol','Steven'),
(6,'500m',2016, 'Nichole','Alfred','Brandon'),
(7,'100m',2016, 'Charles','Dennis','Susana'),
(8,'200m',2016, 'Thomas','Dawn','catherine'),
(9,'500m',2016, 'Thomas','Dennis','paula'),
(10,'100m',2016, 'Charles','Dennis','Susana'),
(11,'200m',2016, 'jessica','Donald','Stefeney'),
(12,'500m',2016,'Thomas','Steven','Catherine');


-- PUSH YOUR LIMITS --

-- Write a query to find number of gold medal per swimmers for swimmers who only won gold medals.

-- Subquery
SELECT gold AS player_name,COUNT(*)
FROM events
WHERE gold NOT IN (SELECT silver FROM events UNION ALL SELECT bronze FROM events)
GROUP BY gold;
-- we are appling condition using where that gold should not be in silver and bronze using NOT IN and UNION ALL. remaining names will be grouped and we get count

-- using groupby, having, cte
WITH cte AS(
SELECT gold, "gold" AS medal_type FROM events
UNION ALL
SELECT silver, "silver" AS medal_type FROM events 
UNION ALL
SELECT bronze, "bronze" AS medal_type FROM events AS newcol
)

SELECT gold AS player_name,
COUNT(DISTINCT gold) AS cnt
FROM cte
GROUP BY gold
HAVING COUNT(DISTINCT gold)=1 AND max(medal_type)="gold";

-- using UNION ALL you are combining all three columns and adding a row named gold silver bronze which will help in having condition to filter players who have medaltype as gold
--  and who have count(distinct gold )=1
----------------------------------------------------------------


CREATE TABLE emp_salary
(
    emp_id INTEGER  NOT NULL,
    name VARCHAR(20)  NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER
);

INSERT INTO emp_salary VALUES
(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');



-- Write a SQL query to return all employees whose salary is same in same department
	-- Using CTE,Using joins(inner join and left join)
    SELECT *
FROM emp_salary;
    

WITh cte AS(
		SELECT dept_id,salary
		FROM emp_salary 
		GROUP BY dept_id,salary
		HAVING COUNT(*)>1
        )

SELECT e.*
FROM emp_salary AS e
INNER JOIN cte AS c
ON e.dept_id=c.dept_id AND e.salary=c.salary;
----------------------------------------------------------------------

CREATE TABLE emp_2020
(
emp_id INT,
designation VARCHAR(20)
);

CREATE TABLE emp_2021
(
emp_id INT,
designation VARCHAR(20)
);

INSERT INTO emp_2020 VALUES 
(1,'Trainee'), 
(2,'Developer'),
(3,'Senior Developer'),
(4,'Manager');

INSERT INTO emp_2021 VALUES 
(1,'Developer'), 
(2,'Developer'),
(3,'Manager'),
(5,'Trainee');

-- Find the change in employee status.

	-- Types of status can only be - Promoted, No change, Resigned, New
    
------------------------------------------------------------------


CREATE TABLE hospital ( 
emp_id INT,
action VARCHAR(10),
time DATETIME);

INSERT INTO hospital VALUES 
('1', 'in', '2019-12-22 09:00:00'),
('1', 'out', '2019-12-22 09:15:00'),
('2', 'in', '2019-12-22 09:00:00'),
('2', 'out', '2019-12-22 09:15:00'),
('2', 'in', '2019-12-22 09:30:00'),
('3', 'out', '2019-12-22 09:00:00'),
('3', 'in', '2019-12-22 09:15:00'),
('3', 'out', '2019-12-22 09:30:00'),
('3', 'in', '2019-12-22 09:45:00'),
('4', 'in', '2019-12-22 09:45:00'),
('5', 'out', '2019-12-22 09:40:00');

SELECT * FROM hospital;

-- Write a SQL Query to find the total number of people present 
	-- inside the hospital
	WITH cte AS(		
            SELECT *,
			DENSE_RANK()OVER(PARTITION BY emp_id ORDER BY time DESC) AS rn
			FROM hospital
            )
    
    SELECT
    COUNT(CASE WHEN action="in" THEN 1 ELSE NULL END) AS no_of_people
    FROM cte
    WHERE rn=1;
    
-- 1-out, 2-in, 3-in, 4-in, 5-out










