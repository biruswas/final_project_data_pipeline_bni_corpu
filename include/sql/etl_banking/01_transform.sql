-- =========================================================
-- 01_transform.sql (ALL IN ONE)
-- staging + dim table + transform
-- =========================================================

-- 1. CREATE STAGING TABLE (kalau belum ada)
CREATE TABLE IF NOT EXISTS stg_customers (
    customer_id BIGINT,
    customer_code VARCHAR(50),
    full_name VARCHAR(255),
    gender VARCHAR(10),
    birth_date DATE,
    email VARCHAR(255),
    phone VARCHAR(50),
    segment VARCHAR(50),
    job_segment VARCHAR(50),
    city VARCHAR(100),
    province VARCHAR(100),
    registration_date DATE,
    branch_id BIGINT,
    is_active TEXT,
    credit_score INT,
    estimated_salary NUMERIC
);

-- 2. CREATE DIM TABLE (kalau belum ada)
CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id BIGINT PRIMARY KEY,
    customer_code VARCHAR(50),
    full_name VARCHAR(255),
    gender VARCHAR(10),
    birth_date DATE,
    email VARCHAR(255),
    phone VARCHAR(50),
    segment VARCHAR(50),
    job_segment VARCHAR(50),
    city VARCHAR(100),
    province VARCHAR(100),
    registration_date DATE,
    branch_id BIGINT,
    is_active BOOLEAN,
    credit_score INT,
    estimated_salary NUMERIC,

    -- derived
    age SMALLINT,
    credit_score_segment VARCHAR(20),
    salary_segment VARCHAR(20)
);

-- 3. CLEAR DIM TABLE
TRUNCATE TABLE dim_customers;

-- 4. TRANSFORM + LOAD
INSERT INTO dim_customers (
    customer_id,
    customer_code,
    full_name,
    gender,
    birth_date,
    email,
    phone,
    segment,
    job_segment,
    city,
    province,
    registration_date,
    branch_id,
    is_active,
    credit_score,
    estimated_salary,
    age,
    credit_score_segment,
    salary_segment
)
SELECT DISTINCT ON (customer_id)
    customer_id,
    customer_code,
    full_name,
    gender,
    birth_date::DATE,
    email,
    phone,
    segment,
    job_segment,
    city,
    province,
    registration_date::DATE,
    branch_id,

    -- fix boolean conversion
    CASE WHEN LOWER(is_active) = 'true' THEN TRUE ELSE FALSE END,

    credit_score,
    estimated_salary,

    -- age
    DATE_PART('year', AGE(CURRENT_DATE, birth_date::DATE))::SMALLINT,

    -- credit score segment
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        WHEN credit_score < 800 THEN 'Very Good'
        ELSE 'Exceptional'
    END,

    -- salary segment
    CASE
        WHEN estimated_salary < 5000000 THEN 'Low'
        WHEN estimated_salary < 15000000 THEN 'Lower Middle'
        WHEN estimated_salary < 30000000 THEN 'Middle'
        WHEN estimated_salary < 50000000 THEN 'Upper Middle'
        ELSE 'High'
    END

FROM stg_customers
WHERE customer_id IS NOT NULL
ORDER BY customer_id;