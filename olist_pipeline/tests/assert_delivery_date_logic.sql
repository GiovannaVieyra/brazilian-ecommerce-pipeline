SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM {{ ref('fact_orders') }}
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp