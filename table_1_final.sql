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
	round(avg(value),2)
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


