{{ config(materialized='table', schema='bronze') }}

SELECT
    cid,
    bdate,
    gen
FROM {{ get_source_data('source_erp', 'erp_cust_az12') }}
