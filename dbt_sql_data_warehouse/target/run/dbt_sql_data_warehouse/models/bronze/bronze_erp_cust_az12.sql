
  
    

create or replace transient table POC2.PUBLIC_bronze.bronze_erp_cust_az12
    
    
    
    as (

SELECT
    cid,
    bdate,
    gen
FROM POC2.PUBLIC_BRONZE.erp_cust_az12
    )
;


  