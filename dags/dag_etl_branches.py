import os
from datetime import datetime, timedelta

import pandas as pd
from sqlalchemy import create_engine, text

from airflow.decorators import dag, task
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

CONN_ID = "postgres_etl"

SOURCE_FILE = os.path.join(
    os.path.dirname(__file__),
    "..",
    "include",
    "dataset",
    "branches.csv"
)

DDL_STATEMENTS = """
CREATE TABLE IF NOT EXISTS stg_branches (
    branch_id INTEGER,
    branch_code VARCHAR(30),
    branch_name VARCHAR(100),
    city VARCHAR(100),
    province VARCHAR(100),
    region VARCHAR(100),
    branch_type VARCHAR(20),
    open_date VARCHAR(20),
    is_active VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS dim_branches (
    branch_id INTEGER PRIMARY KEY,
    branch_code VARCHAR(30),
    branch_name VARCHAR(100),
    city VARCHAR(100),
    province VARCHAR(100),
    region VARCHAR(100),
    branch_type VARCHAR(20),
    open_date DATE,
    is_active BOOLEAN,
    etl_loaded_at TIMESTAMP DEFAULT NOW()
);
"""

@dag(
    dag_id="dag_etl_branches",
    start_date=datetime(2025,1,1),
    schedule=None,
    catchup=False,
    default_args={
        "owner":"airflow",
        "retries":1,
        "retry_delay":timedelta(minutes=5)
    },
    template_searchpath=["/opt/airflow/include/sql/branches"],
    tags=["etl","branches"]
)
def dag_etl_branches():

    create_tables = SQLExecuteQueryOperator(
        task_id="create_tables",
        conn_id=CONN_ID,
        sql=DDL_STATEMENTS,
    )

    @task()
    def extract_load():

        from airflow.hooks.base import BaseHook

        conn = BaseHook.get_connection(CONN_ID)

        engine = create_engine(
            f"postgresql+psycopg2://{conn.login}:{conn.password}@{conn.host}:{conn.port}/{conn.schema}"
        )

        df = pd.read_csv(SOURCE_FILE)

        with engine.begin() as con:
            con.execute(text("TRUNCATE TABLE stg_branches"))

        df.to_sql(
            "stg_branches",
            engine,
            if_exists="append",
            index=False,
            method="multi",
            chunksize=1000
        )

        engine.dispose()

    transform = SQLExecuteQueryOperator(
        task_id="transform",
        conn_id=CONN_ID,
        sql="01_transform.sql",
    )

    create_tables >> extract_load() >> transform

dag_etl_branches()