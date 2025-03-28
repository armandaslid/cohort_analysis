/*
This query calculates the repeat purchase rates for customers based on their first purchase month,
specifically for customers making their 2nd, 3rd, and 4th orders.
*/

WITH fp_and_orders AS (  -- Calculated the first purchase month and order count for each customer
SELECT
  customer_id
  ,MIN(DATE_TRUNC('MONTH', order_date)) AS first_purchase
  ,COUNT(order_id) AS order_count
FROM
  bigquery_db_cohort_db.ecom_orders
GROUP BY 1
)

SELECT    -- Calculated repeat purchase rates for the 2nd, 3rd, and 4th orders
  first_purchase AS purchase_month
  ,ROUND(COUNT(CASE WHEN order_count >= 2 THEN customer_id END) / COUNT(DISTINCT customer_id), 2) AS repeat_rate_2nd_order
  ,ROUND(COUNT(CASE WHEN order_count >= 3 THEN customer_id END) / COUNT(DISTINCT customer_id), 2) AS repeat_rate_3rd_order
  ,ROUND(COUNT(CASE WHEN order_count >= 4 THEN customer_id END) / COUNT(DISTINCT customer_id), 2) AS repeat_rate_4th_order
FROM
  fp_and_orders
GROUP BY
  purchase_month
ORDER BY
  purchase_month
;
