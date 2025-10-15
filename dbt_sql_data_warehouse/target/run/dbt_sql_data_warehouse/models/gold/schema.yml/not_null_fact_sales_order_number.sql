
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_number
from POC2.PUBLIC_gold.fact_sales
where order_number is null



  
  
      
    ) dbt_internal_test