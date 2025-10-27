DROP VIEW IF EXISTS v_periods;

CREATE OR REPLACE VIEW v_periods AS
WITH
base_group_purchases AS (
	SELECT
        Customer_ID,
		Group_ID,
		MIN(Transaction_DateTime) AS First_Group_Purchase_Date,
        MAX(Transaction_DateTime) AS Last_Group_Purchase_Date,
        COUNT(DISTINCT Transaction_ID) AS Group_Purchase
    FROM v_purchase_history
	GROUP BY Customer_ID, Group_ID
),
group_discounts AS (
    SELECT
        v.Customer_ID,
        v.Group_ID,
        v.Transaction_ID,
        MIN(ch.SKU_Discount / NULLIF(ch.SKU_Summ, 0)) AS Transaction_Group_Min_Discount
    FROM v_purchase_history v
    JOIN Checks ch ON v.Transaction_ID = ch.Transaction_ID
    JOIN ProductGrid pg ON ch.SKU_ID = pg.SKU_ID AND v.Group_ID = pg.Group_ID
    GROUP BY v.Customer_ID, v.Group_ID, v.Transaction_ID
),
group_min_discounts AS (
    SELECT
        Customer_ID,
        Group_ID,
        COALESCE(MIN(Transaction_Group_Min_Discount), 0) AS Group_Min_Discount
    FROM group_discounts
    GROUP BY Customer_ID, Group_ID
)
SELECT
    bg.Customer_ID,
    bg.Group_ID,
    bg.First_Group_Purchase_Date,
    bg.Last_Group_Purchase_Date,
    bg.Group_Purchase,
    (EXTRACT(EPOCH FROM (bg.Last_Group_Purchase_Date - bg.First_Group_Purchase_Date)) / 86400 + 1) / 
    NULLIF(bg.Group_Purchase, 0) AS Group_Frequency,
    gd.Group_Min_Discount
FROM base_group_purchases bg
LEFT JOIN group_min_discounts gd ON bg.Customer_ID = gd.Customer_ID AND bg.Group_ID = gd.Group_ID
ORDER BY bg.Customer_ID, bg.Group_ID;


SELECT * FROM v_periods
ORDER BY Customer_ID;