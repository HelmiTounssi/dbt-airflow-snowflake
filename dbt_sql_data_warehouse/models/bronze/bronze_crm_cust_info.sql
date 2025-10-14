{{ config(materialized='table', schema='bronze') }}

SELECT
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
FROM {{ source('source_crm', 'crm_cust_info') }}
