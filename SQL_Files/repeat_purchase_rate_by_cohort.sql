WITH fp_and_orders AS (
SELECT
  customer_id
  ,MIN(DATE_TRUNC('MONTH', order_date)) AS first_purchase
  ,COUNT(order_id) AS order_count
FROM
  bigquery_db_cohort_db.ecom_orders
GROUP BY 1
)

SELECT
  first_purchase AS purchase_month
  ,ROUND(COUNT(CASE WHEN order_count >= 2 THEN customer_id END) / COUNT(DISTINCT customer_id), 2) AS repeat_rate_2nd_order
  ,ROUND(COUNT(CASE WHEN order_count >= 3 THEN customer_id END) / COUNT(DISTINCT customer_id), 2) AS repeat_rate_3rd_order
  ,ROUND(COUNT(CASE WHEN order_count >= 4 THEN customer_id END) / COUNT(DISTINCT customer_id), 2) AS repeat_rate_4th_order
FROM fp_and_orders
GROUP BY purchase_month
ORDER BY purchase_month
;
