WITH first_purchase AS (
  SELECT
    customer_id,
    DATE(MIN(DATE_TRUNC('MONTH', order_date))) AS first_purchase_date
  FROM
    bigquery_db_cohort_db.ecom_orders
  GROUP BY customer_id
)

SELECT
  first_purchase_date AS cohort_month,
  COUNT(customer_id) AS cohort_size
FROM 
  first_purchase
GROUP BY 
  cohort_month
ORDER BY 
  cohort_month
;
