
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select prd_id
from POC2.PUBLIC_silver.silver_crm_prd_info
where prd_id is null



  
  
      
    ) dbt_internal_test