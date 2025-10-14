
  
    

create or replace transient table POC2.PUBLIC_silver.old_erp_cust_az12
    
    
    
    as (

SELECT
    cid,
    bdate,
    gen,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM POC2.PUBLIC_bronze.bronze_erp_cust_az12
    )
;


  