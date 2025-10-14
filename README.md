# dbt-airflow-snowflake

This repository contains a dbt project for building a data warehouse on Snowflake, orchestrated with Airflow.

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

(Add details about Airflow integration here, e.g., DAGs, connections, etc.)

## Contributing

(Add contribution guidelines here)

## License

(Add license information here)
