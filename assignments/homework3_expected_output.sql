SELECT * FROM movies;
/*
Question 1
Of movies with at least 10,000 votes:
Give the distribution of movies in the following categories
>= 9.0  Great
>= 8.0 and < 9.0  Good
>= 7.0 and < 8.0  Decent
>= 6.0 and < 7.0  Questionable
< 6.0  Bad
Order by the number of movies, highest to lowest.
 */

SELECT
       CASE WHEN avg_vote >= 9 THEN 'Great'
           WHEN avg_vote BETWEEN 8.0 AND 9.0 THEN 'Good'
           WHEN avg_vote BETWEEN 7.0 AND 8.0 THEN 'Decent'
           WHEN avg_vote BETWEEN 6.0 AND 7.0 THEN 'Questionable'
           WHEN avg_vote < 6.0 THEN 'Bad'
           END AS rating_category,
       COUNT(movies) AS num_movies
FROM movies
WHERE votes >= 10000
GROUP BY 1
ORDER BY 2 DESC;

+---------------+----------+
|rating_category|num_movies|
+---------------+----------+
|Questionable   |3130      |
|Decent         |2911      |
|Bad            |1813      |
|Good           |632       |
|Great          |10        |
+---------------+----------+


/*
Question 2
Show the top 5 Production Companies by total US gross income
Consider only movies with a USD ($) gross income by filtering
to only the movies with a $ symbol in usa_gross_income
 */

SELECT production_company,
       SUM(CAST(
        (TRIM('$ ' FROM usa_gross_income))
        AS NUMERIC
        )) AS total_usa_gross_income
FROM movies
WHERE usa_gross_income LIKE '%$%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

+---------------------+----------------------+
|production_company   |total_usa_gross_income|
+---------------------+----------------------+
|Warner Bros.         |26179586906           |
|Universal Pictures   |24650120131           |
|Paramount Pictures   |21876326816           |
|Columbia Pictures    |21515883903           |
|Twentieth Century Fox|17636966731           |
+---------------------+----------------------+



/*
Question 3
Of movies with at least 10,000 votes:
For every year from 2001 - 2010
Show the following metrics per year
- Number of movies
- Average rating per movie (rounded to 1 decimal place)
- Highest rating
- Lowest rating
*/

SELECT year,
       COUNT(original_title) AS num_movies,
       ROUND(AVG(avg_vote), 1) AS avg_rating,
       ROUND(MAX(avg_vote), 1) AS max_rating,
       ROUND(MIN(avg_vote), 1) AS min_rating
FROM movies
WHERE votes > 10000 AND
      year BETWEEN 2001 AND 2010
GROUP BY 1
ORDER BY 1;


+----+----------+----------+----------+----------+
|year|num_movies|avg_rating|max_rating|min_rating|
+----+----------+----------+----------+----------+
|2001|202       |6.5       |8.8       |2.2       |
|2002|213       |6.5       |8.7       |3.1       |
|2003|207       |6.5       |8.9       |2         |
|2004|239       |6.6       |8.5       |1.8       |
|2005|246       |6.5       |8.3       |2.2       |
|2006|290       |6.5       |8.5       |1.6       |
|2007|297       |6.5       |8.4       |2.2       |
|2008|295       |6.4       |9         |1.9       |
|2009|298       |6.4       |8.4       |2.5       |
|2010|280       |6.5       |8.8       |1.8       |
+----+----------+----------+----------+----------+


/*
 Question 4
 How many movies in 2008 had an avg_vote above the average avg_vote for 2008?
 Only consider movies with at least 10,000 votes.
 Name the count "num_2008_movies_above_average"
 */

SELECT COUNT(original_title) AS num_2008_movies_above_average
FROM movies
WHERE votes > 10000 AND
      year = 2008 AND
      avg_vote > (SELECT AVG(avg_vote)
                    FROM movies
                    WHERE votes > 10000 AND
                          year = 2008 );

+-----------------------------+
|num_2008_movies_above_average|
+-----------------------------+
|161                          |
+-----------------------------+


/*
Question 5
For movies released since 1990 with at least 10,000 votes, a budget with "$" in it, and a date_published with format (yyyy-mm-dd)
Show the following, by season,
- Number of movies (num_movies)
- Average budget, rounded to 2 decimals (avg_budget)
- Average USA gross income, rounded to 2 decimals (avg_usa_gross_income)
- Average Worldwide income, rounded to 2 decimals (avg_worldwide_gross_income) *Note I'm correcting the worlwide spelling here when renaming the column

Seasons are defined as
December, January, February = Winter
March, April, May = Spring
June, July, August = Summer
September, October, November = Fall

Order your output by average worldwide gross income, highest to lowest
 */

