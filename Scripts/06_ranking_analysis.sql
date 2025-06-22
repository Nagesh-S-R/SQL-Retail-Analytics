/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Most frequently sold products
SELECT dp.product_name, SUM(fs.quantity) AS total_quantity
FROM gold_fact_sales fs
JOIN gold_dim_products dp ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY total_quantity DESC
LIMIT 10;


-- What are the 5 worst-performing products in terms of sales?
SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5;

-- Find the top 5 customers who have generated the highest revenue and across different countries
SELECT 
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales f
LEFT JOIN gold_dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC
LIMIT 5;

-- across different countries
SELECT * FROM (
SELECT 
    dc.customer_key,
    dc.country,
    SUM(fs.sales_amount) AS total_revenue,
    DENSE_RANK() OVER (PARTITION BY dc.country ORDER BY SUM(fs.sales_amount) DESC) AS revenue_rank
FROM gold_fact_sales fs
JOIN gold_dim_customers dc ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.country 
ORDER BY total_revenue DESC) as sales
WHERE revenue_rank<=5;


-- The 3 customers with the fewest orders placed
SELECT 
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders 
LIMIT 3;

-- Identifing the most recent order per customer
SELECT *
FROM (
    SELECT 
        customer_key,
        order_number,
        order_date,
        product_key,
        ROW_NUMBER() OVER (PARTITION BY customer_key ORDER BY order_date DESC) AS rn
    FROM gold_fact_sales
) AS ranked
WHERE rn = 1;



