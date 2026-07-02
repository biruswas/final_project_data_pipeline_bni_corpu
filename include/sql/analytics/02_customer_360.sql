-- =====================================================
-- CUSTOMER 360 ANALYTICS
-- =====================================================
-- 1. Nasabah paling aktif berdasarkan frekuensi transaksi
-- 2. Nasabah dengan nilai transaksi terbesar
-- 3. Distribusi nasabah berdasarkan segment
-- =====================================================



-- =====================================================
-- QUERY 1
-- TOP 10 NASABAH PALING AKTIF
-- (berdasarkan jumlah transaksi)
-- =====================================================

SELECT
    dc.customer_id,
    dc.customer_code,
    dc.full_name,
    dc.segment,
    COUNT(ft.transaction_id) AS total_transactions
FROM fact_transactions ft
JOIN dim_customers dc
    ON ft.customer_id::INTEGER = dc.customer_id
GROUP BY
    dc.customer_id,
    dc.customer_code,
    dc.full_name,
    dc.segment
ORDER BY total_transactions DESC
LIMIT 10;



-- =====================================================
-- QUERY 2
-- TOP 10 NASABAH BERDASARKAN NILAI TRANSAKSI
-- =====================================================

SELECT
    dc.customer_id,
    dc.customer_code,
    dc.full_name,
    dc.segment,
    COUNT(ft.transaction_id) AS total_transactions,
    SUM(ft.amount) AS total_amount,
    AVG(ft.amount) AS average_transaction
FROM fact_transactions ft
JOIN dim_customers dc
    ON ft.customer_id::INTEGER = dc.customer_id
GROUP BY
    dc.customer_id,
    dc.customer_code,
    dc.full_name,
    dc.segment
ORDER BY total_amount DESC
LIMIT 10;



-- =====================================================
-- QUERY 3
-- DISTRIBUSI NASABAH BERDASARKAN SEGMENT
-- =====================================================

SELECT
    segment,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM dim_customers
GROUP BY segment
ORDER BY total_customers DESC;