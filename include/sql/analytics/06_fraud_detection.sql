-- ==========================================================
-- 06_fraud_detection.sql
-- Fraud Detection & Anomaly Detection
-- ==========================================================

------------------------------------------------------------
-- 1. HIGH VALUE TRANSACTIONS
-- Transaksi dengan nilai > 9.000.000
------------------------------------------------------------

SELECT
    transaction_id,
    customer_id,
    account_id,
    transaction_date,
    transaction_type,
    amount,
    status
FROM fact_transactions
WHERE amount > 9000000
ORDER BY amount DESC;


------------------------------------------------------------
-- 2. CUSTOMER DENGAN FREKUENSI TRANSAKSI TERTINGGI
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount,
    AVG(amount) AS avg_transaction
FROM fact_transactions
GROUP BY customer_id
HAVING COUNT(*) > 40
ORDER BY total_transactions DESC;


------------------------------------------------------------
-- 3. CUSTOMER DENGAN FAILED TRANSACTION BERULANG
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS failed_transactions
FROM fact_transactions
WHERE status = 'FAILED'
GROUP BY customer_id
HAVING COUNT(*) >= 12
ORDER BY failed_transactions DESC;


------------------------------------------------------------
-- 4. FAILED RATE PER CUSTOMER
------------------------------------------------------------

SELECT
    customer_id,
    COUNT(*) AS total_transactions,

    SUM(
        CASE
            WHEN status='FAILED' THEN 1
            ELSE 0
        END
    ) AS failed_transactions,

    ROUND(
        100.0 *
        SUM(CASE WHEN status='FAILED' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS failed_percentage

FROM fact_transactions
GROUP BY customer_id
HAVING COUNT(*) >= 10
ORDER BY failed_percentage DESC;


------------------------------------------------------------
-- 5. FRAUD LABEL SUMMARY
------------------------------------------------------------

SELECT
    fraud_type,
    COUNT(*) AS total_cases,
    AVG(fraud_score) AS avg_score
FROM fraud_labels
GROUP BY fraud_type
ORDER BY total_cases DESC;


------------------------------------------------------------
-- 6. FRAUD TRANSACTIONS DETAIL
------------------------------------------------------------

SELECT
    f.transaction_id,
    t.customer_id,
    t.account_id,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    f.fraud_type,
    f.fraud_score
FROM fraud_labels f
JOIN fact_transactions t
    ON f.transaction_id = t.transaction_id::INTEGER
ORDER BY
    f.fraud_score DESC,
    t.amount DESC;