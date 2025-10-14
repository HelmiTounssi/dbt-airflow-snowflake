
  
    

create or replace transient table POC2.PUBLIC_silver.old_crm_prd_info
    
    
    
    as (

SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM POC2.PUBLIC_bronze.bronze_crm_prd_info
    )
;


  