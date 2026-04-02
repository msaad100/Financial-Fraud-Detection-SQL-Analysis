-- DATA INTEGRITY AUDIT
SELECT 
    'Null Values' AS check_type, 
    COUNT(*) AS issue_count 
FROM train 
WHERE amt IS NULL OR is_fraud IS NULL OR trans_num IS NULL

UNION ALL

SELECT 
    'Invalid Amounts (<= 0)' AS check_type, 
    COUNT(*) 
FROM train 
WHERE amt <= 0

UNION ALL

SELECT 
    'Duplicate Transactions' AS check_type, 
(COUNT(*) - COUNT(DISTINCT trans_num)) 
FROM train;
--THIS QUERY TELLS US THAT ONLY 0.58% OF THE TRANSACTIONS OCCURED WERE FRAUDULENT
SELECT 
    is_fraud,
    COUNT(*) AS GroupCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM train), 2) AS Percentage
FROM train
GROUP BY is_fraud
-- THIS QUERY TELLS  US THAT THE AVERAGE AMOUNT IN A FRAUDULENT TRANSACTION IS  ALMOST 8 TIMES MORE THAN THE NORMAL ONE 
SELECT 
    is_fraud,
   AVG(amt) as Average_Transaction_Amount
   from train
   group by is_fraud
 -- This query gives us deeper insight on average transaction based comparison based on categories   
SELECT 
    category,
    ROUND(AVG(CASE WHEN is_fraud = 0 THEN amt END), 2) AS Normal_Avg,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END), 2) AS Fraud_Avg,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amt END) / 
          NULLIF(AVG(CASE WHEN is_fraud = 0 THEN amt END), 0), 2) AS Magnitude_Difference
FROM train
GROUP BY category
ORDER BY Magnitude_Difference DESC
-- QUERY TO COMPARE FRAUD PERCENTAGE BETWEEN HOURS THROUGH OUT THE DAY
SELECT 
    DATEPART(hh, trans_date_trans_time) AS Hour_of_Day,
    COUNT(*) AS Total_Transactions,
    SUM(CAST(is_fraud AS INT)) AS Fraud_Count,
    ROUND(CAST(SUM(CAST(is_fraud AS INT)) AS FLOAT) * 100 / COUNT(*), 2) AS Hourly_Fraud_Rate
FROM train
GROUP BY DATEPART(hh, trans_date_trans_time)
ORDER BY Hourly_Fraud_Rate DESC
-- COMPARE THE FRAUD RATE FROM DIFFERENT CITIES TO FIND THE MOST VULNERABLE
SELECT 
    city,
    state,
    COUNT(*) AS Total_Trans,
    SUM(CAST(is_fraud AS INT)) AS Fraud_Count,
    ROUND(CAST(SUM(CAST(is_fraud AS INT)) AS FLOAT) * 100 / COUNT(*), 2) AS City_Fraud_Rate
FROM train
GROUP BY city, state
HAVING COUNT(*) > 100 -- Filters out tiny towns with <100 transactionS to avoid 100% fake rates
ORDER BY City_Fraud_Rate DESC;
