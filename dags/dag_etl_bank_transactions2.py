"""
dag_etl_bank_transactions.py
==============================
ETL pipeline: transactions.csv → PostgreSQL

Task flow:
    create_tables  (SQLExecuteQueryOperator) : buat tabel staging, clean, final
    extract        (@task Python)            : baca CSV → trx_raw (staging)
    transform      (SQLExecuteQueryOperator) : trx_raw → trx_clean
    load           (SQLExecuteQueryOperator) : trx_clean → trx_sample (upsert)

Airflow Connection yang dibutuhkan:
    conn_id = "postgres_etl"  (tipe: Postgres)
    Host: postgres-etl | Port: 5432 | DB: etl_db
"""

import os
from datetime import datetime, timedelta

import pandas as pd
from sqlalchemy import create_engine, text

from airflow.decorators import dag, task
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

# ─── Konstanta ────────────────────────────────────────────────────────────────
CONN_ID     = "postgres_etl"
SOURCE_FILE = os.path.join(
    os.path.dirname(__file__), "..", "include", "dataset", "transactions.csv"
)

DDL_STATEMENTS = """
CREATE TABLE IF NOT EXISTS trx_raw (
    transaction_id      TEXT,
    transaction_code    TEXT,
    account_id          TEXT,
    customer_id         TEXT,
    branch_id           TEXT,
    channel_id          TEXT,
    transaction_date    TEXT,
    transaction_at      TEXT,
    transaction_type    TEXT,
    amount              TEXT,
    balance_before      TEXT,
    balance_after       TEXT,
    status              TEXT,
    reference_no        TEXT
);

CREATE TABLE IF NOT EXISTS trx_clean (
    transaction_id      VARCHAR(50),
    transaction_code    VARCHAR(50),
    account_id          VARCHAR(50),
    customer_id         VARCHAR(50),
    branch_id           INTEGER,
    channel_id          INTEGER,
    transaction_date    DATE,
    transaction_at      TIMESTAMP,
    transaction_type    VARCHAR(50),
    amount              NUMERIC(18,2),
    balance_before      NUMERIC(18,2),
    balance_after       NUMERIC(18,2),
    status              VARCHAR(20),
    reference_no        VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS trx_sample (
    transaction_id      VARCHAR(50),
    transaction_code    VARCHAR(50),
    account_id          VARCHAR(50),
    customer_id         VARCHAR(50),
    branch_id           INTEGER,
    channel_id          INTEGER,
    transaction_date    DATE,
    transaction_at      TIMESTAMP,
    transaction_type    VARCHAR(50),
    amount              NUMERIC(18,2),
    balance_before      NUMERIC(18,2),
    balance_after       NUMERIC(18,2),
    status              VARCHAR(20),
    reference_no        VARCHAR(100)
);
"""


# ─── DAG ──────────────────────────────────────────────────────────────────────
@dag(
    dag_id              = "dag_etl_bank_transactions",
    description         = "ETL transactions.csv → PostgreSQL trx_sample",
    default_args        = {
        "owner"           : "airflow",
        "retries"         : 1,
        "retry_delay"     : timedelta(minutes=5),
        "email_on_failure": False,
    },
    start_date          = datetime(2025, 1, 1),
    schedule            = None,
    catchup             = False,
    tags                = ["etl", "banking", "postgresql"],
    template_searchpath = ["/opt/airflow/include/sql/etl_banking"],
)
def dag_etl_bank_transactions():

    # ── Task 1: DDL ───────────────────────────────────────────────────────────
    create_tables = SQLExecuteQueryOperator(
        task_id = "create_tables",
        conn_id = CONN_ID,
        sql     = DDL_STATEMENTS,
    )

    # ── Task 2: Extract CSV → trx_raw ─────────────────────────────────────────
    @task()
    def extract():
        from airflow.hooks.base import BaseHook

        conn     = BaseHook.get_connection(CONN_ID)
        conn_str = (
            f"postgresql+psycopg2://{conn.login}:{conn.password}"
            f"@{conn.host}:{conn.port}/{conn.schema}"
        )
        engine = create_engine(conn_str)

        df = pd.read_csv(SOURCE_FILE)

        with engine.connect() as c:
            c.execute(text("TRUNCATE TABLE trx_raw"))
            c.commit()

        df.to_sql(
            name      = "trx_raw",
            con       = engine,
            if_exists = "append",
            index     = False,
            method    = "multi",
            chunksize = 1000,
        )
        engine.dispose()
        return len(df)

    # ── Task 3: Transform trx_raw → trx_clean ────────────────────────────────
    transform = SQLExecuteQueryOperator(
        task_id = "transform",
        conn_id = CONN_ID,
        sql     = "01_transform.sql",
    )

    # ── Dependencies ──────────────────────────────────────────────────────────
    create_tables >> extract() >> transform >> load


dag_etl_bank_transactions()
