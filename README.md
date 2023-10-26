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
  
   *t_katerina_rutova_SQL_primary_final_table* - Tabulka obsahuje data týkající se mezd a cen potravin pro ČR sjednocené na porovnatelné  
   období tj. společné roky.

   Finální script, kterým je vytvořena primární tabulka, založená na výběru konkrétních hodnot za společné období (2006-2018)
   https://github.com/Surykatka1/Engeto-SQL-Projekt-1/blob/b9b0d36b0089afa6786f78a41bbfccd5c67c19d2/table_1_final.sql#L134-L149




