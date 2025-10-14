{{ config(materialized='table', schema='bronze') }}

SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM {{ source('source_crm', 'crm_prd_info') }}
