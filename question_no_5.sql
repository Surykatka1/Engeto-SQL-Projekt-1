-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin?
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách
-- ve stejném nebo n ásledujícím roce výraznějším růstem?

-- Výpočet rozdílu GDP mezi současným rokem a rokem následujícím
CREATE OR REPLACE VIEW v_katerina_rutova_diff_GDP AS
SELECT `year`,
	round(GDP,1) AS GDP,
	`year`+1 AS next_year,
	round(lag (GDP,1) OVER (ORDER BY `year`), 0) AS GDP_from_next_year,
	round(((round(GDP,1)-lag (GDP,1) OVER (ORDER BY `year`))/lag (GDP,1) OVER (ORDER BY `year`))*100, 2) AS '%_diff_GDP'
FROM t_katerina_rutova_project_sql_secondary_final
WHERE country = 'Czech Republic';

SELECT *
FROM v_katerina_rutova_diff_gdp vkrdg;

SELECT common_year,
	industry,
	avg_payroll
FROM t_katerina_rutova_project_sql_primary_final tkrpspf
GROUP BY common_year, industry, avg_payroll

SELECT common_year,
	product_name,
	avg_price 
FROM t_katerina_rutova_project_sql_primary_final tkrpspf
GROUP BY common_year, product_name, avg_price 

-- Stanovení % rozdílu cen a mezd vůči nadcházejícímu roku
CREATE OR REPLACE VIEW v_katerina_rutova_pay_price_diff AS
SELECT `year`,
	avg_payroll_per_year,
	lag (avg_payroll_per_year,1) OVER (ORDER BY `year`) AS avg_payroll_from_prev_year,
	round(((avg_payroll_per_year-lag (avg_payroll_per_year,1) OVER (ORDER BY `year`))/
		lag (avg_payroll_per_year,1) OVER (ORDER BY `year`))*100, 2) AS '%_diff_payroll',
	avg_price_per_year,
	lag (avg_price_per_year,1) OVER (ORDER BY `year`) AS avg_price_from_prev_year,
	round(((avg_price_per_year-lag (avg_price_per_year,1) OVER (ORDER BY `year`))/
		lag (avg_price_per_year,1) OVER (ORDER BY `year`))*100, 2) AS '%_diff_price'
FROM (
		SELECT common_year AS `year`,
			round(avg(avg_payroll),0) AS avg_payroll_per_year,
			round(avg(avg_price),2) AS avg_price_per_year
		FROM t_katerina_rutova_project_sql_primary_final tkrpspf
		GROUP BY common_year) AS avg_payroll_per_year;


SELECT *
FROM v_katerina_rutova_pay_price_diff vkrppd; 

CREATE OR REPLACE TABLE t_katerina_rutova_gdp_price_payroll AS
SELECT vkrppd.`year` ,
	vkrppd.avg_payroll_per_year,
	vkrppd.`%_diff_payroll`,
	vkrppd.avg_price_per_year,
	vkrppd.`%_diff_price`,
	vkrdg.`%_diff_GDP` 
FROM v_katerina_rutova_pay_price_diff vkrppd
JOIN v_katerina_rutova_diff_gdp vkrdg 
	ON  vkrppd.`year` = vkrdg.`year`;


SELECT *
FROM t_katerina_rutova_gdp_price_payroll tkrgpp2;

-- Přidání podmínek
SELECT `year`,
	`%_diff_GDP`, 
	CASE 
		WHEN `%_diff_GDP` > 3 THEN 'GDP +'
		WHEN `%_diff_GDP` < 3 THEN 'GDP -'
		ELSE 'no_GDP_changing'
	END	AS GDP_changing,
	`%_diff_payroll`,
	CASE 
		WHEN `%_diff_payroll`> 3 THEN 'payroll +'
		WHEN `%_diff_payroll`< 3 THEN 'payroll -'
		ELSE 'no_payroll_changing'
	END AS payroll_changing,
	`%_diff_price`,
	CASE 
		WHEN `%_diff_price`> 3 THEN 'price +'
		WHEN `%_diff_price`< 3 THEN 'price-'
		ELSE 'no_price_changing'
	END AS price_changing
FROM t_katerina_rutova_gdp_price_payroll tkrgpp
