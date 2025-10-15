
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id
from POC2.PUBLIC_bronze.bronze_erp_px_cat_g1v2
where id is null



  
  
      
    ) dbt_internal_test