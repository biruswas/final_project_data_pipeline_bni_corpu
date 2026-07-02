TRUNCATE TABLE fraud_labels;

INSERT INTO fraud_labels (

    transaction_id,
    transaction_code,
    is_fraud,
    fraud_type,
    fraud_score,
    flagged_at

)

SELECT DISTINCT ON (transaction_id)

    transaction_id,
    transaction_code,

    CASE
        WHEN LOWER(is_fraud)='true'
        THEN TRUE
        ELSE FALSE
    END,

    fraud_type,
    fraud_score,
    flagged_at::TIMESTAMP

FROM stg_fraud_labels

ORDER BY transaction_id;