TRUNCATE TABLE dim_accounts;

INSERT INTO dim_accounts (

    account_id,
    account_no,
    account_type,
    product_name,
    currency,
    open_date,
    close_date,
    status,
    interest_rate,
    customer_id,
    branch_id,

    account_age,
    is_active

)

SELECT DISTINCT ON (account_id)

    account_id,
    account_no,
    account_type,
    product_name,
    currency,

    open_date::DATE,

    CASE
        WHEN close_date IS NULL
             OR close_date = ''
        THEN NULL
        ELSE close_date::DATE
    END,

    status,

    interest_rate,

    customer_id,

    branch_id,

    DATE_PART(
        'year',
        AGE(
            CURRENT_DATE,
            open_date::DATE
        )
    )::INTEGER,

    CASE
        WHEN status='ACTIVE'
        THEN TRUE
        ELSE FALSE
    END

FROM stg_accounts

WHERE account_id IS NOT NULL

ORDER BY account_id;