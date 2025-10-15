# dbt-airflow-snowflake

This repository contains a dbt project for building a data warehouse on Snowflake, orchestrated with Airflow.

## Project Overview

This project aims to demonstrate a robust data warehousing solution using dbt for data transformation and Snowflake as the data platform, with Airflow handling the orchestration of dbt jobs. The data warehouse is structured into three main layers:

- **Bronze Layer**: Contains raw, untransformed data directly ingested from various source systems (CRM, ERP).
- **Silver Layer**: Houses cleaned, conformed, and slightly transformed data, ready for further aggregation. This layer often involves standardizing data types, handling missing values, and basic data quality checks.
- **Gold Layer**: Consists of highly curated, aggregated, and business-ready data models optimized for reporting, analytics, and business intelligence tools. This layer typically includes fact and dimension tables.

## Project Structure

- `dbt_sql_data_warehouse/models/bronze`: Raw data models from various sources.
- `dbt_sql_data_warehouse/models/silver`: Staging models with basic transformations.
- `dbt_sql_data_warehouse/models/gold`: Curated and aggregated data models for reporting and analysis.
- `dbt_sql_data_warehouse/dbt_project.yml`: dbt project configuration.
- `dbt_sql_data_warehouse/sources.yml`: Source definitions for dbt.

## Setup and Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/HelmiTounssi/dbt-airflow-snowflake.git
   cd dbt-airflow-snowflake
   ```

2. **Install dbt:**
   Follow the instructions [here](https://docs.getdbt.com/docs/get-started/install-dbt) to install dbt and the dbt-snowflake adapter.

3. **Configure dbt profiles:**
   Set up your `profiles.yml` file to connect to your Snowflake instance. An example `profiles.yml` might look like this:

   ```yaml
   dbt_sql_data_warehouse:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: your_snowflake_account
         user: your_snowflake_user
         password: your_snowflake_password
         role: your_snowflake_role
         warehouse: your_snowflake_warehouse
         database: your_snowflake_database
         schema: your_snowflake_schema
         threads: 4
         client_session_keep_alive: False
         query_tag: dbt
   ```

4. **Run dbt:**
   ```bash
   dbt deps
   dbt seed
   dbt run
   dbt test
   ```

## Airflow Integration

The dbt jobs in this project are orchestrated using Apache Airflow. This typically involves:

- **Airflow DAGs**: Directed Acyclic Graphs (DAGs) define the sequence of tasks, including dbt commands (e.g., `dbt run`, `dbt test`).
- **dbt Operator**: Using a dbt-specific Airflow operator (or a BashOperator to execute dbt CLI commands) to trigger dbt runs.
- **Connections**: Configuring Airflow connections to Snowflake and potentially other data sources.
- **Scheduling**: Defining schedules for when the dbt jobs should run.

Example of a simple Airflow DAG task to run dbt:

```python
from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id='dbt_data_warehouse',
    start_date=datetime(2023, 1, 1),
    schedule_interval='@daily',
    catchup=False
) as dag:
    dbt_run = BashOperator(
        task_id='dbt_run_models',
        bash_command='cd /path/to/your/dbt_sql_data_warehouse && dbt run --project-dir .',
    )

    dbt_test = BashOperator(
        task_id='dbt_test_models',
        bash_command='cd /path/to/your/dbt_sql_data_warehouse && dbt test --project-dir .',
    )

    dbt_run >> dbt_test
```
*Note: Replace `/path/to/your/dbt_sql_data_warehouse` with the actual path to your dbt project within your Airflow environment.*

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature-name`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/your-feature-name`).
6. Open a Pull Request.

Please ensure your code adheres to the existing style and passes all tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
