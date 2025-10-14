{{ config(materialized='table', schema='silver') }}

SELECT
    cid,
    bdate,
    gen,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ ref('bronze_erp_cust_az12') }}
