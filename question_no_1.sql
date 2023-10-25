-- 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

CREATE OR REPLACE VIEW v_katerina_rutova_lag_year AS
SELECT DISTINCT industry_branch_code,
	common_year,	
	industry,
	round(avg(avg_payroll),2) AS avg_payroll
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf 
GROUP BY common_year, industry_branch_code
ORDER BY industry_branch_code, common_year ASC;

SELECT *
FROM v_katerina_rutova_lag_year vkrly;


-- Stanovím rozdíl ve mzdách vůči předchozímu období 
CREATE OR REPLACE VIEW v_katerina_rutova_payroll_trend AS
SELECT common_year,
	avg_payroll,
	lag(avg_payroll) OVER (PARTITION BY industry_branch_code
	ORDER BY common_year) AS avg_payroll_previous_year,	
	round (avg_payroll - lag(avg_payroll) OVER (PARTITION BY industry_branch_code
	ORDER BY common_year),2) AS differences,
	industry_branch_code,
	industry		
FROM v_katerina_rutova_lag_year vkrly
ORDER BY industry_branch_code;

SELECT *
FROM v_katerina_rutova_payroll_trend vkrpt
ORDER BY common_year, industry_branch_code;


CREATE OR REPLACE VIEW v_katerina_rutova_pay_trend AS
 SELECT *,
	CASE
		WHEN differences > 0 THEN 'increasing'		
		WHEN differences < 0 THEN 'decreasing'
		ELSE 'no changes'
	END AS 'payroll_trend'
FROM v_katerina_rutova_payroll_trend vkrpt
ORDER BY industry_branch_code,common_year;

SELECT *
FROM v_katerina_rutova_pay_trend vkrpt 
ORDER BY common_year, industry_branch_code;

SELECT industry_branch_code,
	industry,
	payroll_trend
FROM v_katerina_rutova_pay_trend  
WHERE payroll_trend = 'decreasing'
GROUP BY industry_branch_code;
