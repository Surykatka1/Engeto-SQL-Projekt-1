-- 5. Má výška HDP vliv na změny ve mzdách a cenách potravin?
-- Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách
-- ve stejném nebo n ásledujícím roce výraznějším růstem?

SELECT *
FROM t_katerina_rutova_project_sql_secondary_final tkrpssf;

SELECT *
FROM t_katerina_rutova_project_sql_primary_final tkrpspf;

-- Zajímají mě údaje pouze pro ČR a zároveň si zjistím % rozdíl GDP oproti roků předchozím
SELECT `year`,
	GDP,
	lag(GDP) OVER (ORDER BY `year`) AS previous_GDP,
	round (((GDP-lag(GDP) OVER (ORDER BY `year`))/lag(GDP) OVER (ORDER BY `year`))*100, 2) AS 'GDP_diff_%'
FROM t_katerina_rutova_project_sql_secondary_final tkrpssf 
WHERE country = 'Czech Republic';	
-- vzhledem k výsledkům, zvolím si 3% jako výraznější změnu v HDP


-- Vytvořím view pro categorie product a vypočítám % rozdíl v avg_price a zároveň posunu rok
CREATE OR REPLACE VIEW v_katerina_rutova_q5_price AS
SELECT tkrp1.category_code,
	tkrp1.common_year AS `year`,
	tkrp1.avg_price,
	tkrp2.common_year AS 'prev_year',
	tkrp2.avg_price AS 'prev_avg_price',
	round (((tkrp1.avg_price - tkrp2.avg_price)*100/tkrp2.avg_price),2) AS '%_diff_price'
FROM t_katerina_rutova_project_sql_primary_final tkrp1
	LEFT JOIN t_katerina_rutova_project_sql_primary_final tkrp2
	ON tkrp1.category_code = tkrp2.category_code 
	AND tkrp1.common_year = tkrp2.common_year + 1
GROUP BY tkrp1.category_code,
	tkrp1.avg_price,
	tkrp2.common_year,
	tkrp2.avg_price 
ORDER BY tkrp1.category_code,
	tkrp1.common_year;


-- Vytvořím view pro categorie industry branch a vypočítám % rozdíl v avg_payroll a zároveň posunu rok
CREATE OR REPLACE VIEW v_katerina_rutova_q5_payroll AS
SELECT tkrp1.industry_branch_code,
	tkrp1.common_year AS `year`,
	tkrp2.common_year AS 'prev_year',
	tkrp1.avg_payroll,
	tkrp2.avg_payroll AS 'prev_avg_payroll',
	round (((tkrp1.avg_payroll - tkrp2.avg_payroll)*100/tkrp2.avg_payroll), 2) AS '%_diff_payroll'
FROM t_katerina_rutova_project_sql_primary_final tkrp1
LEFT JOIN t_katerina_rutova_project_sql_primary_final tkrp2
	ON tkrp1.industry_branch_code = tkrp2.industry_branch_code 
	AND tkrp1.common_year = tkrp2.common_year + 1
GROUP BY tkrp1.industry_branch_code,
	tkrp1.avg_payroll,
	tkrp2.common_year,
	tkrp2.avg_payroll
ORDER BY tkrp1.industry_branch_code,
	tkrp1.common_year;

--  Vytvořím view pro GDP a vypočítám % rozdíl v GDP a zároveň posunu rok
CREATE OR REPLACE VIEW v_katerina_rutova_q5_GDP AS	
SELECT round(tkrs1.GDP, 0) AS 'GDP', 
	tkrs1.`year`,
	tkrs2.`year` AS 'prev_year',
	round(tkrs2.GDP, 0) AS 'prev_GDP',
	round((round(tkrs1.GDP, 0)-round(tkrs2.GDP, 0))*100/round(tkrs2.GDP, 0), 2) AS '%_diff_GDP'	
FROM t_katerina_rutova_project_sql_secondary_final tkrs1
LEFT JOIN t_katerina_rutova_project_sql_secondary_final tkrs2
	ON tkrs1.country = tkrs2.country 
	AND tkrs1.`year` = tkrs2.`year` + 1
WHERE tkrs1.country = 'Czech Republic'
	
-- Spojení všech view dohromady přes společný rok
SELECT price.category_code ,
	price.`year`,
	price.prev_year,
	price.`%_diff_price`,
	pay.`%_diff_payroll`,
	gdp.`%_diff_GDP` 
FROM v_katerina_rutova_q5_price price
LEFT JOIN v_katerina_rutova_q5_payroll pay
	ON price.`year` = pay.`year`
LEFT JOIN v_katerina_rutova_q5_gdp gdp
	ON price.`year` = gdp.`year`
GROUP BY price.`year`;

-- Přidání podmínek
SELECT price.`year`,
	price.prev_year,
	price.`%_diff_price`,
	CASE 
		WHEN price.`%_diff_price`> 3 THEN 'price +'
		WHEN price.`%_diff_price`< 3 THEN 'price -'
		ELSE 'no_price_changing'
	END	AS price_changing,
	pay.`%_diff_payroll`,
	CASE 
		WHEN pay.`%_diff_payroll`> 3 THEN 'payroll +'
		WHEN pay.`%_diff_payroll`< 3 THEN 'payroll -'
		ELSE 'no_payroll_changing'
	END AS payroll_changing,
	gdp.`%_diff_GDP`,
	CASE 
		WHEN gdp.`%_diff_GDP`> 3 THEN 'GDP +'
		WHEN gdp.`%_diff_GDP`< 3 THEN 'GDP-'
		ELSE 'no_GDP_changing'
	END AS GDP_changing
FROM v_katerina_rutova_q5_price price
LEFT JOIN v_katerina_rutova_q5_payroll pay
	ON price.`year` = pay.`year`
LEFT JOIN v_katerina_rutova_q5_gdp gdp
	ON price.`year` = gdp.`year`
GROUP BY price.`year`;
