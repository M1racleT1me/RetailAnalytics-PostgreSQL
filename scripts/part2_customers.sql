-- DROP VIEW IF EXISTS v_customers;

CREATE OR REPLACE VIEW v_customers AS
WITH transaction_aggregate_functions AS (
    SELECT
        pi.Customer_ID,
        COUNT(Transaction_ID) AS transaction_count,
        SUM(Transaction_Summ) AS total_transaction_sum,
        MIN(Transaction_DateTime) AS first_transaction,
        MAX(Transaction_DateTime) AS last_transaction
    FROM Transactions t
    JOIN Cards c 
        ON t.Customer_Card_ID = c.Customer_Card_ID
    JOIN PersonalInformation pi 
        ON c.Customer_ID = pi.Customer_ID
    GROUP BY pi.Customer_ID
),
customer_metrics AS (
    SELECT
        Customer_ID,
        total_transaction_sum / transaction_count AS Customer_Average_Check,
        EXTRACT(EPOCH FROM (last_transaction - first_transaction))::DECIMAL 
            / 86400 
            / NULLIF(transaction_count - 1, 0) AS Customer_Frequency,
        EXTRACT(EPOCH FROM (
            (SELECT DISTINCT Analysis_Formation 
             FROM DateOfAnalysisFormation 
             ORDER BY Analysis_Formation DESC 
             LIMIT 1) - last_transaction
        ))::DECIMAL / 86400 AS Customer_Inactive_Period,
        COUNT(*) OVER () AS total_customers
    FROM transaction_aggregate_functions
),
window_functions AS (
	SELECT *,
	ROW_NUMBER() OVER (ORDER BY Customer_Average_Check DESC) AS order_for_avg_check_segment,
	ROW_NUMBER() OVER (ORDER BY Customer_Frequency) AS order_for_customer_frequency_segment
	FROM customer_metrics 
),
customer_segmentations AS (
	SELECT
		Customer_ID,
		Customer_Average_Check,
		Customer_Frequency,
		Customer_Inactive_Period,
		CASE
        WHEN order_for_avg_check_segment <= total_customers * 0.10 THEN 'High'
        WHEN order_for_avg_check_segment <= total_customers * 0.35 THEN 'Medium'
        ELSE 'Low'
    END AS Customer_Average_Check_Segment,
		CASE
        WHEN order_for_customer_frequency_segment <= total_customers * 0.10 THEN 'Often'
        WHEN order_for_customer_frequency_segment <= total_customers * 0.35 THEN 'Occasionally'
        ELSE 'Rarely'
    END AS Customer_Frequency_Segment,
		CASE
		WHEN Customer_Inactive_Period / Customer_Frequency < 2 THEN 'Low'
		WHEN Customer_Inactive_Period / Customer_Frequency >= 2 AND 
		Customer_Inactive_Period / Customer_Frequency <= 5 THEN 'Medium'
		ELSE 'High'
	END AS Customer_Churn_Segment
	FROM window_functions
),
final_segmentation AS (
SELECT 
	*,
	CASE
    	WHEN Customer_Average_Check_Segment ='Low'  THEN 0
        WHEN Customer_Average_Check_Segment ='Medium'  THEN 1
        WHEN Customer_Average_Check_Segment ='High'  THEN 2
        END * 9 +
    CASE
        WHEN Customer_Frequency_Segment = 'Rarely' THEN 0
        WHEN Customer_Frequency_Segment = 'Occasionally' THEN 1
        WHEN Customer_Frequency_Segment = 'Often' THEN 2
        END * 3 +
    CASE
        WHEN Customer_Churn_Segment = 'Low' THEN 0
        WHEN Customer_Churn_Segment = 'Medium' THEN 1
        WHEN Customer_Churn_Segment = 'High' THEN 2
        END + 1 AS Customer_Segment
FROM customer_segmentations
),
Primary_Store_by_largest_share AS (
    SELECT DISTINCT ON (Customer_ID) Customer_ID, Transaction_Store_ID AS Customer_Primary_Store, Transaction_DateTime,
            (COUNT(Transaction_Store_ID) OVER (PARTITION BY Customer_ID, Transaction_Store_ID))/
            (COUNT(Transaction_ID) OVER (PARTITION BY Customer_ID))::DECIMAL AS Part_Transactions_In_Store
    FROM Cards c
         JOIN transactions t ON c.customer_card_id = t.customer_card_id
    ORDER BY Customer_ID, part_transactions_in_store DESC, Transaction_DateTime DESC
),
Primary_Store_by_last_3_transactions AS (
   SELECT Customer_ID, Transaction_Store_ID AS Customer_Primary_Store
    FROM (
        SELECT Customer_ID, Transaction_Store_ID, Transaction_DateTime,
               ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Transaction_DateTime DESC) AS pos
        FROM Cards c
            JOIN transactions t ON c.customer_card_id = t.customer_card_id) AS s1
    WHERE pos < 4
    GROUP BY Customer_ID, Transaction_Store_ID
        HAVING COUNT(*) = 3
), 
Primary_Store AS (
    (SELECT Customer_ID, Customer_Primary_Store FROM Primary_Store_by_largest_share
    EXCEPT
    SELECT Customer_ID, Customer_Primary_Store FROM Primary_Store_by_last_3_transactions)
    UNION
    SELECT Customer_ID, Customer_Primary_Store FROM Primary_Store_by_largest_share
    ORDER BY Customer_ID
)
SELECT
    fs.Customer_ID,
    fs.Customer_Average_Check,
    fs.Customer_Average_Check_Segment,
    fs.Customer_Frequency,
    fs.Customer_Frequency_Segment,
    fs.Customer_Inactive_Period,
    fs.Customer_Inactive_Period / NULLIF(fs.Customer_Frequency, 0) AS Customer_Churn_Rate,
    fs.Customer_Churn_Segment,
    fs.Customer_Segment,
    ps.Customer_Primary_Store
FROM final_segmentation fs
LEFT JOIN Primary_Store ps ON fs.Customer_ID = ps.Customer_ID
ORDER BY fs.Customer_ID;

SELECT * FROM v_customers;
-- ORDER BY Customer_Primary_Store DESC

