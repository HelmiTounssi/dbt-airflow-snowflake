
    
    

select
    prd_id as unique_field,
    count(*) as n_records

from POC2.PUBLIC_bronze.bronze_crm_prd_info
where prd_id is not null
group by prd_id
having count(*) > 1


