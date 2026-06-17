-- RetailIQ business analysis queries
-- Dialect: PostgreSQL

SET search_path TO retailiq;

-- 1. Executive KPI summary
SELECT
    ROUND(SUM(oi.sales), 2) AS total_revenue,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    ROUND(SUM(oi.sales) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id;

-- 2. Monthly revenue and profit trend
SELECT
    DATE_TRUNC('month', o.order_date)::date AS month_start,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month_start
ORDER BY month_start;

-- 3. Year-over-year monthly revenue growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month_start,
        SUM(oi.sales) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY month_start
)
SELECT
    month_start,
    ROUND(revenue, 2) AS revenue,
    ROUND(LAG(revenue, 12) OVER (ORDER BY month_start), 2) AS revenue_previous_year,
    ROUND(
        (revenue - LAG(revenue, 12) OVER (ORDER BY month_start))
        / NULLIF(LAG(revenue, 12) OVER (ORDER BY month_start), 0) * 100,
        2
    ) AS yoy_growth_pct
FROM monthly_revenue
ORDER BY month_start;

-- 4. Revenue and profit by region
SELECT
    o.region,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.region
ORDER BY revenue DESC;

-- 5. Top 10 states by revenue
SELECT
    o.state,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.state
ORDER BY revenue DESC
LIMIT 10;

-- 6. Bottom 10 states by profit
SELECT
    o.state,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.state
ORDER BY profit ASC
LIMIT 10;

-- 7. Customer segment contribution
SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id) AS customers,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(SUM(oi.sales) / SUM(SUM(oi.sales)) OVER () * 100, 2) AS revenue_share_pct
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.segment
ORDER BY revenue DESC;

-- 8. Top 10 customers by revenue
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    COUNT(DISTINCT o.order_id) AS orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY revenue DESC
LIMIT 10;

-- 9. Customer lifetime value ranking
WITH customer_value AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        SUM(oi.sales) AS lifetime_value,
        SUM(oi.profit) AS lifetime_profit,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name, c.segment
)
SELECT
    customer_id,
    customer_name,
    segment,
    ROUND(lifetime_value, 2) AS lifetime_value,
    ROUND(lifetime_profit, 2) AS lifetime_profit,
    order_count,
    NTILE(4) OVER (ORDER BY lifetime_value DESC) AS value_quartile
FROM customer_value
ORDER BY lifetime_value DESC;

-- 10. Repeat purchase behavior
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-time'
        WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat'
        ELSE 'Loyal'
    END AS customer_type,
    COUNT(*) AS customers,
    ROUND(AVG(order_count), 2) AS avg_orders_per_customer,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(oi.sales) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) customer_orders
GROUP BY customer_type
ORDER BY customers DESC;

-- 11. Category performance
SELECT
    p.category,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    SUM(oi.quantity) AS units_sold,
    ROUND(AVG(oi.discount), 2) AS avg_discount
FROM products p
JOIN order_items oi ON p.product_key = oi.product_key
GROUP BY p.category
ORDER BY revenue DESC;

-- 12. Sub-category profitability
SELECT
    p.category,
    p.sub_category,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct
FROM products p
JOIN order_items oi ON p.product_key = oi.product_key
GROUP BY p.category, p.sub_category
ORDER BY profit ASC;

-- 13. Top 10 products by revenue
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi ON p.product_key = oi.product_key
GROUP BY p.product_id, p.product_name, p.category, p.sub_category
ORDER BY revenue DESC
LIMIT 10;

-- 14. Products with high revenue but negative profit
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(AVG(oi.discount), 2) AS avg_discount
FROM products p
JOIN order_items oi ON p.product_key = oi.product_key
GROUP BY p.product_id, p.product_name, p.category, p.sub_category
HAVING SUM(oi.sales) > 1000 AND SUM(oi.profit) < 0
ORDER BY revenue DESC;

-- 15. Discount impact on profitability
SELECT
    CASE
        WHEN oi.discount = 0 THEN '0%'
        WHEN oi.discount <= 0.10 THEN '1-10%'
        WHEN oi.discount <= 0.20 THEN '11-20%'
        WHEN oi.discount <= 0.40 THEN '21-40%'
        ELSE '40%+'
    END AS discount_band,
    COUNT(*) AS line_items,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales), 0) * 100, 2) AS profit_margin_pct
FROM order_items oi
GROUP BY discount_band
ORDER BY MIN(oi.discount);

-- 16. Shipping mode performance
SELECT
    o.ship_mode,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(AVG(o.shipping_days), 2) AS avg_shipping_days,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.ship_mode
ORDER BY orders DESC;

-- 17. Regional category mix
SELECT
    o.region,
    p.category,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.sales) / SUM(SUM(oi.sales)) OVER (PARTITION BY o.region) * 100, 2) AS region_revenue_share_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_key = p.product_key
GROUP BY o.region, p.category
ORDER BY o.region, revenue DESC;

-- 18. Best month for each region
WITH region_months AS (
    SELECT
        o.region,
        DATE_TRUNC('month', o.order_date)::date AS month_start,
        SUM(oi.sales) AS revenue,
        RANK() OVER (
            PARTITION BY o.region
            ORDER BY SUM(oi.sales) DESC
        ) AS revenue_rank
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.region, month_start
)
SELECT
    region,
    month_start,
    ROUND(revenue, 2) AS revenue
FROM region_months
WHERE revenue_rank = 1
ORDER BY revenue DESC;

-- 19. RFM-style customer scoring
WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.sales) AS monetary_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.customer_name
),
scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY last_order_date) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value) AS monetary_score
    FROM customer_rfm
)
SELECT
    customer_id,
    customer_name,
    last_order_date,
    frequency,
    ROUND(monetary_value, 2) AS monetary_value,
    recency_score + frequency_score + monetary_score AS rfm_score
FROM scores
ORDER BY rfm_score DESC, monetary_value DESC;

-- 20. Loss-making orders
SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    o.region,
    ROUND(SUM(oi.sales), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(AVG(oi.discount), 2) AS avg_discount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, c.customer_name, o.region
HAVING SUM(oi.profit) < 0
ORDER BY profit ASC
LIMIT 25;

-- 21. ABC product classification by revenue
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.sales) AS revenue
    FROM products p
    JOIN order_items oi ON p.product_key = oi.product_key
    GROUP BY p.product_id, p.product_name
),
abc AS (
    SELECT
        *,
        SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () * 100 AS cumulative_revenue_pct
    FROM product_revenue
)
SELECT
    product_id,
    product_name,
    ROUND(revenue, 2) AS revenue,
    ROUND(cumulative_revenue_pct, 2) AS cumulative_revenue_pct,
    CASE
        WHEN cumulative_revenue_pct <= 80 THEN 'A'
        WHEN cumulative_revenue_pct <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM abc
ORDER BY revenue DESC;

-- 22. Data quality check after loading
SELECT
    COUNT(*) AS total_line_items,
    COUNT(*) FILTER (WHERE sales IS NULL OR quantity IS NULL OR profit IS NULL) AS missing_metric_rows,
    COUNT(*) FILTER (WHERE discount < 0 OR discount > 1) AS invalid_discount_rows,
    COUNT(*) FILTER (WHERE sales < 0 OR quantity <= 0) AS invalid_sales_rows
FROM order_items;
