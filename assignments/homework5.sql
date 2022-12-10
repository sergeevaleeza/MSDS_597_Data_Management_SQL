/*
Question 1
Let's compare the combo genres "Rom-Com" and "Dramedy" by their
average rating (average of avg_vote) and # of movies. Only use
movies with at least 10,000 votes as part of this analysis.
Definitions:
"Rom-Com" = A movie with both "Comedy" and "Romance" in the genre
"Dramedy" = A movie with both "Comedy" and "Drama" in the genre
If a movie has "Comedy", "Romance" AND "Drama" in the genre, it should
count in both categories.
You will create a new field called "combo_genre" which contains either
"Rom-Com" or "Dramedy".
Provide the output sorted by "combo_genre" alphabetically.
Hint:  Calculate the two "combo_genre" in separate queries and UNION the results
together
*/

SELECT combo_genre,
       ROUND(AVG(avg_vote),2) AS avg_rating,
       COUNT(original_title) AS num_movies
FROM (
SELECT CASE WHEN (LOWER(genre) LIKE '%drama%' AND
                 LOWER(genre) LIKE '%comedy%') THEN 'Dramedy' END AS combo_genre,
       avg_vote,
       original_title
           FROM movies
           WHERE (LOWER(genre) LIKE '%drama%' AND
                 LOWER(genre) LIKE '%comedy%') AND
                 votes >= 10000
UNION
SELECT CASE WHEN (LOWER(genre) LIKE '%romance%' AND
                 LOWER(genre) LIKE '%comedy%') THEN 'Rom-Com' END AS combo_genre,
       avg_vote,
       original_title
           FROM movies
           WHERE (LOWER(genre) LIKE '%romance%' AND
                 LOWER(genre) LIKE '%comedy%') AND
                 votes >= 10000) a
GROUP BY 1
ORDER BY 1;

+-----------+----------+----------+
|combo_genre|avg_rating|num_movies|
+-----------+----------+----------+
|Dramedy    |6.86      |1248      |
|Rom-Com    |6.48      |817       |
+-----------+----------+----------+
/*
Question 2
Provide a list of the top 10 movies (by votes) where the cast (actors/actresses)
has at least
4 members and the cast consists only of actresses (no actors).
The columns you should report are "original_title", "avg_vote" and "votes",
all from the "movies" table.
Consider only movies with at least 10,000 votes.
Hint: Consider writing a subquery to filter to the
imdb_title_id of movies that fit this criteria.
This subquery should involve the following:
- joins between actors, title_principals, and movies
- filters to actor/actress only and movies with votes >= 10000
- group by imdb_title_id
- conditions in the HAVING clause that match the aggregate conditions you need
(i.e. at least 4 actors/actresses combined and no actors)
*/

SELECT original_title,
       AVG(avg_vote) as avg_vote,
       votes
FROM (
    SELECT original_title,
       votes,
        AVG(avg_vote) as avg_vote,
       SUM(cast_count) AS total_cast,
       COUNT(CASE WHEN lower(category) LIKE '%actress%' THEN 1 ELSE 0 END) AS total_actress
    FROM (
        SELECT
            original_title,
            category,
            avg_vote,
            votes,
            SUM(CASE WHEN lower(category) LIKE '%actress%' THEN 1
               WHEN lower(category) LIKE '%actor%' THEN 1
               ELSE 0 END) AS cast_count
        FROM title_principals t
            INNER JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
            INNER JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
            INNER JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
        WHERE votes >= 10000
        GROUP BY 1, 2, 3, 4) a
    HAVING SUM(total_cast) >= 4
    GROUP BY 1, 2) b
HAVING total_cast >= 4 AND
      total_actress >= 1 AND
       COUNT(cast_count) >= 4
GROUP BY 1, 3
ORDER BY 3 DESC
;



