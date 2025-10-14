{{ config(materialized='table', schema='silver') }}

SELECT
    id,
    cat,
    subcat,
    maintenance,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ ref('bronze_erp_px_cat_g1v2') }}
