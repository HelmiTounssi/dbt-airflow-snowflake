

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    TO_DATE(CAST(sls_order_dt AS VARCHAR), 'YYYYMMDD') AS sls_order_dt,
    TO_DATE(CAST(sls_ship_dt AS VARCHAR), 'YYYYMMDD') AS sls_ship_dt,
    TO_DATE(CAST(sls_due_dt AS VARCHAR), 'YYYYMMDD') AS sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM 
    POC2.PUBLIC_bronze.bronze_crm_sales_details
