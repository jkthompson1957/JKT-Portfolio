# World Life Expectancy Data Cleaning Project

#This is a personal project using a real data set.
#The primary purpose of this project is to practice and demonstrate my skills with SQL
    
#I like to follow these three steps when I start working on a new dataset:
	# 1. Get to know the data
    # 2. Clean the data
    # 3. Validate the data
		#Each of these can be broken down into further steps which I will outline as they come up.

#Step 1 Get to know the data.
	# 1.1 always make a copy of the data.

CREATE TABLE world_life_expectancy_testing AS
SELECT * FROM world_life_expectancy
;

# 1.2 High level review of the data

SELECT *
FROM world_life_expectancy_testing
;

DESCRIBE world_life_expectancy_testing
;

#Noted column data types and a column with an extra space to fix later

# 1.3 Identify primary and foreign keys
	#There are no Keys since this is not a relational table
    
#Step 2 Clean the data

# 2.1 Fix column data types/names

ALTER TABLE world_life_expectancy_testing CHANGE `thinness  1-19 years` `thinness 1-19 years` double;
    
# 2.2 Identify and remove duplicates

SELECT row_id, COUNT(row_id)
FROM world_life_expectancy_testing
GROUP BY row_id
HAVING COUNT(row_id) > 1
;

#Use Concat to create a pseudo-primary key

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy_testing
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

#Three duplicates found.

SELECT 
row_id, 
CONCAT(country, year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) As Row_Num
FROM world_life_expectancy_testing
;

SELECT *
FROM(SELECT 
row_id, 
CONCAT(country, year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) As Row_Num
FROM world_life_expectancy_testing) AS finddup
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy_testing
WHERE row_id IN (
SELECT row_id
FROM(SELECT 
row_id, 
CONCAT(country, year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) As Row_Num
FROM world_life_expectancy_testing) AS finddup
WHERE Row_Num > 1)
;

#Double check it worked

SELECT *
FROM(SELECT 
row_id, 
CONCAT(country, year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) As Row_Num
FROM world_life_expectancy_testing) AS finddup
WHERE Row_Num > 1
;

SELECT *
FROM world_life_expectancy_testing
;

# 2.3 Identify and resolve Missing/Null values
    
SELECT *
FROM world_life_expectancy_testing
WHERE Country = ''
OR Year = ''
OR Status = ''
OR `Life expectancy` = ''
OR `Adult Mortality` = ''
OR `infant deaths` = ''
OR `percentage expenditure` = ''
OR Measles = ''
OR BMI = ''
OR `under-five deaths` = ''
OR Polio = ''
OR Diphtheria = ''
OR `HIV/AIDS` = ''
OR GDP = ''
OR `thinness 1-19 years` = ''
OR `thinness 5-9 years` = ''
OR Schooling = ''
OR Row_ID = ''
;

#Remove columns where zeros are plausible. 

SELECT Country, Year, Status, `Life expectancy`, BMI, GDP, Schooling, row_id 
FROM world_life_expectancy_testing
WHERE Country = ''
OR Year = ''
OR Status = ''
OR `Life expectancy` = ''
OR BMI = ''
OR GDP = ''
OR Schooling = ''
OR Row_ID = ''
;

#Many rows for GDP, BMI, and Schooling indicating bad data.
#Because I cannot reach out to a client for more information, I will note the bad data and move on.

SELECT Country, Year, Status, `Life expectancy`, row_id 
FROM world_life_expectancy_testing
WHERE Country = ''
OR Year = ''
OR Status = ''
OR `Life expectancy` = ''
OR Row_ID = ''
;

#Identified missing data in Status and Life Expectancy
#Fix Missing Data in Status column

SELECT *
FROM world_life_expectancy_testing
WHERE Status = ''
;

#Identify possible values in column

SELECT DISTINCT(Status)
FROM world_life_expectancy_testing
;

#Identify what value should be

SELECT DISTINCT(Country)
FROM world_life_expectancy_testing
WHERE Status = 'Developing'
;

#Populate missing data

UPDATE world_life_expectancy_testing
SET Status = 'Developing'
WHERE Country IN(
				SELECT DISTINCT(Country)
				FROM world_life_expectancy_testing
				WHERE Status = 'Developing')
;

#Error. Can't reference the same table I'm trying to update.

#Upon research, a Table Self Join is the solution

UPDATE world_life_expectancy_testing t1
JOIN world_life_expectancy_testing t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

#Double check it worked

SELECT *
FROM world_life_expectancy_testing
WHERE Status = ''
;

#Do the same for the other column value

UPDATE world_life_expectancy_testing t1
JOIN world_life_expectancy_testing t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

#Double check it worked

SELECT *
FROM world_life_expectancy_testing
WHERE Status = ''
;

SELECT *
FROM world_life_expectancy_testing
;

#Fix Missing Data in Life Expectancy column

SELECT *
FROM world_life_expectancy_testing
WHERE `Life Expectancy` = ''
;

#Only two rows missing data. Review other years for country.

SELECT *
FROM world_life_expectancy_testing
WHERE Country = 'Afghanistan'
;

SELECT *
FROM world_life_expectancy_testing
WHERE Country = 'Albania'
;

#Missing data can be interpolated. 

#Use a Table Self-Join and average of year before and after to populate missing data

