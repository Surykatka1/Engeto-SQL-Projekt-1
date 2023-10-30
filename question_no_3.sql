-- 3.Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

SELECT *
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf ;

SELECT common_year,
	category_code,
	product_name,
	avg_price,
	CZK	
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf
GROUP BY common_year,category_code, product_name,avg_price;

SELECT common_year,
	category_code,
	product_name,
	avg_price,
	CZK
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf 

-- Vytvořím tabulky s rozdílem resp. procentuálním rozdílem v cenách následující rok vs. rok předchozí

CREATE OR REPLACE VIEW v_katerina_rutova_product_percent_diff AS
SELECT common_year,
	CZK,
	product_name,
	avg_price,
	unit,
	round(lag(avg_price) OVER (PARTITION BY product_name ORDER BY common_year), 2) AS previous_price,
	avg_price-round(lag(avg_price) OVER (PARTITION BY product_name ORDER BY common_year) AS difference,	
	round (((avg_price-round(lag(avg_price) OVER (PARTITION BY product_name ORDER BY common_year), 2))/round(lag(avg_price)
		OVER (PARTITION BY product_name ORDER BY common_year), 2))*100, 2) AS percentage_difference
FROM (
		SELECT common_year,
			product_name,
			avg_price,
			CZK,
			unit_value,
			unit
		FROM t_katerina_rutova_project_SQL_primary_final tkrpspf
		) AS difference
GROUP BY common_year,CZK,product_name,avg_price
ORDER BY product_name,common_year;
			

SELECT *
FROM v_katerina_rutova_product_percent_diff vkrppd;

-- Abych zjistila, která potravina zdražuje nejpomaleji ve sledovaném období tj.2006-2018,udělám průměr percentage_diff.
-- pro každou potravinu v období 2006-2018

SELECT product_name,
	round(avg(percentage_difference),2) AS avg_difference_per_period 
FROM v_katerina_rutova_product_percent_diff vkrppd
WHERE difference IS NOT NULL
GROUP BY product_name
ORDER BY avg_difference_per_period;
	
