/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        YEAR(order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold_fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
) t;



-- Cumulitive Orders Per Month
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS months,
    COUNT(DISTINCT order_number) AS monthly_orders,
    SUM(COUNT(DISTINCT order_number)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS cumulative_orders
FROM gold_fact_sales
GROUP BY months
ORDER BY months;
