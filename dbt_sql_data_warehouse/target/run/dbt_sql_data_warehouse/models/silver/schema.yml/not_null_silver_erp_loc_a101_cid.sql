
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select cid
from POC2.PUBLIC_silver.silver_erp_loc_a101
where cid is null



  
  
      
    ) dbt_internal_test