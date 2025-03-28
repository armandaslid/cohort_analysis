/*
This query calculates the cohort size for customers based on their first purchase month.
It groups customers into cohorts by the month of their first purchase and counts the number
of customers in each cohort.
*/

WITH first_purchase AS (        -- CTE for first purchase month for each customer
  SELECT
    customer_id
    ,DATE(MIN(DATE_TRUNC('MONTH', order_date))) AS first_purchase_date
  FROM
    bigquery_db_cohort_db.ecom_orders
  GROUP BY customer_id
)

SELECT                          -- Counted the number of customers in each cohort
  first_purchase_date AS cohort_month
  ,COUNT(customer_id) AS cohort_size
FROM 
  first_purchase
GROUP BY 
  cohort_month
ORDER BY 
  cohort_month
;
