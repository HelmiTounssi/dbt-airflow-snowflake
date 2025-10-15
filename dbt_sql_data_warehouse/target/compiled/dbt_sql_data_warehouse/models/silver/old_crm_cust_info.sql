

SELECT
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM 
    POC2.PUBLIC_bronze.bronze_crm_cust_info
