{{ config(materialized='table', schema='silver') }}

SELECT
    cid,
    cntry,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ get_ref_data('bronze_erp_loc_a101') }}
