
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_key
from POC2.PUBLIC_gold.fact_sales
where customer_key is null



  
  
      
    ) dbt_internal_test