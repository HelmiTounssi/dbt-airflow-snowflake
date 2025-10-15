{{ config(materialized='table', schema='silver') }}

SELECT
    id,
    cat,
    subcat,
    maintenance,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ get_ref_data('bronze_erp_px_cat_g1v2') }}
