USE Sample_DB;

SELECT * FROM superstore;

SELECT row_id, product_name, customer_name,
LEFT(customer_name,3) as useLEFT,
RIGHT(customer_name,5) as useRIGHT, 
SUBSTR(customer_name,4,3) as useSUBSTR,
LENGTH(customer_name) as useLENGTH,
INSTR(customer_name,"air") as useINSTR,
REPLACE(customer_name,"a","b") as useREPLACE,
REVERSE(customer_name) as useREVERSE,
CONCAT(customer_name,row_id,product_name) as useCONCAT,
UPPER(customer_name) as useUPPER,
LOWER(customer_name) as useLOWER
FROM superstore;

SELECT sales,
CASE
	WHEN sales<=100 THEN "Low"
    WHEN sales<=500 THEN "Avg"
    ELSE "High"
END as NewCol
From superstore;

-- Q1. Change the Category "Office Supplies" to "School Supplies".
SELECT Category,
REPLACE(Category,"Office Supplies","School Supplies") as New_col
FROM superstore;

-- Q2. Change the Category "Office Supplies" to "School Supplies" only when Ship_Mode is "Second Class".
SELECT Ship_Mode,Category,
CASE
	WHEN Ship_Mode="Second Class" THEN REPLACE(Category,"Office Supplies","School Supplies")
    ELSE Category
END AS New_col
FROM superstore;
below code will not give correct answer bec where is removing rows and returning only second
SELECT Ship_Mode,Category,REPLACE(Category,"Office Supplies","School Supplies") AS new_col
FROM superstore
WHERE Ship_Mode="Second Class";

-- Q3. Get the first three letters of Customer Name and make them capital.
SELECT Customer_Name,
UPPER(LEFT(customer_name,3)) AS New_col
FROM superstore;

-- Q4. Get the first name of Customer Name. (Hint: Find the occurence of the first space)
SELECT Customer_Name,
LEFT(customer_name,INSTR(customer_name," ")-1) AS LEFT_3
FROM superstore;

-- Q5. Get the last name of Customer Name. Get the last word from the Product Name.
SELECT Customer_name,
RIGHT(Customer_name,LENGTH(Customer_name)-INSTR(customer_name," ")) AS Last_name
FROM superstore;
SELECT product_name,
LEFT(product_name,INSTR(product_name," "))
FROM superstore;
-- Product_Name,
-- RIGHT(product_name,LENGTH(RIGHT(product_name,LENGTH(product_name)-INSTR(product_name," ")))-INSTR(RIGHT(product_name,LENGTH(product_name)-INSTR(product_name," "))," ")) AS New_col


-- Q6. Divide Profit by Quantity. 
-- Did you notice anything strange? What can be done to resolve the issue?
SELECT (profit*1.0)/Quantity
FROM superstore;
-- Q7. Write a query to get records where the length of the Product Name is less than or equal to 10.
SELECT DISTINCT product_name
FROM superstore
WHERE length(product_name)<=10;

-- Q8. Get details of records where first name of Customer Name is greater than 4.
SELECT customer_name
FROM superstore
WHERE LENGTH(LEFT(customer_name,INSTR(customer_name," ")-1))>4;

-- Q9. Get records from alternative rows.
SELECT *
FROM superstore
WHERE Row_ID%2<>0;

SELECT *
FROM superstore
WHERE Row_ID%2=0;

-- Q10. Create a column to get both Category and Sub Catergory. For example: "Furniture - Bookcases".
SELECT CONCAT(category," - " ,sub_category) AS Concat_col
FROM superstore;

-- Q11. Remove last three characters from the Customer Name.

SELECT customer_name,
LEFT(customer_name,LENGTH(customer_name)-3)
FROM superstore;

-- no need to do complex thinking, first think simple ways
SELECT Customer_name,
LEFT(Customer_name,LENgth(customer_name)-LENgth(RIGHT(customer_name,3)))
FROM superstore;

-- FIrst thre characters from first name
SELECT customer_name,
RIGHT(LEFT(customer_name,INSTR(customer_name," ")-1),LENGTH(LEFT(customer_name,INSTR(customer_name," ")-1))-3) 
FROM superstore;

-- remoove last three characters from last name
SELECT Customer_name,
-- RIGHT(Customer_name,LENGTH(Customer_name)-INSTR(customer_name," ")) AS Last_name
LEFT(RIGHT(Customer_name,LENGTH(Customer_name)-INSTR(customer_name," ")),LENGTH(RIGHT(Customer_name,LENGTH(Customer_name)-INSTR(customer_name," ")))-LENGTH(RIGHT(RIGHT(Customer_name,LENGTH(Customer_name)-INSTR(customer_name," ")),3))) AS New_col
FROM superstore;

-- Q12. Get the records which have smallest Product Name.
SELECT DISTINCT(product_name)
FROM superstore
WHERE LENGTH(product_name)=(SELECT MIN( LENGTH(Product_Name))
							FROM superstore);

-- Q13. Get the records where the Sub Category contains character "o" after 2nd character.
SELECT DISTINCT Sub_Category
FROM superstore
WHERE Sub_Category LIKE "__o%" 
	OR Sub_Category LIKE "__%o%"
    OR Sub_Category LIKE "__%o";
    
SELECT DISTINCT Sub_Category
FROM superstore
WHERE Sub_Category LIKE "__%o%"
OR Sub_Category LIKE "__%o";
    
-- Q14. Find the number of spaces in Product Name.
-- no of spaces
-- no of a occuring
SELECT product_name,LENGTH(product_name)-LENGTH(REPLACE(product_name," ","")) as Newcol
FROM superstore;

-- For a
SELECT product_name,LENGTH(product_name)-LENGTH(REPLACE(product_name,"a","")) as Newcol
FROM superstore;
-- what ever character u can just replace and and search