SELECT t1.Country, t1.Year, t1.`Life Expectancy`, 
t2.Country, t2.year, t2.`Life Expectancy`,
t3.Country, t3.year, t3.`Life Expectancy`,
ROUND(((t2.`Life Expectancy` + t3.`Life Expectancy`)/2),1)
FROM world_life_expectancy_testing t1
JOIN world_life_expectancy_testing t2
	ON t1.country = t2.country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy_testing t3
	ON t1.country = t3.country
    AND t1.Year = t3.Year + 1 
WHERE T1.`Life Expectancy` = ''
;

UPDATE world_life_expectancy_testing t1
JOIN world_life_expectancy_testing t2
	ON t1.country = t2.country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy_testing t3
	ON t1.country = t3.country
    AND t1.Year = t3.Year + 1 
SET T1.`Life Expectancy` = ROUND(((t2.`Life Expectancy` + t3.`Life Expectancy`)/2),1)
WHERE T1.`Life Expectancy` = ''
;

#Double check it worked

SELECT *
FROM world_life_expectancy_testing
WHERE `Life Expectancy` = ''
;

#Fix Missing values in BMI column

SELECT Country, Year, BMI
FROM world_life_expectancy_testing
WHERE BMI = ''
;

SELECT Country, Year, BMI
FROM world_life_expectancy_testing
WHERE Country = 'Monaco'
;

#Noted that some countries have fewer rows than others
#Identify which countries and how many rows they have

SELECT Country, COUNT(*)
FROM world_life_expectancy_testing
GROUP BY Country
ORDER BY COUNT(*)ASC
;

#All countries have either 16 rows or 1 row. Remove countries with 1 row. 

SELECT Country 
FROM(
	SELECT Country, COUNT(*) AS row_count
	FROM world_life_expectancy_testing
	GROUP BY Country) AS t1
WHERE row_count = 1
;

DELETE FROM world_life_expectancy_testing
WHERE Country IN (
SELECT Country
FROM(
	SELECT Country, COUNT(*) AS row_count
	FROM world_life_expectancy_testing
	GROUP BY Country) AS t1
WHERE row_count = 1)
;

#Double check it worked. 

SELECT Country 
FROM(
	SELECT Country, COUNT(*) AS row_count
	FROM world_life_expectancy_testing
	GROUP BY Country) AS t1
WHERE row_count = 1
;

#Back to BMI

SELECT Country, Year, BMI
FROM world_life_expectancy_testing
WHERE BMI = ''
;

#Cannot extrapolate or interpolate. Note bad data in column and move on.
#Fix Missing values in Schooling column

SELECT Country, Year, Schooling
FROM world_life_expectancy_testing
WHERE Schooling = ''
;

#Cannot extrapolate or interpolate. Note bad data in column and move on.
#Fix Missing values in Schooling column

SELECT Country, Year, GDP
FROM world_life_expectancy_testing
WHERE GDP = ''
;

#Cannot extrapolate or interpolate. Note bad data in column and move on.

# 2.4 Fix inconsistent formats

SELECT *
FROM world_life_expectancy_testing
;

#Nothing to fix

#Step 3 Validate the Data

# 3.1 Remove data outside of project scope
#Nothing to remove

# 3.2 Data Ranges/Constraints

SELECT
MIN(`Life expectancy`) AS MIN_LE, MAX(`Life expectancy`) AS MAX_LE,
MIN(`Adult Mortality`) AS MIN_AM, MAX(`Adult Mortality`) AS MAX_AM,
MIN(`Infant Deaths`) AS MIN_ID, MAX(`Infant Deaths`) AS MAX_ID,
MIN(`Percentage Expenditure`) AS MIN_PE, MAX(`Percentage Expenditure`) AS MAX_PE,
MIN(Measles) AS MIN_Meas, MAX(Measles) AS MAX_Meas,
MIN(BMI) AS MIN_BMI, MAX(BMI) AS MAX_BMI,
MIN(`Under-five deaths`) AS MIN_UFD, MAX(`Under-five deaths`) AS MAX_UFD,
MIN(Polio) AS MIN_Pol, MAX(Polio) AS MAX_Pol,
MIN(Diphtheria) AS MIN_Diph, MAX(Diphtheria) AS MAX_Diph,
MIN(`HIV/AIDS`) AS MIN_HA, MAX(`HIV/AIDS`) AS MAX_HA,
MIN(GDP) AS MIN_GDP, MAX(GDP) AS MAX_GDP,
MIN(`thinness 1-19 years`) AS MIN_T19, MAX(`thinness 1-19 years`) AS MAX_T19,
MIN(`thinness 5-9 years`) AS MIN_T9, MAX(`thinness 5-9 years`) AS MAX_T9,
MIN(Schooling) AS MIN_School, MAX(Schooling) AS MAX_School
FROM world_life_expectancy_testing
WHERE BMI <> 0
AND GDP <> 0
AND Schooling <> 0
;

#Identified several columns with extreme outliers and nonsensical data.

#The time to clean each column individually exceeds the ROI of this personal project.
#In a real workplace environment, I would collaborate with client to discuss the scope and decide which 
#columns to focus cleaning efforts on and which to ignore. 

# 3.3 Review Outliers and Remove Nonsensical Data
#As stated above, the time to complete this step exceeds the ROI of this personal project.

#This concludes this data cleaning project.
