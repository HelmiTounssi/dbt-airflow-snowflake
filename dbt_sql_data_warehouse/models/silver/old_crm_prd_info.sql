{{ config(materialized='table', schema='silver') }}

SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ ref('bronze_crm_prd_info') }}
