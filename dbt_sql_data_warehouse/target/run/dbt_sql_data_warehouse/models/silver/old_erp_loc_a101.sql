
  
    

create or replace transient table POC2.PUBLIC_silver.old_erp_loc_a101
    
    
    
    as (

SELECT
    cid,
    cntry,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM 
    POC2.PUBLIC_bronze.bronze_erp_loc_a101

    )
;


  