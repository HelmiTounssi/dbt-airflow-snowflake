# Airbyte Setup for CSV to Snowflake ODS Integration

This guide provides instructions for setting up Airbyte to integrate CSV files from your dbt `seeds` directory into a Snowflake Operational Data Store (ODS).

## Prerequisites

Before you begin, ensure you have:

*   **Docker and Docker Compose**: Airbyte is typically deployed using Docker.
*   **Snowflake Account**: With necessary credentials and permissions to create schemas and tables.
*   **dbt Project with Seeds**: Your `dbt_sql_data_warehouse/seeds` directory containing the CSV files you want to ingest.

## 1. Install and Run Airbyte

Airbyte can be easily set up using Docker Compose.

1.  **Download Airbyte**:
    ```bash
    git clone https://github.com/airbytehq/airbyte.git
    cd airbyte
    ```

2.  **Start Airbyte**:
    ```bash
    docker compose up -d
    ```
    This will start all Airbyte services. It might take a few minutes for all containers to be up and running.

3.  **Access Airbyte UI**:
    Open your web browser and navigate to `http://localhost:8000`.

## 2. Configure Airbyte Source Connector (File)

You will set up a File source connector to read your CSV files from the `dbt_sql_data_warehouse/seeds` directory.

1.  **Create a new Source**:
    *   In the Airbyte UI, navigate to `Sources` and click `+ New source`.
    *   Select `File` as the Source type.

2.  **Source Configuration**:
    *   **Source Name**: `dbt_seeds_csv` (or any descriptive name).
    *   **File Type**: `CSV`
    *   **Storage**: `Local file system`
    *   **Reader Options**: Configure as needed (e.g., `Header Row`, `Delimiter`).
    *   **File Path**: This is crucial. You need to make your `dbt_sql_data_warehouse/seeds` directory accessible to the Airbyte container.
        *   **Option A (Recommended - Docker Volume)**: Modify your `airbyte/docker-compose.yaml` file to mount your local `dbt_sql_data_warehouse/seeds` directory into the Airbyte `worker` container.
            *   Locate the `airbyte-worker` service in `docker-compose.yaml`.
            *   Add a `volumes` entry:
                ```yaml
                volumes:
                  - /path/to/your/dbt_sql_data_warehouse/seeds:/tmp/airbyte_local_data/seeds:ro
                ```
                Replace `/path/to/your/dbt_sql_data_warehouse/seeds` with the absolute path to your `seeds` directory on your host machine. The `/tmp/airbyte_local_data/seeds` is the path inside the Airbyte container.
            *   After modifying `docker-compose.yaml`, restart Airbyte: `docker compose down` then `docker compose up -d`.
            *   In Airbyte UI, set **File Path** to `/tmp/airbyte_local_data/seeds/*.csv` (or specific file names like `/tmp/airbyte_local_data/seeds/your_seed_file.csv`).
        *   **Option B (Less Recommended - Copy files)**: Manually copy your CSV files into a directory accessible by the Airbyte container (e.g., `airbyte/data`). Then specify the path in the UI. This is less automated.

3.  **Test and Save**:
    *   Click `Set up source` to test the connection.
    *   If successful, save the source.

## 3. Configure Airbyte Destination Connector (Snowflake)

You will set up a Snowflake destination connector to load data into your Snowflake ODS.

1.  **Create a new Destination**:
    *   In the Airbyte UI, navigate to `Destinations` and click `+ New destination`.
    *   Select `Snowflake` as the Destination type.

2.  **Destination Configuration**:
    *   **Destination Name**: `Snowflake ODS` (or any descriptive name).
    *   **Host**: Your Snowflake account identifier (e.g., `your_account.snowflakecomputing.com`).
    *   **Role**: The Snowflake role Airbyte will use (e.g., `AIRBYTE_ROLE`).
    *   **Warehouse**: The Snowflake warehouse Airbyte will use (e.g., `AIRBYTE_WH`).
    *   **Database**: The Snowflake database where the ODS schema will be created (e.g., `YOUR_DATABASE`).
    *   **Schema**: The schema where Airbyte will write the raw data (e.g., `ODS_RAW`). Airbyte will create this schema if it doesn't exist.
    *   **Username/Password**: Your Snowflake user credentials.
    *   **Loading Method**: `Standard` (or `S3/GCS Staging` if you prefer external staging).

3.  **Test and Save**:
    *   Click `Set up destination` to test the connection.
    *   If successful, save the destination.

## 4. Create an Airbyte Connection

Now, create a connection to define the data flow from your CSV seeds to Snowflake ODS.

1.  **Create a new Connection**:
    *   In the Airbyte UI, navigate to `Connections` and click `+ New connection`.
    *   Select your `dbt_seeds_csv` Source and `Snowflake ODS` Destination.

2.  **Connection Configuration**:
    *   **Replication frequency**: Choose your desired sync schedule (e.g., `Every 5 minutes`, `Daily`).
    *   **Destination Namespace**: `Custom` -> `ODS_RAW` (or your chosen ODS schema).
    *   **Destination Stream Prefix**: (Optional) Add a prefix like `airbyte_` to distinguish Airbyte-ingested tables.
    *   **Sync Mode**: For initial load and incremental updates, `Full refresh | Overwrite` or `Incremental | Append` might be suitable depending on your seed data and requirements. For seeds, `Full refresh | Overwrite` is often appropriate.
    *   **Streams**: Select the CSV files (streams) you want to sync. Airbyte should auto-discover them from your configured File source path.

3.  **Set up Connection**:
    *   Click `Set up connection`. Airbyte will perform an initial sync.

## 5. Integrate with Airflow (Optional)

Once your Airbyte connection is set up, you can orchestrate Airbyte syncs using Airflow.

1.  **Install Airbyte Airflow Provider**:
    If not already installed, add the Airbyte provider to your Airflow environment:
    ```bash
    pip install apache-airflow-providers-airbyte
    ```

2.  **Create an Airflow Connection for Airbyte**:
    In your Airflow UI (Admin -> Connections), create a new HTTP connection:
    *   **Conn Id**: `airbyte_connection` (or any ID you prefer).
    *   **Conn Type**: `HTTP`
    *   **Host**: `http://airbyte-webapp:8000` (if Airbyte is running in Docker Compose on the same network as Airflow) or `http://localhost:8000` (if Airflow can reach Airbyte on localhost).

3.  **Airflow DAG for Airbyte Sync**:
    You can use the `AirbyteTriggerSyncOperator` in your Airflow DAG.

    ```python
    from airflow import DAG
    from airflow.utils.dates import days_ago
    from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator

    with DAG(
        dag_id='airbyte_csv_to_snowflake_ods',
        start_date=days_ago(1),
        schedule_interval='@daily',
        catchup=False,
        tags=['airbyte', 'snowflake', 'ods'],
    ) as dag:
        trigger_airbyte_sync = AirbyteTriggerSyncOperator(
            task_id='airbyte_sync_seeds_to_snowflake',
            airbyte_conn_id='airbyte_connection',  # The Airflow connection ID for Airbyte
            connection_id='YOUR_AIRBYTE_CONNECTION_ID',  # The UUID of your Airbyte connection
            asynchronous=False,  # Set to True to run in the background
            wait_for_completion=True,
        )
    ```
    *Note: Replace `YOUR_AIRBYTE_CONNECTION_ID` with the actual UUID of the connection you created in Airbyte. You can find this in the Airbyte UI under the connection settings URL.*

By following these steps, you can effectively use Airbyte to automate the ingestion of your CSV seed data into Snowflake, providing a robust ODS layer for your dbt transformations.
