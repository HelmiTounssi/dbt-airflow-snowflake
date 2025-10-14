{{ config(materialized='table', schema='bronze') }}

SELECT
    cid,
    bdate,
    gen
FROM {{ source('source_erp', 'erp_cust_az12') }}
