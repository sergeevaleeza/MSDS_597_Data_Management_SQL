/***********************************
   forbes2000.csv
***********************************/


/*
 Q1
 How many rows, what is the max rank, and how many countries are there in this dataset?
 */

SELECT
    COUNT(1),
    MAX(rank),
    COUNT(DISTINCT country)
FROM forbes2000;

/*
 Q2
How many companies per category?
 */

SELECT
    category,
    COUNT(1) AS num_companies
FROM forbes2000
GROUP BY 1
ORDER BY 2 DESC;

/*
 Q3
 Which category has the highest average profit margin?  Divide profits by sales revenue.
 */

SELECT
    category,
    COUNT(1) AS num_companies,
    ROUND(SUM(profits) * 100.0 / SUM(sales), 1) AS profit_margin
FROM forbes2000
GROUP BY 1
ORDER BY 3 DESC;

/*
 Q4
Compare the % of banking companies out of all Forbes 2000 companies for
companies in the following countries:
 United States
 China
 Japan
 */

SELECT
    country,
    COUNT(CASE WHEN category = 'Banking' THEN category END) AS num_banking,
    COUNT(1) AS total,
    COUNT(CASE WHEN category = 'Banking' THEN category END) * 100.0 / COUNT(1) AS pct_banking
FROM forbes2000
WHERE
    country IN ('United States', 'China', 'Japan')
GROUP BY 1;


/***********************************
   global_land_temperatures.csv
***********************************/

/*
 Q1
 How many cities per country are there in this dataset?
 Output should show country, num_cities
 Order by most cities to least
 */
SELECT country,
       COUNT(DISTINCT city)
FROM global_land_temperatures
GROUP BY 1
ORDER BY 2 DESC;

/*
 Q2
 What was the hottest and coldest recorded temperature in each city?
*/

SELECT
    city,
    country,
    ROUND(MAX(average_temperature), 1) AS max_temp,
    ROUND(MIN(average_temperature), 1) AS min_temp
FROM global_land_temperatures
GROUP BY 1,2
ORDER BY 1;


/*
 Q3
 What are the top 10 countries with the hottest average temperature in the 20th century?  Top 10 lowest avg temperature?
 */

SELECT country,
       ROUND(AVG(average_temperature), 2) AS average_temperature
FROM global_land_temperatures
WHERE
      DATE_PART('year', DATE(dt)) BETWEEN 1900 AND 2000
GROUP BY 1
ORDER BY 2;

/*
 Q4
 Which city has the largest difference in temperature between the month of August and the month of February
 during the 20th century?  Rank by absolute value difference.
 */

SELECT city,
       country,
       AVG(CASE WHEN DATE_PART('month', DATE(dt)) = 8 THEN average_temperature END)      AS avg_aug_temp,
       AVG(CASE WHEN DATE_PART('month', DATE(dt)) = 2 THEN average_temperature END)      AS avg_feb_temp,
       AVG(CASE WHEN DATE_PART('month', DATE(dt)) = 8 THEN average_temperature END) -
       AVG(CASE WHEN DATE_PART('month', DATE(dt)) = 2 THEN average_temperature END)      AS delta_aug_feb,
       ABS(AVG(CASE WHEN DATE_PART('month', DATE(dt)) = 8 THEN average_temperature END) -
           AVG(CASE WHEN DATE_PART('month', DATE(dt)) = 2 THEN average_temperature END)) AS abs_delta_aug_feb
FROM global_land_temperatures
WHERE DATE_PART('year', DATE(dt)) BETWEEN 1900 AND 2000
GROUP BY 1,2
ORDER BY 6 DESC;

/*
Q5
By decade, show the average temperature for China and India
Round to 1 decimal place
Order by country then decade
*/

SELECT
    country,
    CONCAT(DATE_PART('decade', DATE(dt)), '0s') AS decade,
    ROUND(AVG(average_temperature), 1) AS avg_temperature
FROM global_land_temperatures
WHERE
    country IN ('China', 'India')
GROUP BY 1,2
ORDER BY 1,2;


