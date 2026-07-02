-- ==========================================================
-- BRANCH PERFORMANCE
-- ==========================================================
-- 1. Ranking Cabang berdasarkan Jumlah Transaksi per Region
-- 2. Ranking Cabang berdasarkan Nilai Transaksi per Region
-- ==========================================================



-- ==========================================================
-- QUERY 1
-- CABANG DENGAN JUMLAH TRANSAKSI TERBANYAK PER REGION
-- ==========================================================

SELECT
    region,
    branch_name,
    total_transactions
FROM (
    SELECT
        db.region,
        db.branch_name,
        COUNT(ft.transaction_id) AS total_transactions,
        RANK() OVER (
            PARTITION BY db.region
            ORDER BY COUNT(ft.transaction_id) DESC
        ) AS ranking
    FROM fact_transactions ft
    JOIN dim_branches db
        ON ft.branch_id = db.branch_id
    GROUP BY
        db.region,
        db.branch_name
) t
WHERE ranking = 1
ORDER BY region;



-- ==========================================================
-- QUERY 2
-- CABANG DENGAN NILAI TRANSAKSI TERBESAR PER REGION
-- ==========================================================

SELECT
    region,
    branch_name,
    total_amount
FROM (
    SELECT
        db.region,
        db.branch_name,
        SUM(ft.amount) AS total_amount,
        RANK() OVER (
            PARTITION BY db.region
            ORDER BY SUM(ft.amount) DESC
        ) AS ranking
    FROM fact_transactions ft
    JOIN dim_branches db
        ON ft.branch_id = db.branch_id
    GROUP BY
        db.region,
        db.branch_name
) t
WHERE ranking = 1
ORDER BY region;