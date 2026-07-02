TRUNCATE TABLE dim_date;

INSERT INTO dim_date (

    date_id,
    full_date,
    year,
    quarter,
    month,
    month_name,
    week_of_year,
    day_of_month,
    day_of_week,
    day_name,
    is_weekend,
    is_holiday

)

SELECT DISTINCT ON (date_id)

    date_id,
    full_date::DATE,
    year,
    quarter,
    month,
    month_name,
    week_of_year,
    day_of_month,
    day_of_week,
    day_name,

    CASE
        WHEN LOWER(is_weekend)='true'
        THEN TRUE
        ELSE FALSE
    END,

    CASE
        WHEN LOWER(is_holiday)='true'
        THEN TRUE
        ELSE FALSE
    END

FROM stg_dim_date

ORDER BY date_id;