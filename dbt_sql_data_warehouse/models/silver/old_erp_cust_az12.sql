{{ config(materialized='table', schema='silver') }}

SELECT
    cid,
    bdate,
    gen,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ get_ref_data('bronze_erp_cust_az12') }}
