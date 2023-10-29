# Engeto-SQL-Projekt-1
## **Zpracování datových podkladů o mzdách a cenách potravin pomocí dotazovacího jazyka SQL**
### **Abstrakt**
Cílem projektu je vypracovat datové podklady, pomocí kterých bude možné porovnat dostupnost potravin s údaji o průměrných mzdách za sledovaná období.
Výstupem budou dvě ucelené tabulky poskytující potřebné informace.
Veškerá data k vytvoření tabulek a zodpovězení výzkumných otázek jsou k dispozici v následujících tabulkách (zdroj: Portál otevřených dat ČR):

  *czechia_payroll* – Informace o mzdách v různých odvětvích za několikaleté období
  
  *czechia_payroll_calculation* – Číselník kalkulací v tabulce mezd
  
  *czechia_payroll_industry_branch* – Číselník odvětví v tabulce mezd
  
  *czechia_payroll_unit* – Číselník jednotek hodnot v tabulce mezd
  
  *czechia_payroll_value_type* – Číselník typů hodnot v tabulce mezd
  
  *czechia_price* – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR
  
  *czechia_price_category* – Číselník kategorií potravin, které se vyskytují v našem přehled
  
  *czechia_region* – Číselník krajů České republiky dle normy CZ-NUTS 2
  
  *czechia_district* – Číselník okresů České republiky dle normy LAU
  
  *countries* - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace
  
  *economies* - HDP, GINI, daňová zátěž, atd. pro daný stát a rok


  ### **Kompletace tabulek SQL_primary_final_table a SQL_secondary_final_table**
  Podrobnější popis jednotlivých scriptů je uveden v sekci comments on commit, který vždy náleží k dané části projektu.
  V rámci projektu byly připraveny požadované tabulky (primary/secondary). Primary tabulka byla použita k vypracování otázek č.1-4,    
  secondary tabulka posloužila k zodpovězení otázky č.5.
  
   ***t_katerina_rutova_SQL_primary_final_table*** - Tabulka obsahuje data týkající se mezd a cen potravin pro ČR sjednocené na porovnatelné období tj. společné roky.

   Finální script, kterým je vytvořena primární tabulka, založená na výběru konkrétních hodnot za společné období (2006-2018):
   https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/b9b0d36b0089afa6786f78a41bbfccd5c67c19d2/table_1_final.sql#L134-L149

   ***t_katerina_rutova_SQL_secondary_final_table*** - Tato tabulka vznikla spojením tabulky countries a economies. Data byla opět filtrována    pro společná období a Evropu. 

   Finální script, kterým je vytvořena sekundární tabulka:
   https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/cbb07fd9b885d7048de719550dd05e1f6223b650/table_2_final.sql#L25-L37

   ### **Výzkumné otázky**
   ***otázka č.1:*** Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
   
   ***odpověď:*** Klesající trend mezd byl zaznamenán v letech 2009, 2010, 2011, 2013, 2014, 2015 a 2016, přičemž nejvíce klesaly mzdy v roce 2013. V tomto roce se pokles projevil v 11 odvětvích z celkového počtu 19. Naopak největší meziroční růst mezd proběhl v odvětví: Výroba a rozvody elektřiny a plynu, tepla a klimatiz. vzduchu v roce 2008 o 4,3%.
    
   https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/3cfb87477f5ce33eed6bf4c4c8a915c965b817d8/question_no_1.sql#L34-L42
   
   https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/3cfb87477f5ce33eed6bf4c4c8a915c965b817d8/question_no_1.sql#L44-L49
   
   
 ***otázka č.2:*** Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

 ***odpověď:*** Z výsledků vyplývá následující: V průběhu lety (2006-2018) vzrostla průměrná cena obou komodit a zároveň došlo k navýšení průměrných platů.
 V roce 2006 bylo možné za průměrný roční plat (21 165 Kč) koupit 1313 kg chleba konzumního kmínového nebo 1466 l mléka.
 V roce 2018 byl průměrný roční plat 33 092 Kč a množství chleba a mléka, který si lidé mohli pořídit, stouplo na 1365 kg a 1670 l.

 https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/8ac53ca8b25d403121cb36c35c7c5c9b606989c2/question_no_2.sql#L21-L31

 ***otázka č.3:*** Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

 ***odpověď:*** Nejnižší percentuální meziroční nárůst byl zaznamenám u potraviny Banány žluté (0,81%) a Vepřová pečené s kostí (0,99%). <br>
 U položky Rajská jablka červená kulatá a Cukr krystalový došlo dokonce ke snížení ceny o 0,74% resp.1,92%.

 https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/2054bc6bdd582a3e970ac345340c3435612799c0/question_no_3.sql#L23-L43

 https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/2054bc6bdd582a3e970ac345340c3435612799c0/question_no_3.sql#L52-L57

 ***otázka č.4:*** Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

 ***odpověď:*** Průměrný růst cen u všech potravin nebyl nikdy o 10% vyšší než průměrný růst mezd.

 https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/b46245bd8e52a312e9b039d42132ca63764f9d98/question_no_4.sql#L43-L47

 https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/b46245bd8e52a312e9b039d42132ca63764f9d98/question_no_4.sql#L49-L59

 ***otázka č.5:*** Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?

 ***odpověď:*** 


