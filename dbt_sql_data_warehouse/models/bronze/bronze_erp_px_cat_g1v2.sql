{{ config(materialized='table', schema='bronze') }}

SELECT
    id,
    cat,
    subcat,
    maintenance
FROM {{ source('source_erp', 'erp_px_cat_g1v2') }}