SELECT (CASE WHEN DATE_PART('month', DATE(date)) IN ('12', '1', '2') THEN 'Winter'
             WHEN DATE_PART('month', DATE(date)) IN ('3', '4', '5') THEN 'Spring'
             WHEN DATE_PART('month', DATE(date)) IN ('6', '7', '8') THEN 'Summer'
             WHEN DATE_PART('month', DATE(date)) IN ('9', '10', '11') THEN 'Fall'
          END) AS season,
       COUNT(1) AS num_movies,
       ROUND(AVG(CAST(
               (TRIM('$ ' FROM budget)) AS NUMERIC)), 2) AS avg_budget,
       ROUND(AVG(CAST(
           (TRIM('$ ' FROM usa_gross_income)) AS NUMERIC)), 2) AS avg_usa_gross_income,
       ROUND(AVG(CAST(
           (TRIM('$ ' FROM worlwide_gross_income)) AS NUMERIC)), 2) AS avg_worldwide_gross_income
FROM (
    SELECT
           FORMAT (date_published, 'yyyy-mm-dd') AS date,
           budget,
           usa_gross_income,
           worlwide_gross_income
        FROM movies
        WHERE votes > 10000 AND
              budget LIKE '%$%' AND
              year >= 1990 AND
              LENGTH(date_published) >= 8
        ) date_data
WHERE LENGTH(date) >= 8
GROUP BY 1
ORDER BY 5 DESC;


+------+----------+-----------+--------------------+--------------------------+
|season|num_movies|avg_budget |avg_usa_gross_income|avg_worldwide_gross_income|
+------+----------+-----------+--------------------+--------------------------+
|Winter|1122      |41869306.2 |59995000.33         |132276567.73              |
|Fall  |1302      |40510246.71|54593651.68         |119852561.82              |
|Spring|1214      |40571005.07|51171389.27         |109108345.7               |
|Summer|1033      |36412656.34|48518928.88         |99994343.83               |
+------+----------+-----------+--------------------+--------------------------+



/*
Question 6
Show the number of movies (min. 10,000 votes), average rating (avg of avg_vote) and max rating (max of avg_vote)
by production companies, of production companies that have a movie with
a max rating >= 9.  Order by max rating, highest to lowest, then by alphabetical order.
*/

SELECT production_company,
*/       num_movies,
       avg_rating,
       max_rating*/
FROM (SELECT production_company,
             COUNT(original_title) as num_movies,
             ROUND(AVG(avg_vote), 1) AS avg_rating,
             ROUND(MAX(avg_vote), 1) AS max_rating
    FROM movies
    WHERE votes > 10000
    GROUP BY 1
    ORDER BY 4 DESC, 1) foo
WHERE max_rating BETWEEN 9 AND (SELECT MAX(avg_vote)
                              FROM movies
                              WHERE votes > 10000)
GROUP BY 1
ORDER BY 4 DESC;

SELECT production_company,
       num_movies,
       avg_rating,
       max_rating
FROM (SELECT production_company,
             COUNT(1) AS num_movies,
             ROUND(AVG(avg_vote), 1) AS avg_rating,
             ROUND(MAX(avg_vote), 1) AS max_rating
      FROM movies
      WHERE votes > 10000
    GROUP BY 1) movies
WHERE max_rating >= 9
GROUP BY production_company
ORDER BY 4 DESC;

SELECT production_company,
             COUNT(original_title) as num_movies,
             ROUND(AVG(avg_vote), 1) AS avg_rating,
             ROUND(MAX(avg_vote), 1) AS max_rating
FROM movies
WHERE votes > 10000
GROUP BY 1;

SELECT production_company,
             COUNT(original_title) as num_movies,
             ROUND(AVG(avg_vote), 1) AS avg_rating,
             ROUND(MAX(avg_vote), 1) AS max_rating
    FROM movies
    WHERE votes > 10000
    GROUP BY 1
    ORDER BY 4 DESC, 1
LIMIT 7;
+-------------------------+----------+----------+----------+
|production_company       |num_movies|avg_rating|max_rating|
+-------------------------+----------+----------+----------+
|Arzu Film                |9         |8.9       |9.3       |
|Castle Rock Entertainment|44        |6.5       |9.3       |
|Paramount Pictures       |317       |6.6       |9.2       |
|Content Matters          |1         |9.1       |9.1       |
|Centar Film              |2         |9         |9         |
|Shree Raajalakshmi Films |1         |9         |9         |
|Warner Bros.             |363       |6.7       |9         |
+-------------------------+----------+----------+----------+


