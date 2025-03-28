/*
Created a table with customers' first and second purchases and calculated the time difference between them.
This table will be used for further calculations.
*/

CREATE OR REPLACE TABLE cohort_analysis AS

WITH first_purchase AS (                  -- First CTE to get the first purchase date for each customer
SELECT
  customer_id
  ,MIN(order_date) AS first_purchase
FROM
  bigquery_db_cohort_db.ecom_orders
GROUP BY 1
),

second_purchase AS (                      -- Second CTE to get the second purchase date for each customer using ROW_NUMBER for ranking
SELECT
  customer_id
  ,order_date AS second_purchase
FROM (SELECT                              -- Subquery with ROW_NUMBER for ranking
        customer_id
        ,order_date
        ,ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS purchase_num
      FROM
        ecom_orders_csv)
WHERE purchase_num = 2                    -- Filter to get only the second purchase
)

SELECT                                    -- Final selection, calculating the difference in days between first and second purchase
  fp.customer_id
  ,fp.first_purchase
  ,sp.second_purchase
  ,DATE_DIFF(sp.second_purchase, fp.first_purchase) AS days_between_1_and_2
FROM first_purchase AS fp
LEFT JOIN second_purchase AS sp
ON fp.customer_id = sp.customer_id
