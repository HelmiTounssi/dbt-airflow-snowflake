{{ config(materialized='table', schema='bronze') }}

SELECT
    cid,
    cntry
FROM {{ get_source_data('source_erp', 'erp_loc_a101') }}