/*
 Question 7
 Show the % of actors that were California born by birth decade, for actors born since 1900.
 Columns should be named
 - birth_decade  (formatted as 1900s, 1910s, etc.)
 - count_california_born
 - count_total
 - pct_california_born (rounded to 1 decimal place)

 Order by birth_decade, earliest to latest.

 Note: date_of_birth is an inconsistently formatted column, so you will need to filter to just those that match the
 xxxx-xx-xx format to extract the birth_year.
 */

SELECT * FROM actors;

SELECT CONCAT(DATE_PART('decade', DATE(date)), '0s') AS birth_decade,
       COUNT(CASE WHEN LOWER(place_of_birth) LIKE '%california%' THEN place_of_birth ELSE NULL END) AS count_california_born,
       COUNT(date) AS count_total,
       ROUND(COUNT(CASE WHEN LOWER(place_of_birth) LIKE '%california%' THEN place_of_birth ELSE NULL END) * 100.0 / COUNT(1), 1) AS pct_california_born
FROM (
    SELECT
       FORMAT (date_of_birth, 'yyyy-mm-dd') AS date,
       place_of_birth
           FROM actors
           WHERE LENGTH(date_of_birth) = 10 AND
                 date_of_birth LIKE '%%%%-%%-%%'
        ) date_and_place_birth
WHERE DATE_PART('year', DATE(date)) >= 1900
GROUP BY 1
ORDER BY 1 ASC;

+------------+---------------------+-----------+-------------------+
|birth_decade|count_california_born|count_total|pct_california_born|
+------------+---------------------+-----------+-------------------+
|1900s       |172                  |5186       |3.3                |
|1910s       |241                  |5790       |4.2                |
|1920s       |340                  |8565       |4                  |
|1930s       |423                  |9181       |4.6                |
|1940s       |571                  |10666      |5.4                |
|1950s       |705                  |10421      |6.8                |
|1960s       |931                  |13150      |7.1                |
|1970s       |969                  |15170      |6.4                |
|1980s       |908                  |10751      |8.4                |
|1990s       |280                  |3101       |9                  |
|2000s       |28                   |366        |7.7                |
|2010s       |1                    |5          |20                 |
+------------+---------------------+-----------+-------------------+


/*
 Question 8
 What are top 10 first names in the actors table?  Show first_name and num_actors.

 Hint:  Use SPLIT_PART to parse out the first name.  Split on space and consider anything before the first space
 in the name to be the first name.
 */

SELECT SPLIT_PART(name, ' ', 1) AS first_name,
       COUNT(1) as num_actors
FROM actors
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

+----------+----------+
|first_name|num_actors|
+----------+----------+
|David     |3220      |
|John      |3203      |
|Michael   |3112      |
|Robert    |2155      |
|Paul      |1683      |
|James     |1592      |
|Peter     |1588      |
|Richard   |1464      |
|Mark      |1365      |
|Daniel    |1188      |
+----------+----------+


/*
 Question 9
How many different production companies are there in the movies table?
 Name the column num_production_companies.
 */

SELECT COUNT(DISTINCT production_company) AS num_production_companies
FROM movies;

+------------------------+
|num_production_companies|
+------------------------+
|32035                   |
+------------------------+


/*
Question 10
Show the number of movies by the day of week of date_published, highest to lowest.
Filter to the rows where date_published matches the 'xxxx-xx-xx' format

Hint: Use 'dow' as the extract field in DATE_PART.  'dow' stands for day of week.
It returns 0-6 where 0 = Sunday and 6 = Saturday
 */

SELECT   (CASE
         WHEN day_of_week = 1 THEN 'Monday'
         WHEN day_of_week = 2 THEN 'Tuesday'
         WHEN day_of_week = 3 THEN 'Wednesday'
         WHEN day_of_week = 4 THEN 'Thursday'
         WHEN day_of_week = 5 THEN 'Friday'
         WHEN day_of_week = 6 THEN 'Saturday'
         WHEN day_of_week = 7 THEN 'Sunday'
     ELSE 'other'
   END) AS day_of_week,
       COUNT(1) AS num_movies
FROM (
    SELECT DATE_PART('isodow', DATE(date_published)) AS day_of_week
    FROM movies
    WHERE LENGTH(date_published) = 10 AND
                 date_published LIKE '%%%%-%%-%%'
         ) week_days
GROUP BY 1
ORDER BY 2 DESC;
+-----------+----------+
|day_of_week|num_movies|
+-----------+----------+
|Friday     |31343     |
|Thursday   |17356     |
|Wednesday  |11202     |
|Saturday   |7767      |
|Tuesday    |5645      |
|Monday     |4684      |
|Sunday     |3236      |
+-----------+----------+



SELECT original_title
FORM movies;