/***********************************
   forbes2000.csv
***********************************/


/*
 Q1
 How many rows, what is the max rank, and how many countries are there in this dataset?
 */
SELECT * FROM forbes2000;

SELECT COUNT(1),
       MAX(rank),
       COUNT(DISTINCT country)
FROM forbes2000;


/*
 Q2
How many companies per category?
 */

SELECT
       DISTINCT category,
        COUNT(category) AS num_companies
FROM forbes2000
GROUP BY category
ORDER BY num_companies DESC;

/*
 Q3
 Which category has the highest average profit margin?  Divide profits by sales revenue.
 */

SELECT category,
       SUM(profits)/SUM(sales) AS avg_profit
FROM forbes2000
GROUP BY category
ORDER BY avg_profit DESC;

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
       COUNT(CASE WHEN category = 'Banking' THEN category END) * 100 / COUNT(1) AS pct_banking
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
SELECT * FROM global_land_temperatures;

SELECT
       country,
       COUNT(DISTINCT city) as num_cities
FROM global_land_temperatures
GROUP BY 1
ORDER BY 2 DESC;

/*
 Q2
 What was the hottest and coldest recorded temperature in each city?
*/

SELECT
       city,
       MAX(average_temperature) AS max_temp,
       MIN(average_temperature) AS min_temp
FROM global_land_temperatures
GROUP BY city
ORDER BY max_temp DESC;

/*
 Q3
 What are the top 10 countries with the hottest average temperature in the 20th century?  Top 10 lowest avg temperature?
 */

SELECT country,
       ROUND(AVG(average_temperature), 2)
FROM global_land_temperatures
WHERE
DATE_PART('year', DATE(dt)) BETWEEN 1900 AND 2000
GROUP BY 1
ORDER BY 2 DESC;

/*
 Q4
 Which city has the largest difference in temperature between the month of August and the month of February
 during the 20th century?  Rank by absolute value difference.
 */



/*
Q5
By decade, show the average temperature for China and India
Round to 1 decimal place
Order by country then decade
*/




