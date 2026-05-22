{{ config(severity='warn') }}

SELECT
    order_id,
    payment_value,
    order_status
FROM {{ ref('fact_orders') }}
WHERE order_status = 'delivered'
    AND (payment_value IS NULL OR payment_value <= 0)