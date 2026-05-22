SELECT
    p.product_id,

    COALESCE(t.product_category_name_english, p.product_category_name) AS product_category,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

FROM olist_products_dataset p

LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name