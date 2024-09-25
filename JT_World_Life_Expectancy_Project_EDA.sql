#World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy
;

#Proving if every country had a net increase in life expectancy across the 15 years

SELECT 
country,
year,
`life expectancy`,
ROW_NUMBER () OVER (PARTITION BY country ORDER BY `life expectancy` DESC)
FROM(
	SELECT country, year, `Life expectancy`
	FROM world_life_expectancy
	WHERE year = '2022'
	OR year = '2007') AS min_max_year
;

#Adding the filtering functions to see if 2022 was always higher than 2007

SELECT 
country,
year,
`life expectancy`,
ROW_NUMBER () OVER (PARTITION BY country ORDER BY `life expectancy` DESC) AS score
FROM(
	SELECT country, year, `Life expectancy`
	FROM world_life_expectancy
	WHERE year = '2022'
	OR year = '2007') AS min_max_year
WHERE year = '2022'
AND 'score' = 2
;

#Now that I know that it is always a net positive across the 15 years, 
#I can start analyzing the increase in life expectancy

SELECT 
country, 
MIN(`life expectancy`), 
MAX(`life expectancy`),
ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY country
ORDER BY country
;

#Removing bad data from query
SELECT 
country, 
MIN(`life expectancy`), 
MAX(`life expectancy`),
ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`life expectancy`) <> 0
AND MAX(`life expectancy`) <> 0
ORDER BY country
;

#adding calculation column to easily visualize data
SELECT 
country, 
MIN(`life expectancy`), 
MAX(`life expectancy`),
ROUND(MAX(`life expectancy`) - MIN(`life expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`life expectancy`) <> 0
AND MAX(`life expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

#bringing basic query back to where it is easy to find
SELECT *
FROM world_life_expectancy
;

#looking at average life expectancy by year
SELECT year, ROUND(AVG(`life expectancy`),2)
FROM world_life_expectancy
GROUP BY year
ORDER BY year
;

#removing bad data from query
SELECT year, ROUND(AVG(`life expectancy`),2)
FROM world_life_expectancy
WHERE `life expectancy` <> 0
GROUP BY year
ORDER BY year
;


#bringing basic query back to where it is easy to find
SELECT *
FROM world_life_expectancy
;

#comparing average life expectancy to average GDP by country. Made sure to remove bad data
SELECT country, ROUND(AVG(`life expectancy`),1) AS life_expect, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY country
HAVING life_expect > 0
AND GDP > 0
ORDER BY GDP DESC
;


SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS HIGH_GDP_COUNT,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN `life expectancy` ELSE NULL END),1) AS High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_COUNT,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN `life expectancy` ELSE NULL END),1) AS Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

SELECT status, ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY status
;

SELECT 
status,
COUNT(DISTINCT country), 
ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY status
;



SELECT country, ROUND(AVG(`life expectancy`),1) AS life_expect, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY country
HAVING life_expect > 0
AND BMI > 0
ORDER BY BMI DESC
;

SELECT 
country, 
year, 
`life expectancy`, 
`adult mortality`,
SUM(`adult mortality`) OVER(PARTITION BY country ORDER BY year)
FROM world_life_expectancy
WHERE country LIKE '%united%'
;

