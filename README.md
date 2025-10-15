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

The dbt jobs in this project are orchestrated using Apache Airflow. A sample DAG (`dbt_dag.py`) is provided in the `dags/` directory to demonstrate this integration. For detailed instructions on setting up Airflow locally without admin access, please refer to [AIRFLOW_SETUP.md](AIRFLOW_SETUP.md).

### Airflow Setup

To integrate this dbt project with Airflow, follow these steps:

1.  **Place the dbt project and DAGs**:
    *   Copy the entire `dbt_sql_data_warehouse` directory into your Airflow DAGs folder (e.g., `/opt/airflow/dags/dbt_sql_data_warehouse`).
    *   Copy the `dags/dbt_dag.py` file into your Airflow DAGs folder (e.g., `/opt/airflow/dags/dbt_dag.py`).

2.  **Configure `dbt_dag.py`**:
    *   Open `dags/dbt_dag.py`.
    *   **`DBT_EXECUTABLE_PATH`**: Update this variable to the absolute path of your `dbt.exe` executable within the Airflow environment. Since you don't have admin access, ensure `dbt` is installed in a user-accessible location.
        *   Example: `DBT_EXECUTABLE_PATH = "/usr/local/bin/dbt"` (for Linux/WSL) or `"C:\\Users\\your_user\\AppData\\Local\\Packages\\PythonSoftwareFoundation.Python.3.13_qbz5n2kfra8p0\\LocalCache\\local-packages\\Python313\\Scripts\\dbt.exe"` (for Windows, if Airflow runs on Windows).
    *   **`DBT_PROJECT_DIR`**: Update this variable to the absolute path of your `dbt_sql_data_warehouse` directory within the Airflow environment.
        *   Example: `DBT_PROJECT_DIR = "/opt/airflow/dags/dbt_sql_data_warehouse"`

3.  **dbt Profiles**:
    *   Ensure your `profiles.yml` file (typically located at `~/.dbt/profiles.yml` in the Airflow worker's home directory) is correctly configured to connect to your Snowflake instance. This file should be accessible by the Airflow user.

4.  **Airflow Connections**:
    *   If your `profiles.yml` uses environment variables for credentials (recommended for security), ensure these environment variables are set in your Airflow environment.
    *   Alternatively, you can configure a Snowflake connection directly in Airflow UI (Admin -> Connections) if you have the necessary permissions. However, the provided `dbt_dag.py` uses `dbt` CLI commands, which rely on `profiles.yml`, so direct Airflow connections are less critical for this setup.

### DAG Structure

The `dbt_data_warehouse_pipeline` DAG includes the following tasks, executed sequentially using `BashOperator`:

-   `dbt_deps`: Installs dbt package dependencies.
-   `dbt_seed`: Loads seed data into the data warehouse.
-   `dbt_run`: Executes all dbt models.
-   `dbt_test`: Runs tests defined in the dbt project.

This setup allows for a robust and automated data transformation pipeline within Airflow.

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
