
  
    

create or replace transient table POC2.PUBLIC_bronze.bronze_erp_loc_a101
    
    
    
    as (

SELECT
    cid,
    cntry
FROM 
    POC2.PUBLIC_BRONZE.erp_loc_a101

    )
;


  