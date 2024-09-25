# US Household Income Project Data Cleaning 

SELECT * 
FROM us_income_project.us_household_income;

SELECT * 
FROM us_income_project.us_income_statistics;

ALTER TABLE us_income_project.us_income_statistics
RENAME COLUMN  `ï»¿id` TO `id`;


SELECT COUNT(id)
FROM us_income_project.us_household_income;

SELECT COUNT(id)
FROM us_income_project.us_income_statistics;

SELECT *
FROM us_household_income;

SELECT *
FROM us_income_statistics;


SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;


SELECT *
FROM(
SELECT 
row_id, 
id, 
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS dup_row
FROM us_household_income) AS duplicates
WHERE dup_row > 1
;


DELETE FROM us_household_income
WHERE row_id 
	IN (
	SELECT row_id
	FROM(
		SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS dup_row
		FROM us_household_income) AS duplicates
		WHERE dup_row > 1)
;



SELECT id, COUNT(id)
FROM us_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM us_household_income
;

SELECT state_name, COUNT(state_name)
FROM us_household_income
GROUP BY state_name
;

SELECT DISTINCT state_name
FROM us_household_income
;

UPDATE us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia'
;

SELECT DISTINCT COUNT(DISTINCT(state_ab))
FROM us_household_income
;

SELECT DISTINCT COUNT(DISTINCT(state_name))
FROM us_household_income
;

SELECT *
FROM us_household_income
WHERE state_code = ''
OR state_code IS NULL
;

SELECT *
FROM us_household_income
WHERE county = ''
OR county IS NULL
;

SELECT *
FROM us_household_income
WHERE city = ''
OR city IS NULL
;

SELECT *
FROM us_household_income
WHERE place = ''
OR place IS NULL
;

SELECT *
FROM us_household_income
WHERE county = 'Autauga County'
ORDER BY place
;

UPDATE us_household_income
SET place = 'Autaugaville'
WHERE place = ''
;

SELECT type, COUNT(type)
FROM us_household_income
GROUP BY type
ORDER BY type
;

UPDATE us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs'
;

SELECT *
FROM us_household_income
;

SELECT AWater
FROM us_household_income
WHERE awater = 0 OR awater IS NULL OR awater IS null
;

SELECT DISTINCT(AWater)
FROM us_household_income
WHERE awater = 0 OR awater IS NULL OR awater IS null
;

SELECT aland
FROM us_household_income
WHERE aland = 0 OR aland IS NULL OR aland IS null
;

SELECT DISTINCT(aland)
FROM us_household_income
WHERE aland = 0 OR aland IS NULL OR aland IS null
;

SELECT *
FROM us_income_statistics;

SELECT *
FROM us_income_statistics
WHERE mean = 0 OR median = 0 OR stdev = 0 OR sum_w = 0
OR mean = '' OR median = '' OR stdev = '' OR sum_w = ''
OR mean IS NULL OR median IS NULL OR stdev IS NULL OR sum_w IS NULL
;

SELECT count(*)
FROM (
	SELECT *
FROM us_income_statistics
WHERE mean = 0 OR median = 0 OR stdev = 0 OR sum_w = 0
OR mean = '' OR median = '' OR stdev = '' OR sum_w = ''
OR mean IS NULL OR median IS NULL OR stdev IS NULL OR sum_w IS NULL) AS missing_data_table

#I don't know enough about the data to know if I can safely remove these rows or not