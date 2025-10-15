# Apache Airflow Local Setup (Non-Admin User)

This guide provides instructions for setting up a local Apache Airflow environment without requiring administrative privileges. This is useful for development and testing purposes where you don't have root access to the system.

## Prerequisites

Before you begin, ensure you have:

*   **Python 3.8+**: Airflow requires a compatible Python version.
*   **pip**: Python's package installer.

## 1. Set up a Virtual Environment (Recommended)

It's highly recommended to use a Python virtual environment to avoid conflicts with system-wide packages.

```bash
python -m venv airflow_venv
source airflow_venv/Scripts/activate  # On Windows
# source airflow_venv/bin/activate    # On Linux/macOS
```

## 2. Install Apache Airflow

Install Airflow and the necessary providers (e.g., `apache-airflow-providers-snowflake` for Snowflake integration) using the `--user` flag to install into your user directory.

```bash
pip install --user "apache-airflow[cncf.kubernetes,celery,apache.snowflake,apache.apache-spark,databricks,docker,google,http,microsoft.azure,mysql,postgres,redis,sftp,slack,ssh]" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.9.3/constraints-3.8.txt"
# Replace constraints-2.9.3 and constraints-3.8.txt with the appropriate versions for your setup.
# The above command installs Airflow with a wide range of common providers. Adjust as needed.
```

**Note**: The `constraints-X.Y.Z/constraints-3.8.txt` URL should match your Airflow version and Python version. Check the official Airflow documentation for the correct constraints file.

## 3. Configure AIRFLOW_HOME

Set the `AIRFLOW_HOME` environment variable to a directory within your user space. This is where Airflow will store its database, DAGs, logs, and configurations.

```bash
# On Windows (Command Prompt)
set AIRFLOW_HOME=%USERPROFILE%\airflow

# On Windows (PowerShell)
$env:AIRFLOW_HOME="$HOME\airflow"

# On Linux/macOS
export AIRFLOW_HOME=~/airflow
```

Create the `AIRFLOW_HOME` directory:

```bash
mkdir %AIRFLOW_HOME% # On Windows
# mkdir $AIRFLOW_HOME # On Linux/macOS
```

## 4. Initialize the Airflow Database

Airflow uses a metadata database to store DAG and task states. Initialize it:

```bash
airflow db migrate
```

## 5. Create an Airflow User

Create an admin user for the Airflow UI. You will be prompted to enter details like username, first name, last name, phone number, and password.

```bash
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com
```

## 6. Start the Airflow Webserver and Scheduler

Open two separate terminal windows (with your virtual environment activated and `AIRFLOW_HOME` set).

**Terminal 1 (Webserver):**

```bash
airflow webserver --port 8080
```

**Terminal 2 (Scheduler):**

```bash
airflow scheduler
```

You can now access the Airflow UI by navigating to `http://localhost:8080` in your web browser and logging in with the user you created.

## 7. Place dbt Project and DAGs

*   Copy your `dbt_sql_data_warehouse` project directory into your `$AIRFLOW_HOME/dags` folder.
*   Copy the `dags/dbt_dag.py` file (from this repository) into your `$AIRFLOW_HOME/dags` folder.

    *Example structure within your `$AIRFLOW_HOME/dags` folder:*
    ```
    airflow/
    ├── dags/
    │   ├── dbt_dag.py
    │   └── dbt_sql_data_warehouse/
    │       ├── models/
    │       ├── macros/
    │       └── ... (rest of your dbt project)
    ├── logs/
    ├── dbt_sql_data_warehouse/ (optional, if you prefer to keep dbt project outside dags folder)
    └── ... (other Airflow files)
    ```

    **Important**: Ensure the `DBT_PROJECT_DIR` variable in `dbt_dag.py` correctly points to the location of your `dbt_sql_data_warehouse` project within the Airflow environment.

## 8. Configure dbt Profiles for Airflow

Ensure the `profiles.yml` file that dbt uses is accessible by the Airflow user. Typically, this would be located at `~/.dbt/profiles.yml` (or `%USERPROFILE%\.dbt\profiles.yml` on Windows) in the home directory of the user running the Airflow scheduler and worker processes.

If your `profiles.yml` contains sensitive information, consider using Airflow Connections or environment variables to manage credentials securely.

By following these steps, you can set up and run Airflow locally without requiring administrative privileges, allowing you to orchestrate your dbt project effectively.
