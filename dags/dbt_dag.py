from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_EXECUTABLE_PATH = "C:\\Users\\hbenabdallah\\AppData\\Local\\Packages\\PythonSoftwareFoundation.Python.3.13_qbz5n2kfra8p0\\LocalCache\\local-packages\\Python313\\Scripts\\dbt.exe"
DBT_PROJECT_DIR = "/opt/airflow/dags/dbt_sql_data_warehouse" # This path needs to be adjusted based on Airflow's environment

with DAG(
    dag_id='dbt_data_warehouse_pipeline',
    start_date=datetime(2023, 1, 1),
    schedule_interval='@daily',
    catchup=False,
    tags=['dbt', 'data_warehouse'],
) as dag:
    dbt_deps = BashOperator(
        task_id='dbt_deps',
        bash_command=f'"{DBT_EXECUTABLE_PATH}" deps --project-dir {DBT_PROJECT_DIR}',
    )

    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command=f'"{DBT_EXECUTABLE_PATH}" seed --project-dir {DBT_PROJECT_DIR}',
    )

    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command=f'"{DBT_EXECUTABLE_PATH}" run --project-dir {DBT_PROJECT_DIR}',
    )

    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command=f'"{DBT_EXECUTABLE_PATH}" test --project-dir {DBT_PROJECT_DIR}',
    )

    dbt_deps >> dbt_seed >> dbt_run >> dbt_test
