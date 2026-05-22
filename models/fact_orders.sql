SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    TRY_CAST(o.order_purchase_timestamp AS TIMESTAMP)       AS order_purchase_timestamp,
    TRY_CAST(o.order_delivered_customer_date AS TIMESTAMP)  AS order_delivered_customer_date,
    TRY_CAST(o.order_estimated_delivery_date AS TIMESTAMP)  AS order_estimated_delivery_date,
    DATEDIFF(
        'day',
        TRY_CAST(o.order_purchase_timestamp AS TIMESTAMP),
        TRY_CAST(o.order_delivered_customer_date AS TIMESTAMP)
    ) AS delivery_days,
    DATEDIFF(
        'day',
        TRY_CAST(o.order_estimated_delivery_date AS TIMESTAMP),
        TRY_CAST(o.order_delivered_customer_date AS TIMESTAMP)
    ) AS delivery_delay_days,
    COUNT(oi.order_item_id)         AS total_items,
    SUM(oi.price)                   AS total_price,
    SUM(oi.freight_value)           AS total_freight_value,
    op.payment_value,
    op.payment_type,
    r.review_score
FROM olist_orders_dataset o
LEFT JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
LEFT JOIN olist_order_payments_dataset op
    ON o.order_id = op.order_id
    AND op.payment_sequential = 1
LEFT JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    op.payment_value,
    op.payment_type,
    r.review_score