+------------------------------------------+--------
|original_title                  |avg_vote|votes|
+------------------------------------------+--------
|The Help                       |8       |419566|
|Pitch Perfect                  |7.2     |271720|
|Sucker Punch                   |6       |227259|
|Ghostbusters                   |5.2     |200067|
|The Descent                    |7.2     |196964|
|Ocean's Eight                  |6.2     |177206|
|Girl, Interrupted              |7.3     |160231|
|He's Just Not That Into You    |6.4     |159672|
|Pitch Perfect 2                |6.4     |139566|
|Birds of Prey: And the Fantabulous Emancipation of One Harley Quinn|6.1     |137373|
+-------------------------------------------------------------------+--------
/*
Question 3
What is the consensus worst movie for each production company?
Find the movie with the most votes but with avg_vote <= 5 for each production
company.
Provide the top 10 movies ordered by votes (from highest to lowest)
Hint: Use an analytic function to find the top voted movie per production company
 */

SELECT original_title,
       production_company,
       avg_vote,
       votes,
       RANK() OVER(PARTITION BY production_company ORDER BY votes DESC) rank
FROM (SELECT original_title,
       production_company,
       avg_vote,
       votes,
       RANK() OVER(PARTITION BY production_company ORDER BY votes DESC) rank
FROM movies
WHERE avg_vote <= 5) a
WHERE rank = 1
ORDER BY votes DESC
LIMIT 10
;

+---------------------------+-------------------------+--------+------+----+
|original_title             |production_company       |avg_vote|votes |rank|
+---------------------------+-------------------------+--------+------+----+
|Fifty Shades of Grey       |Focus Features           |4.1     |293277|1   |
|The Twilight Saga: New Moon|Temple Hill Entertainment|4.7     |260695|1   |
|Batman & Robin             |Warner Bros.             |3.7     |230579|1   |
|The Twilight Saga: Eclipse |Summit Entertainment     |5       |223170|1   |
|The Happening              |Twentieth Century Fox    |5       |193156|1   |
|After Earth                |Columbia Pictures        |4.8     |189179|1   |
|Wild Wild West             |Peters Entertainment     |4.9     |150995|1   |
|The Last Airbender         |Paramount Pictures       |4       |149673|1   |
|Epic Movie                 |Regency Enterprises      |2.4     |100874|1   |
|Meet the Spartans          |New Regency Pictures     |2.8     |100614|1   |
+---------------------------+-------------------------+--------+------+----+
/*
Question 4
What was the longest gap between movies published by "Marvel Studios"?
Use "date_published" as the date.
Return the gap as a field called "gap_length" that is an Interval data type
calculated by using the AGE() function.
AGE() documentation can be found here:
https://www.postgresql.org/docs/current/functions-datetime.html
Hint: Use an analytic function to align each Marvel movie with the movie
released immediately prior to it.
*/

SELECT original_title,
       date_published,
       ROW_NUMBER() over (order by date_published) as RowNum,
       (SELECT original_title,
       date_published,
       ROW_NUMBER() over (order by date_published) as RowNum
FROM movies m2
           LEFT JOIN m.RowNum ON m2.RowNum - 1) as next_date
FROM (
SELECT original_title,
       date_published,
       ROW_NUMBER() over (order by date_published) as RowNum
FROM movies
WHERE LOWER(production_company) LIKE '%marvel studios%') m;

SELECT original_title,
       date_published,
       prev_original_title,
       prev_date_published,
       AGE(DATE(date_published), DATE(prev_date_published)) AS gap_length
FROM (
SELECT m2.original_title AS original_title,
       m2.date_published AS date_published,
       m1.original_title AS prev_original_title,
       m1.date_published AS prev_date_published,
       ROW_NUMBER() over (order by m1.date_published) as RowNum
FROM (SELECT original_title,
             date_published,
             production_company,
             ROW_NUMBER() over (order by date_published) as RowNum
    FROM movies
    WHERE LOWER(production_company) LIKE '%marvel studios%') m1
JOIN  (SELECT original_title,
             date_published,
              production_company,
             ROW_NUMBER() over (order by date_published) as RowNum
    FROM movies
    WHERE LOWER(production_company) LIKE '%marvel studios%') m2
ON m1.RowNum = m2.RowNum - 1
WHERE LOWER(m1.production_company) LIKE '%marvel studios%') a
ORDER BY gap_length DESC
LIMIT 1;

