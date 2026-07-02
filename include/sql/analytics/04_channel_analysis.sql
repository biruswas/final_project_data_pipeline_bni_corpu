-- ==========================================================
-- CHANNEL ANALYSIS
-- ==========================================================
-- 1. Channel paling banyak digunakan
-- 2. Tren penggunaan Digital vs Physical Channel
-- ==========================================================



-- ==========================================================
-- QUERY 1
-- CHANNEL PALING BANYAK DIGUNAKAN
-- ==========================================================

SELECT
    dc.channel_name,
    dc.channel_category,
    COUNT(ft.transaction_id) AS total_transactions,
    SUM(ft.amount) AS total_amount,
    ROUND(AVG(ft.amount),2) AS average_amount
FROM fact_transactions ft
JOIN dim_channels dc
    ON ft.channel_id = dc.channel_id
GROUP BY
    dc.channel_name,
    dc.channel_category
ORDER BY total_transactions DESC;



-- ==========================================================
-- QUERY 2
-- TREN MIGRASI KE DIGITAL
-- ==========================================================

SELECT
    DATE_TRUNC('month', ft.transaction_date) AS month,
    dc.channel_category,
    COUNT(ft.transaction_id) AS total_transactions,
    SUM(ft.amount) AS total_amount
FROM fact_transactions ft
JOIN dim_channels dc
    ON ft.channel_id = dc.channel_id
GROUP BY
    DATE_TRUNC('month', ft.transaction_date),
    dc.channel_category
ORDER BY
    month,
    dc.channel_category;