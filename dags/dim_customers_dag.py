from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime

default_args = {
    "owner": "airflow"
}

with DAG(
    dag_id="dim_customers_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule_interval=None,
    catchup=False,
    default_args=default_args
) as dag:

    transform_dim_customers = SQLExecuteQueryOperator(
        task_id="transform_dim_customers",
        conn_id="postgres_default",
        sql="include/sql/01_transform.sql"
    )