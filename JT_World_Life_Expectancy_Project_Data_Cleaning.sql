#World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

SELECT country, year, CONCAT(country, Year), COUNT(CONCAT(country, Year)) AS dup_count
FROM world_life_expectancy
GROUP BY country, year, CONCAT(country, Year)
HAVING dup_count > 1
;

SELECT *
FROM(
	SELECT row_id, 
	CONCAT(country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, Year) ORDER BY CONCAT(country, Year)) AS row_num
	FROM world_life_expectancy) AS row_table
WHERE row_num > 1
;

DELETE FROM world_life_expectancy
WHERE 
	row_id IN(
		SELECT row_id
FROM(
	SELECT row_id, 
	CONCAT(country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, Year) ORDER BY CONCAT(country, Year)) AS row_num
	FROM world_life_expectancy) AS row_table
WHERE row_num > 1
)
;

SELECT * 
FROM world_life_expectancy
WHERE status = ''
;


SELECT DISTINCT(status) 
FROM world_life_expectancy
WHERE status <> ''
;

SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE status = 'developing'
;

UPDATE world_life_expectancy
SET status = 'developing'
WHERE country IN (SELECT DISTINCT(country)
				FROM world_life_expectancy
					WHERE status = 'developing');


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'developing'
;

SELECT * 
FROM world_life_expectancy
WHERE status = ''
;

SELECT * 
FROM world_life_expectancy
WHERE country = 'united states of america'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.status = 'developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'developed'
;


SELECT * 
FROM world_life_expectancy
WHERE status = ''
;

SELECT * 
FROM world_life_expectancy
WHERE status IS null
;

SELECT * 
FROM world_life_expectancy
WHERE `life expectancy` = ''
OR `life expectancy` IS null
;

SELECT country, year, `life expectancy`
FROM world_life_expectancy
;

SELECT 
t1.country, t1.year, t1.`life expectancy`, 
t2.country, t2.year, t2.`life expectancy`,
t3.country, t3.year, t3.`life expectancy`,
ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1
WHERE t1.`life expectancy` = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.country = t3.country
    AND t1.year = t3.year + 1
SET t1.`life expectancy` = ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
WHERE t1.`life expectancy` = '' 
;

SELECT * 
FROM world_life_expectancy
;
