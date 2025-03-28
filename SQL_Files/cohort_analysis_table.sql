CREATE OR REPLACE TABLE cohort_analysis AS

WITH first_purchase AS (
SELECT
  customer_id
  ,MIN(order_date) AS first_purchase
FROM
  bigquery_db_cohort_db.ecom_orders
GROUP BY 1
),

second_purchase AS (
SELECT
  customer_id
  ,order_date AS second_purchase
FROM (SELECT
        customer_id
        ,order_date
        ,ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS purchase_num
      FROM
        ecom_orders_csv)
WHERE purchase_num = 2
)

SELECT 
  fp.customer_id
  ,fp.first_purchase
  ,sp.second_purchase
  ,DATE_DIFF(sp.second_purchase, fp.first_purchase) AS days_between_1_and_2
FROM first_purchase AS fp
LEFT JOIN second_purchase AS sp
ON fp.customer_id = sp.customer_id
