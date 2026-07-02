TRUNCATE TABLE trx_clean;

INSERT INTO trx_clean (
    transaction_id,
    transaction_code,
    account_id,
    customer_id,
    branch_id,
    channel_id,
    transaction_date,
    transaction_at,
    transaction_type,
    amount,
    balance_before,
    balance_after,
    status,
    reference_no
)
SELECT
    transaction_id,
    transaction_code,
    account_id,
    customer_id,
    branch_id::INTEGER,
    channel_id::INTEGER,
    transaction_date::DATE,
    transaction_at::TIMESTAMP,
    transaction_type,
    amount::NUMERIC(18,2),
    balance_before::NUMERIC(18,2),
    balance_after::NUMERIC(18,2),
    status,
    reference_no
FROM trx_raw
WHERE transaction_id IS NOT NULL;