-- 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

SELECT *
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf;


-- Ověření průměrné ceny všeho zboží za rok,možno použíti pro ověření následujících let 
SELECT avg(avg_price)
FROM t_katerina_rutova_project_SQL_primary_final tkrpspf 
WHERE common_year  = 2006;
-- 45.515769

CREATE OR REPLACE VIEW v_katerina_rutova_q4_price AS
SELECT common_year,
	round (avg(avg_price),2) AS avg_price_per_year,
	lag (round (avg(avg_price),2)) OVER (ORDER BY common_year) AS price_previous_year,
	round (((round (avg(avg_price),2)-lag (round (avg(avg_price),2)) OVER (ORDER BY common_year))/lag (round (avg(avg_price),2)) 
		OVER (ORDER BY common_year))*100, 2) AS 'avg_price_diff_%'
FROM t_katerina_rutova_project_sql_primary_final tkrpspf
GROUP BY common_year;

SELECT *
FROM v_katerina_rutova_q4_price vkrqp;


CREATE OR REPLACE VIEW v_katerina_rutova_q4_payroll AS
SELECT common_year AS common_year_1,
	round (avg(avg_payroll),0) AS avg_payroll_per_year,
	lag (round (avg(avg_payroll),0)) OVER (ORDER BY common_year) AS payroll_previous_year,
	round (((round (avg(avg_payroll),2)-lag (round (avg(avg_payroll),0)) OVER (ORDER BY common_year))/lag (round (avg(avg_payroll),2)) 
		OVER (ORDER BY common_year))*100, 2) AS 'avg_payroll_diff_%'
FROM t_katerina_rutova_project_sql_primary_final tkrpspf
GROUP BY common_year;

SELECT *
FROM v_katerina_rutova_q4_payroll vkrqp;

-- Spojení tabulek s vypočítaným procentuálním rozdílem platů a mezd za dané roky

CREATE OR REPLACE VIEW v_katerina_rutova_q4_complete AS
SELECT *
FROM v_katerina_rutova_q4_price v1 
JOIN v_katerina_rutova_q4_payroll v2
	ON v1.common_year = v2.common_year_1; 

SELECT *
FROM v_katerina_rutova_q4_complete vkrqc;

SELECT common_year AS `year`,
	`avg_price_diff_%`,
	`avg_payroll_diff_%`, 
		CASE 
			WHEN `avg_price_diff_%`- `avg_payroll_diff_%` > 10 THEN '>10%'
			ELSE '<10%'
		END AS grow_trend
FROM v_katerina_rutova_q4_complete vkrqc;
