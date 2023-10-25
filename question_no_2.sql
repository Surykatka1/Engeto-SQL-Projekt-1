-- 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT *
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf;


-- Vypočítám, kolik chleba resp. mléka je možné si koupit za veškeré vydělané peníze ze všech oborů v letech 2006 resp. 2018.	 
SELECT common_year,
	category_code,
	product_name,
	concat(sum (avg_payroll), '  ', CZK) AS sum_payroll_per_year,
	concat(avg_price,'  ', CZK) AS price_product_per_year,
	concat(round(sum(avg_payroll)/avg_price,0), '  ',unit) AS afford_product
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf
WHERE product_name IN ('Chléb konzumní kmínový','Mléko polotučné pasterované') 
	  AND common_year IN ('2006','2018') 
GROUP BY common_year, product_name,avg_price 
ORDER BY common_year, product_name,category_code, product_name,avg_price,unit_value;
	 
-- Vypočítám, kolik chleba resp. mléka je možné si koupit za průměrný plat v daném roce.	 
 SELECT common_year,
	category_code,
	product_name,
	concat(round(avg(avg_payroll),0), '  ',CZK) AS avg_payroll_per_year, 
	concat(avg_price,'  ', CZK) AS price_product_per_year,
	concat(round(avg(avg_payroll)/avg_price,0), '  ',unit) AS afford_product
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf
WHERE product_name IN ('Chléb konzumní kmínový','Mléko polotučné pasterované') 
	  AND common_year IN ('2006','2018') 
GROUP BY common_year, product_name,avg_price 
ORDER BY common_year, product_name,category_code, product_name,avg_price,unit_value;
