

SELECT
    cid,
    bdate,
    gen,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM 
    POC2.PUBLIC_bronze.bronze_erp_cust_az12
