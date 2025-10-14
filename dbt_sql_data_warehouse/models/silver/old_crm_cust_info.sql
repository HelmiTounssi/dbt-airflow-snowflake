{{ config(materialized='table', schema='silver') }}

SELECT
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ ref('bronze_crm_cust_info') }}
