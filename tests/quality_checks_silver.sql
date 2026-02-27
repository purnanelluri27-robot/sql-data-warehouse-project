

script purpose:
It performs various quality checks for data consistency,accuracy,and standardization across silver schema. it includes checks for:
-null duplicate or primary keys
-unwanted spaces in string fields
-data standardization and consistency
-invalid data ranges and orders
-data consistency between related fields

  usage notes
  -run these checks for loading silver layer
  -investigate and resolve any discrepancies found during the checks.




--check for valid dates
SELECT 
NULLIF(sls_order_dt, 0)AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) !=8 



--check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data standardization & consistency
SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2



--Data standaradization & consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry


--check for nulls in primary key
--expectation: no result
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 OR prd_id IS NULL

  
--check for unwanted spaces
--expectation:no result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)


--check for NULL or negative numbers
--expectation:no result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL

  
--data standardization & consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

  
--check for invalid dates
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt



