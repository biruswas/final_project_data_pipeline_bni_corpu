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
    "fraud_labels.csv"
)

DDL_STATEMENTS = """
CREATE TABLE IF NOT EXISTS stg_fraud_labels (
    transaction_id INTEGER,
    transaction_code VARCHAR(50),
    is_fraud VARCHAR(10),
    fraud_type VARCHAR(100),
    fraud_score NUMERIC(5,4),
    flagged_at VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS fraud_labels (
    transaction_id INTEGER PRIMARY KEY,
    transaction_code VARCHAR(50),
    is_fraud BOOLEAN,
    fraud_type VARCHAR(100),
    fraud_score NUMERIC(5,4),
    flagged_at TIMESTAMP,
    etl_loaded_at TIMESTAMP DEFAULT NOW()
);
"""

@dag(
    dag_id="dag_etl_fraud_labels",
    description="ETL fraud_labels.csv → fraud_labels",
    default_args={
        "owner":"airflow",
        "retries":1,
        "retry_delay":timedelta(minutes=5),
        "email_on_failure":False,
    },
    start_date=datetime(2025,1,1),
    schedule=None,
    catchup=False,
    tags=["etl","fraud"],
    template_searchpath=["/opt/airflow/include/sql/fraud_labels"],
)
def dag_etl_fraud_labels():

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
            con.execute(text("TRUNCATE TABLE stg_fraud_labels"))

        df.to_sql(
            "stg_fraud_labels",
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

dag_etl_fraud_labels()