+--------------------------+--------------+-----------------------
+-------------------+----------------------------------------------+
|original_title            |date_published|prev_original_title    |
prev_date_published|gap_length                                    |
+--------------------------+--------------+-----------------------
+-------------------+----------------------------------------------+
|Captain America: Civil War|2016-05-04    |Avengers: Age of Ultron|2015-04-22
|1 years 0 mons 12 days 0 hours 0 mins 0.0 secs|
+--------------------------+--------------+-----------------------
+-------------------+----------------------------------------------+
/*
Question 5
Of all Zoe Saldana movies (movies where she is listed in the actors column of the
movies table),
what is the % of total worldwide gross income contributed by each movie?
Round the % to 2 decimal places, sort from highest % to lowest %,
and return the top 10.
Numerator = worlwide_gross_income for each Zoe Saldana movie
Denominator = total worlwide_gross_income for all Zoe Saldana movies
Filter out any movies with null worlwide_gross_income
Hint: Use an analytic function to place the total (denominator) on each row
to make the calculation easy
*/

SELECT original_title,
       ROUND((worlwide_gross_income / (SELECT SUM(ROUND(CAST(
                                           (TRIM('$ ' FROM worlwide_gross_income))
                                           AS NUMERIC), 1)) as total_gross_income
                                FROM movies
                                WHERE worlwide_gross_income IS NOT NULL AND
                                LOWER(actors) LIKE '%zoe saldana%') * 100), 2) AS pct_total_gross_income
FROM (
SELECT original_title,
       ROUND(CAST(
           (TRIM('$ ' FROM worlwide_gross_income))
                   AS NUMERIC), 1) as worlwide_gross_income,
       SUM(CAST(
           (TRIM('$ ' FROM worlwide_gross_income))
                   AS NUMERIC)) AS total_income
FROM movies
WHERE worlwide_gross_income IS NOT NULL AND
      LOWER(actors) LIKE '%zoe saldana%'
GROUP BY 1,2) a
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 10;
+------------------------------+----------------------+
|original_title                |pct_total_gross_income|
+------------------------------+----------------------+
|Avengers: Endgame             |24.44                 |
|Avatar                        |24.38                 |
|Avengers: Infinity War        |17.89                 |
|Guardians of the Galaxy Vol. 2|7.55                  |
|Guardians of the Galaxy       |6.75                  |
|Star Trek Into Darkness       |4.08                  |
|Star Trek                     |3.37                  |
|Star Trek Beyond              |3                     |
|The Terminal                  |1.91                  |
|Vantage Point                 |1.33                  |
+------------------------------+----------------------+




SELECT original_title
FROM movies
WHERE votes > 100000 AND
      avg_vote < 5 AND
      date_published LIKE '%%%%-07-04';

SELECT original_title
FROM movies
WHERE votes > 100000 AND
      avg_vote < 5 AND
      date_published LIKE '%%%%-07-04';


SELECT year
FROM (
SELECT year,
       COUNT(original_title) AS num_movies,
       ROUND(AVG(avg_vote), 1) AS avg_rating
FROM movies
WHERE votes > 10000 AND
      LOWER(genre) LIKE '%comedy%'
GROUP BY 1) a
WHERE num_movies > 100 AND
      avg_rating <= 6.1;


SELECT (SELECT COUNT(original_title) AS action_7
FROM movies
WHERE lower(genre) LIKE '%action%') action_all

