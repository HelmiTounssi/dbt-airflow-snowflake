

WITH ranked_crm_cust_info AS (
    SELECT
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC, cst_id) as rn
    FROM 
    POC2.PUBLIC_BRONZE.crm_cust_info

    WHERE cst_id IS NOT NULL
)
SELECT
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
FROM ranked_crm_cust_info
WHERE rn = 1