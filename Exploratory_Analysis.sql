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
FROM train;--THIS QUERY GIVES THE CRUX OF THE DATA IT TELLS US THAT ONLY 0.58% OF THE TRANSACTIONS OCCURED WERE FRAUDULENT
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
