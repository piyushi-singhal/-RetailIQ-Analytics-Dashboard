-- Load Superstore_Cleaned.csv into the normalized PostgreSQL schema.
-- Run from the project root:
-- psql -d business_analytics -f SQL/schema.sql
-- psql -d business_analytics -f SQL/data_loading.sql

SET search_path TO retailiq;

TRUNCATE TABLE order_items, orders, products, customers, superstore_staging RESTART IDENTITY CASCADE;

\copy superstore_staging (
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit,
    order_year,
    order_month,
    month_name,
    order_quarter,
    shipping_days,
    profit_margin
)
FROM 'Dataset/Superstore_Cleaned.csv'
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

INSERT INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM superstore_staging
WHERE customer_id IS NOT NULL;

INSERT INTO products (product_id, product_name, category, sub_category)
SELECT DISTINCT product_id, product_name, category, sub_category
FROM superstore_staging
WHERE product_id IS NOT NULL;

INSERT INTO orders (
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    country,
    city,
    state,
    postal_code,
    region,
    shipping_days,
    order_year,
    order_month,
    order_quarter
)
SELECT DISTINCT
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    country,
    city,
    state,
    postal_code,
    region,
    shipping_days,
    order_year,
    order_month,
    order_quarter
FROM superstore_staging
WHERE order_id IS NOT NULL;

INSERT INTO order_items (
    row_id,
    order_id,
    product_key,
    sales,
    quantity,
    discount,
    profit,
    profit_margin
)
SELECT
    s.row_id,
    s.order_id,
    p.product_key,
    ROUND(s.sales, 2),
    s.quantity,
    s.discount,
    ROUND(s.profit, 2),
    ROUND(s.profit_margin, 2)
FROM superstore_staging s
JOIN products p
    ON s.product_id = p.product_id
    AND s.product_name = p.product_name
WHERE s.row_id IS NOT NULL;

SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items;
