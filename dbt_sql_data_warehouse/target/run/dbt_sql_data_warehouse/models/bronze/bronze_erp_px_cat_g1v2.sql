
  
    

create or replace transient table POC2.PUBLIC_bronze.bronze_erp_px_cat_g1v2
    
    
    
    as (

SELECT
    id,
    cat,
    subcat,
    maintenance
FROM 
    POC2.PUBLIC_BRONZE.erp_px_cat_g1v2

    )
;


  