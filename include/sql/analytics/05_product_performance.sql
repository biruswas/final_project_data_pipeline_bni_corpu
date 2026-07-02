-- =====================================================
-- 05 PRODUCT PERFORMANCE
-- Produk rekening dengan volume transaksi,
-- nilai transaksi, dan rata-rata saldo tertinggi
-- =====================================================

SELECT
    a.account_type,
    COUNT(f.transaction_id) AS total_transactions,
    SUM(f.amount) AS total_transaction_amount,
    AVG(f.balance_after) AS avg_balance_after,
    AVG(f.balance_before) AS avg_balance_before,
    COUNT(DISTINCT a.account_id) AS total_accounts
FROM fact_transactions f
JOIN dim_accounts a
    ON f.account_id::INTEGER = a.account_id
GROUP BY a.account_type
ORDER BY total_transaction_amount DESC;