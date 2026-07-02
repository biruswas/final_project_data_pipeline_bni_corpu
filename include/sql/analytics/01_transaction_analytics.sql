-- =====================================================
-- QUERY 1
-- Total Volume & Nilai Transaksi
-- Per Hari, Minggu, dan Bulan
-- =====================================================

---------------------------------------------------------
-- 1. TRANSAKSI HARIAN
---------------------------------------------------------

SELECT
    transaction_date,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM fact_transactions
GROUP BY transaction_date
ORDER BY transaction_date;

---------------------------------------------------------
-- 2. TRANSAKSI MINGGUAN
---------------------------------------------------------

SELECT
    DATE_TRUNC('week', transaction_date) AS week_start,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM fact_transactions
GROUP BY DATE_TRUNC('week', transaction_date)
ORDER BY week_start;

---------------------------------------------------------
-- 3. TRANSAKSI BULANAN
---------------------------------------------------------

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM fact_transactions
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;

---------------------------------------------------------
-- 4. PERTUMBUHAN BULANAN (%)
---------------------------------------------------------

WITH monthly AS (

SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM fact_transactions
GROUP BY DATE_TRUNC('month', transaction_date)

)

SELECT
    month,
    total_transactions,
    total_amount,

    LAG(total_transactions) OVER(ORDER BY month)
        AS prev_transactions,

    ROUND(
        (
            (total_transactions -
             LAG(total_transactions) OVER(ORDER BY month))
            *100.0
            /
            NULLIF(LAG(total_transactions)
            OVER(ORDER BY month),0)
        ),2
    ) AS transaction_growth_percent,

    LAG(total_amount) OVER(ORDER BY month)
        AS prev_amount,

    ROUND(
        (
            (total_amount -
             LAG(total_amount) OVER(ORDER BY month))
            *100.0
            /
            NULLIF(LAG(total_amount)
            OVER(ORDER BY month),0)
        ),2
    ) AS amount_growth_percent

FROM monthly
ORDER BY month;