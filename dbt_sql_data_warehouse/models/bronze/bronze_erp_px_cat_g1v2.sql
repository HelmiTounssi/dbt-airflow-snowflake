{{ config(materialized='table', schema='bronze') }}

SELECT
    id,
    cat,
    subcat,
    maintenance
FROM {{ get_source_data('source_erp', 'erp_px_cat_g1v2') }}
