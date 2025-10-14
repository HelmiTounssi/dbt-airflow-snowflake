
  create or replace   view POC2.PUBLIC_gold.fact_sales
  
  
  
  
  as (
    

SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM POC2.PUBLIC_silver.silver_crm_sales_details sd
LEFT JOIN POC2.PUBLIC_gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN POC2.PUBLIC_gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id
  );

