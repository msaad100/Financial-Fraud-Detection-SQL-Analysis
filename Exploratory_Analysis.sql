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
-- COMPARES THE FRAUD RATE BY CATEGORY IN THE PEAK FRAUD HOURS
SELECT 
    category,
    -- Night Fraud Rate (10 PM to 3 AM)
    ROUND(SUM(CASE WHEN DATEPART(HOUR, trans_date_trans_time) >= 22 OR DATEPART(HOUR, trans_date_trans_time) < 3 THEN is_fraud ELSE 0 END) * 100.0 / 
          SUM(CASE WHEN DATEPART(HOUR, trans_date_trans_time) >= 22 OR DATEPART(HOUR, trans_date_trans_time) < 3 THEN 1 ELSE 0 END), 2) AS night_fraud_rate,

    -- Day Fraud Rate (3 AM to 10 PM)
    ROUND(SUM(CASE WHEN DATEPART(HOUR, trans_date_trans_time) BETWEEN 3 AND 21 THEN is_fraud ELSE 0 END) * 100.0 / 
          SUM(CASE WHEN DATEPART(HOUR, trans_date_trans_time) BETWEEN 3 AND 21 THEN 1 ELSE 0 END), 2) AS day_fraud_rate
FROM dbo.train
GROUP BY category;
-- Fraud Rate relation with Distance over Time
WITH CardTravel AS (
    SELECT 
        cc_num,
        is_fraud,
        category,
        DATEDIFF(SECOND, 
            LAG(trans_date_trans_time) OVER (PARTITION BY cc_num ORDER BY trans_date_trans_time), 
            trans_date_trans_time
        ) / 3600.0 AS time_diff_hours,
        
        (ABS(merch_lat - LAG(merch_lat) OVER (PARTITION BY cc_num ORDER BY trans_date_trans_time)) + 
         ABS(merch_long - LAG(merch_long) OVER (PARTITION BY cc_num ORDER BY trans_date_trans_time))) * 69.0 AS distance_miles
    FROM dbo.train
    WHERE category NOT LIKE '%_net%' 
),
ExactSpeeds AS (
    SELECT 
        is_fraud,
        distance_miles / NULLIF(time_diff_hours, 0) AS speed_mph
    FROM CardTravel
    WHERE time_diff_hours IS NOT NULL AND distance_miles > 0
)
SELECT 
    CASE 
        WHEN speed_mph <= 10 THEN '0 - 10 mph'
        WHEN speed_mph <= 60 THEN '11 - 60 mph'
        WHEN speed_mph <= 120 THEN '61 - 120 mph'
        WHEN speed_mph <= 500 THEN '121 - 500 mph'
        ELSE 'Over 500 mph'
    END AS speed_range,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_cases,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_pct
FROM ExactSpeeds
GROUP BY 
    CASE 
        WHEN speed_mph <= 10 THEN '0 - 10 mph'
        WHEN speed_mph <= 60 THEN '11 - 60 mph'
        WHEN speed_mph <= 120 THEN '61 - 120 mph'
        WHEN speed_mph <= 500 THEN '121 - 500 mph'
        ELSE 'Over 500 mph'
    END
ORDER BY MIN(speed_mph);
