
-- ============================================================
-- APEXPLANET TASK 2
-- SQL & DATA EXTRACTION
-- ============================================================

-- 1. SELECT
SELECT *
FROM sales
LIMIT 10;

-- 2. WHERE
SELECT *
FROM  sales
WHERE quantity > 1;

-- 3. ORDER BY
SELECT *
FROM sales
ORDER BY total_sales DESC;

-- 4. LIMIT
SELECT *
FROM  sales
LIMIT 5;

-- 5. Aggregate Functions
SELECT
    COUNT(*) AS total_transactions,
    SUM(total_sales) AS total_sales,
    AVG(total_sales) AS average_sales,
    MIN(total_sales) AS minimum_sales,
    MAX(total_sales) AS maximum_sales
FROM sales;

-- 6. GROUP BY
SELECT
    category,
    COUNT(*) AS transactions,
    SUM(total_sales) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- 7. HAVING
SELECT
    category,
    SUM(total_sales) AS total_sales
FROM sales
GROUP BY category
HAVING SUM(total_sales) > 0;

-- 8. JOIN
SELECT
    s.customer_key,
    s.total_sales
FROM sales s
INNER JOIN customers c
    ON s.customer_key = c.customer_key;

-- 9. Subquery
SELECT *
FROM sales
WHERE total_sales >
(
    SELECT AVG(total_sales)
    FROM sales
);

-- 10. CTE
WITH category_sales AS
(
    SELECT
        category,
        SUM(total_sales) AS total_sales
    FROM sales
    GROUP BY category
)
SELECT *
FROM category_sales
ORDER BY total_sales DESC;

-- 11. ROW_NUMBER
SELECT
    customer_key,
    total_sales,
    ROW_NUMBER() OVER (
        ORDER BY total_sales DESC
    ) AS row_number
FROM sales;

-- 12. RANK
SELECT
    customer_key,
    total_sales,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM sales;

-- 13. LAG
SELECT
    date,
    total_sales,
    LAG(total_sales) OVER (
        ORDER BY date
    ) AS previous_sales
FROM sales;

-- 14. LEAD
SELECT
    date,
    total_sales,
    LEAD(total_sales) OVER (
        ORDER BY date
    ) AS next_sales
FROM sales;

-- 15. Monthly Sales
SELECT
    strftime('%Y-%m', date) AS month,
    SUM(total_sales) AS monthly_sales
FROM sales
GROUP BY month
ORDER BY month;

-- 16. Top 10 Customers
SELECT
    customer_key,
    SUM(total_sales) AS total_revenue
FROM sales
GROUP BY customer_key
ORDER BY total_revenue DESC
LIMIT 10;

-- 17. Product Performance
SELECT
    product,
    SUM(total_sales) AS total_sales
FROM sales
GROUP BY product
ORDER BY total_sales DESC;

-- 18. Moving Average
WITH daily_sales AS
(
    SELECT
        date,
        SUM(total_sales) AS daily_sales
    FROM sales
    GROUP BY date
)
SELECT
    date,
    daily_sales,
    AVG(daily_sales) OVER (
        ORDER BY date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_average
FROM daily_sales;

-- 19. Cumulative Sales
WITH daily_sales AS
(
    SELECT
        date,
        SUM(total_sales) AS daily_sales
    FROM sales
    GROUP BY date
)
SELECT
    date,
    daily_sales,
    SUM(daily_sales) OVER (
        ORDER BY date
    ) AS cumulative_sales
FROM daily_sales;

-- 20. Customer Retention
SELECT
    customer_key,
    COUNT(*) AS transactions,
    CASE
        WHEN COUNT(*) > 1
        THEN 'Returning Customer'
        ELSE 'One-Time Customer'
    END AS customer_status
FROM sales
GROUP BY customer_key;

-- 21. View
CREATE VIEW IF NOT EXISTS category_sales_view AS
SELECT
    category,
    COUNT(*) AS transactions,
    SUM(total_sales) AS total_sales
FROM sales
GROUP BY category;

-- 22. Index
CREATE INDEX IF NOT EXISTS idx_sales_customer
ON sales(customer_key);

-- 23. EXPLAIN
EXPLAIN QUERY PLAN
SELECT *
FROM sales
WHERE total_sales > 100;