FROM (
         SELECT COUNT(original_title) AS action_7
         FROM movies
         WHERE lower(genre) LIKE '%action%'
           AND avg_vote >= 7
           AND votes > 10000;


SELECT ROUND((SUM(action_7) / SUM(action_all) * 100.0), 0) AS pct_total
FROM (
         SELECT (SELECT COUNT(original_title) AS action_all
                 FROM movies
                 WHERE lower(genre) LIKE '%action%'),
                (SELECT COUNT(original_title) AS action_7
                 FROM movies
                 WHERE lower(genre) LIKE '%action%'
                   AND avg_vote >= 7
                   AND votes > 10000)) a;

Useful for calculating % of total
- SUM(CASE WHEN brand = ‘Toyota’ THEN sales ELSE 0 END) * 100.0 / SUM(sales)

SELECT SUM(CASE WHEN lower(genre) LIKE '%action%' THEN 1 ELSE 0 END) * 100.0 / SUM(genre)
FROM movies;


(SELECT COUNT(original_title) AS action_7
 FROM movies
 WHERE lower(genre) LIKE '%action%'
   AND avg_vote >= 7
   AND votes > 10000)
/ (SELECT COUNT(original_title) AS action_all
FROM movies
WHERE lower(genre) LIKE '%action%')

SELECT production_company,
       avg_vote,
       director,
       votes,
       RANK() OVER (PARTITION BY production_company ORDER BY votes DESC) rank
FROM movies
WHERE votes IS NOT NULL
LIMIT 10;


SELECT production_company,
       votes,
       RANK() OVER (PARTITION BY production_company ORDER BY votes DESC) rank
FROM movies
WHERE votes IS NOT NULL
ORDER BY votes DESC
LIMIT 10;


WITH cte_1 AS
         (SELECT production_company,
                 RANK() OVER (ORDER BY SUM(votes) DESC)
          FROM movies m
             WHERE votes IS NOT NULL
             GROUP BY 1
             LIMIT 3
         ),
     cte_2 AS
         (SELECT director,
                 RANK() OVER (ORDER BY SUM(votes) DESC)
          FROM movies m
             WHERE votes IS NOT NULL
             GROUP BY 1
             LIMIT 3
         )
SELECT *
FROM movies
WHERE production_company LIKE cte_1.production_company AND
      director LIKE cte_2.director;

SELECT *
FROM movies m
INNER JOIN movies m2 ON m.production_company =
    (SELECT production_company,
                 RANK() OVER (ORDER BY SUM(votes) DESC)
          FROM movies m
             WHERE votes IS NOT NULL
             GROUP BY 1
             LIMIT 3);



SELECT production_company,
       SUM(votes) as total_votes,
       RANK() OVER (ORDER BY SUM(votes) DESC) AS p
FROM movies
GROUP BY production_company
ORDER BY 2 DESC
LIMIT 3;

SELECT director,
       SUM(votes) as total_votes,
       RANK() OVER (ORDER BY SUM(votes) DESC) AS p
FROM movies
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

SELECT original_title,
       avg_vote
FROM movies
WHERE production_company LIKE 'Warner Bros.' OR
      production_company LIKE  'Universal Pictures' OR
      production_company LIKE 'Paramount Pictures' AND
      director LIKE 'Steven Spielberg' AND
      director LIKE 'Christopher Nolan' AND
      director LIKE 'Quentin Tarantino'
ORDER BY avg_vote;

SELECT
       SUM(CASE WHEN female > male AND young > old THEN 1 ELSE 0 END) AS young_female_over,
       SUM(CASE WHEN female > male AND old > young THEN 1 ELSE 0 END) AS old_female_over,
       SUM(CASE WHEN male > female AND young > old THEN 1 ELSE 0 END) AS young_male_over,
       SUM(CASE WHEN male > female AND old > young THEN 1 ELSE 0 END) AS old_male_over
FROM (
SELECT original_title,
       males_allages_avg_vote    as male,
       females_allages_avg_vote  as female,
       allgenders_45age_avg_vote as old,
       allgenders_18age_avg_vote as young
FROM movies m
         LEFT OUTER JOIN ratings r ON m.imdb_title_id = r.imdb_title_id
WHERE votes > 10000 AND
      production_company LIKE 'Warner Bros.'
GROUP BY 1, 2, 3, 4, 5) a;

QUESTION 11 AND 29