
  
    

create or replace transient table POC2.PUBLIC_silver.silver_erp_px_cat_g1v2
    
    
    
    as (

SELECT
    id,
    cat,
    subcat,
    maintenance,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM 
    POC2.PUBLIC_bronze.bronze_erp_px_cat_g1v2

    )
;


  