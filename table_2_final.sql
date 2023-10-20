-- Tvorba secondary table
 
 SELECT *
 FROM economies e;
-- Vybrat hodnoty v období 2006-2018

SELECT country,
	`year`,
	GDP,
	gini,
	population 
FROM economies e 
WHERE `year` BETWEEN 2006 AND 2018
ORDER BY `year`;

SELECT *
FROM countries c;
-- potřebuji vybrat Evropu 

SELECT *
FROM countries c 
WHERE continent = 'Europe'

-- spojení obou tabulek přes JOIN (spojí pouze společné hodnoty)
CREATE OR REPLACE TABLE t_katerina_rutova_project_SQL_secondary_final AS
SELECT e.country,
	e.`year`,
	e.GDP,
	e.gini,
	e.population 
FROM economies e 
JOIN countries c 
	ON e.country = c.country 
WHERE c.continent = 'Europe' 
	AND e.`year` BETWEEN 2006 AND 2018
ORDER BY e.country, e.`year`;

SELECT *
FROM t_katerina_rutova_SQL_secondary_final tkrssf;