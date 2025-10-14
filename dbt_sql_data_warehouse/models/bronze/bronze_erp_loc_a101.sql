{{ config(materialized='table', schema='bronze') }}

SELECT
    cid,
    cntry
FROM {{ source('source_erp', 'erp_loc_a101') }}
