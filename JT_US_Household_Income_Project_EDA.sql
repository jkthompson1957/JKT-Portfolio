# US Household Income Project Exploratory Data Analysis

#from the data dictionary: Aland = Area of Land and AWater = Area of Water

SELECT * 
FROM us_income_project.us_household_income;

SELECT * 
FROM us_income_project.us_income_statistics;


SELECT * 
FROM us_household_income;

SELECT * 
FROM us_income_statistics;

SELECT state_name, county, city, aland, awater
FROM us_household_income
;

SELECT 
state_name, 
SUM(aland) AS total_land, 
SUM(awater) AS total_water
FROM us_household_income
GROUP BY state_name
ORDER BY 2 DESC
;

SELECT 
state_name, 
SUM(aland) AS total_land, 
SUM(awater) AS total_water
FROM us_household_income
GROUP BY state_name
ORDER BY 3 DESC
;

SELECT 
state_name, 
SUM(aland) AS total_land, 
SUM(awater) AS total_water,
(SUM(aland) + SUM(awater)) AS total_size
FROM us_household_income
GROUP BY state_name
ORDER BY 4 DESC
;

SELECT 
state_name, 
SUM(aland) AS total_land, 
SUM(awater) AS total_water
FROM us_household_income
GROUP BY state_name
ORDER BY 2 DESC
LIMIT 10
;

SELECT 
state_name, 
SUM(aland) AS total_land, 
SUM(awater) AS total_water
FROM us_household_income
GROUP BY state_name
ORDER BY 3 DESC
LIMIT 10
;

SELECT * 
FROM us_household_income;

SELECT * 
FROM us_income_statistics;


SELECT *
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
;

SELECT *
FROM us_income_statistics
WHERE mean = 0
;

SELECT *
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
;

SELECT ui.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY ui.state_name
ORDER BY 2
LIMIT 5
;

SELECT ui.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY ui.state_name
ORDER BY 2 DESC
LIMIT 5
;

SELECT ui.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY ui.state_name
ORDER BY 3
LIMIT 5
;

SELECT ui.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY ui.state_name
ORDER BY 3 DESC
LIMIT 5
;

SELECT Type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY Type
ORDER BY 2
;

SELECT Type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY Type
ORDER BY 3 DESC
;

SELECT Type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY Type
ORDER BY 4 DESC
;

SELECT *
FROM us_household_income
WHERE type = 'community';


SELECT Type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY Type
HAVING COUNT(type) > 100
ORDER BY 1 
;

SELECT *
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
;

SELECT ui.state_name, city, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM us_household_income ui
INNER JOIN us_income_statistics us
	ON ui.id = us.id
WHERE mean <> 0
GROUP BY ui.state_name, city
ORDER BY ROUND(AVG(mean),1) DESC
;