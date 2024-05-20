SELECT *
FROM credit_card;
-- write 4-6 queries to explore the dataset and put your findings 
SELECT SUM(amount)
FROM credit_card;
-- solve below questions
-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
WITH cte AS(
		SELECT city,SUM(amount) AS sumspend
		FROM credit_card
		GROUP BY city
			),
	total AS(
        SELECT sum(amount) AS totalspend
        FROM credit_card
        )
	SELECT *,100.0*(sumspend/totalspend) AS percent_contribution
    FROM cte AS c
    INNER JOIN total AS t
    ON 1=1                                     
    ORDER BY sumspend DESC                       
    LIMIT 5;


-- 2- write a query to print highest spend month and amount spent in that month for each card type
WITH cte AS(
		SELECT card_type,MONTH(transaction_date) AS Month,SUM(amount) AS total_spend
		FROM credit_card
		GROUP BY MONTH(transaction_date),card_type
        -- ORDER BY card_type,total_spend DESC
        )
		SELECT *
        FROM(SELECT *,DENSE_RANK() OVER(PARTITION BY card_type ORDER BY total_spend) AS rn        
				FROM cte) AS a
		WHERE rn=1;



-- 3- write a query to print the transaction details(all columns from the table) for each card type when
	-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
WITH cte AS(
        SELECT *,
		SUM(amount) OVER(PARTITION BY card_type ORDER BY transaction_date,transaction_id) AS total_spend
		FROM credit_card
        -- ORDER BY card_type,total_spend DESC      
        )

SELECT *
FROM ( SELECT *,DENSE_RANK() OVER(PARTITION BY card_type ORDER BY total_spend) AS rn
		FROM cte 
		WHERE total_spend>=1000000) AS a
	WHERE rn=1;
        
-- 4- write a query to find city which had lowest percentage spend for gold card type
WITH cte AS(
SELECT city,card_type,SUM(amount) AS amount,
SUM(CASE WHEN card_type="Gold" THEN amount END) AS gold_amount
FROM credit_card
GROUP BY city,card_type
)
SELECT city,SUM(gold_amount)*1.0/SUM(amount) AS gold_ratio
FROM cte
GROUP BY city
HAVING SUM(gold_amount)>0 AND SUM(amount)>0       -- with this we get cities with gold ratio but how to write one city here using dense rank??
ORDER BY gold_ratio;

SELECT *
FROM credit_card;
                                               
-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
	WITH cte AS(	
        SELECT city,exp_type,SUM(amount) AS amount_spent
		FROM credit_card
		GROUP BY city,exp_type
        ),
	cte2 AS(
    SELECT *,
     DENSE_RANK() OVER(PARTITION BY city ORDER BY exp_type,amount_spent ASC) AS rn_asc,
    DENSE_RANK() OVER(PARTITION BY city ORDER BY exp_type,amount_spent DESC) AS rn_desc
	FROM cte
    )
	SELECT city,
	MAX(CASE WHEN rn_desc=1 THEN exp_type END) AS highest_expense_type,
    MIN(CASE WHEN rn_asc=1 THEN exp_type END) AS lowest_expense_type                   
    FROM cte2                                                                           
    GROUP BY city;
-- 6- write a query to find percentage contribution of spends by females for each expense type

WITH cte AS(
		SELECT exp_type,
        SUM(CASE WHEN gender="F" THEN amount END) AS f_spend,
        SUM(amount) AS total_spend
		FROM credit_card
		GROUP BY exp_type                        -- this is using cte which is lenghty we can wrie short in subquery
        )
SELECT exp_type,100*(f_spend/total_spend) AS per_f_spend
FROM cte
GROUP BY exp_type;

SELECT exp_type,
SUM(CASE WHEN gender="F" THEN amount END)*1.0/SUM(amount) AS per_fem_contr         -- using subquery
FROM credit_card
GROUP BY exp_type;

-- 7- which card and expense type combination saw highest month over month growth in Jan-2014
SELECT * 
FROM credit_card;
WITH cte AS(
		SELECT card_type,exp_type,YEAR(transaction_date) AS yr,month(transaction_date) AS mt,SUM(amount) AS sum
		FROM credit_card
		WHERE transaction_date>=2014-01-01
		GROUP BY card_type,exp_type,month(transaction_date),YEAR(transaction_date),month(transaction_date)
		),
	cte2 AS(
    SELECT *,
    LAG(sum,1)OVER(PARTITION BY card_type,exp_type ORDER BY yr,mt) AS prev_month_spend
    FROM cte)
    SELECT *,(sum-prev_month_spend) AS mon_growth
    FROM cte2
    WHERE prev_month_spend IS NOT NULL AND yr="2014" AND mt="1"
    ORDER BY mon_growth DESC
    LIMIT 1;

-- 8- during weekends which city has highest total spend to total no of transcations ratio 
        SELECT city,SUM(amount)/COUNT(*) AS ratio
		FROM credit_card
        WHERE DAYNAME(transaction_date) IN ("saturday","sunday")
		GROUP BY city
        ORDER BY ratio DESC
        LIMIT 1;
-- 9- which city took least number of days to reach its 500th transaction after the first transaction in that city
WITH cte AS(
        SELECT *,
		ROW_number() OVER(PARTITION BY city ORDER BY transaction_date,transaction_id) AS rn
		FROM credit_card
        )
        SELECT city,TIMESTAMPDIFF(DAY,MIN(transaction_date),MAX(transaction_date)) AS date_diff
        FROM cte
        WHERE rn=1 OR rn=500                                            
        GROUP BY city
        HAVING COUNT(*)=2
        ORDER BY date_diff
        LIMIT 1;
SELECT *
FROM credit_card;













-- once you are done with this create a github repo to put that link in your resume. Some example github links:
-- https://github.com/ptyadana/SQL-Data-Analysis-and-Visualization-Projects/tree/master/Advanced%20SQL%20for%20Application%20Development
-- https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/COVID%20Portfolio%20Project%20-%20Data%20Exploration.sql
