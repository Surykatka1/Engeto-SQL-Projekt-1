-- Práce s tab. czechia_price

SELECT cpc.name AS product_name,
	cp.category_code,
	cp.value AS price_in_CZK,
	cpc.price_value AS unit_value,
	cpc. price_unit AS unit,
	cp.date_from AS year_from,
	cp.date_to AS year_to,
	cp.region_code 
FROM czechia_price cp
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code;
	

SELECT category_code,
	date_from,
	round(avg(value),2) AS avg_value
FROM czechia_price cp 
WHERE category_code IN (111101, 2000001, 213201)
GROUP BY category_code,date_from; 

 
CREATE OR REPLACE VIEW v_katerina_rutova_year_product_price_v1 AS
SELECT cpc.name AS product_name,
	cp.category_code,
	cp.value AS price_in_CZK,
	cpc.price_value AS unit_value,
	cpc. price_unit AS unit,
	cp.date_from AS year_from,
	cp.date_to AS year_to,
	cp.region_code 
FROM czechia_price cp
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
WHERE region_code IS NOT NULL;
-- počet řádků 101 032 w/o NULL hodnoty

SELECT*
FROM czechia_price cp;
-- 108 249 řádků s NULL hodnotami

SELECT *
FROM czechia_price cp 
WHERE region_code IS NULL;
-- počet řádků 7 217

CREATE OR REPLACE VIEW v_katerina_rutova_year_product_avg_price_v1 AS
SELECT year(year_from) AS `year`,
	category_code,
	product_name,
	round (avg(price_in_CZK),2) AS avg_price,
	unit_value,
	unit
FROM v_katerina_rutova_year_product_price_v1 vkryppv  
GROUP BY category_code, year(year_from)
ORDER BY category_code, year(year_from);


-- Práce s Czechia_payroll, spojení tabulek

CREATE OR REPLACE VIEW v_katerina_rutova_payroll_joined_v1 AS
SELECT cp.value,
	cp.value_type_code,
	cp.unit_code,
	cpu.name AS CZK,
	cp.calculation_code,
	cpc.name AS recalculate,
	cp.industry_branch_code,
	cp.payroll_year,
	cp.payroll_quarter,
	cpib.name AS industry
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit cpu 
	ON cp.unit_code = cpu.code 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cp.calculation_code = cpc.code 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cp.industry_branch_code = cpib.code;

SELECT *
FROM v_katerina_rutova_payroll_joined_v1 vkrpjv;


-- Výběr konkrétních hodnot
CREATE OR REPLACE VIEW v_katerina_rutova_payroll_final_v1 AS
SELECT payroll_year,
	payroll_quarter,
	value AS payroll, 
	CZK,
	recalculate,
	industry_branch_code,
	industry 	
FROM v_katerina_rutova_payroll_joined_v1 vkrpjv
WHERE value_type_code = 5958 AND 
	unit_code = 200 AND
	calculation_code = 200
ORDER BY payroll_year,industry;

SELECT *
FROM v_katerina_rutova_payroll_final_v1 vkrpfv 

-- Průměrný plat za celý rok
CREATE OR REPLACE VIEW v_katerina_rutova_year_industry_avg_payroll_v1 AS
SELECT payroll_year,
	industry_branch_code,
	industry,
	round(avg(payroll),0) AS avg_payroll,
	CZK
FROM v_katerina_rutova_payroll_final_v1 vkrpfv
WHERE industry_branch_code IS NOT NULL
GROUP BY payroll_year, industry_branch_code 
ORDER BY payroll_year, industry_branch_code;

SELECT *
FROM v_katerina_rutova_year_industry_avg_payroll_v1 vkryiapv;

SELECT 
	min(payroll_year),
	max(payroll_year)
FROM v_katerina_rutova_year_industry_avg_payroll_v1 vpay; 
-- období 2000-2021

SELECT 
	min(`year`),
	max(`year`)
FROM v_katerina_rutova_year_product_avg_price_v1 vpri; 
-- období 2006-2018

-- Spojení tabulek ---> primary_final_table

CREATE OR REPLACE TABLE t_katerina_rutova_project_SQL_primary_final AS
SELECT vpay.payroll_year AS common_year,
	vpay.industry_branch_code,
	vpay.industry,
	vpay.avg_payroll,
	vpay.CZK,
	vpri.category_code,
	vpri.product_name,
	vpri.avg_price,
	vpri.unit_value,
	vpri.unit	
FROM v_katerina_rutova_year_industry_avg_payroll_v1 vpay
LEFT JOIN v_katerina_rutova_year_product_avg_price_v1 vpri
	ON vpay.payroll_year = vpri.`year`
WHERE `year`IS NOT NULL;

SELECT *
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf;

