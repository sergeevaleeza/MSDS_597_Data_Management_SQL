/*
 Question 1
 Find the top 5 movies ordered by the most 1 star votes.
 Provide the original_title, avg_vote, and votes_1
 */

SELECT
    m."original_title",
       m."avg_vote",
       r."votes_1"
FROM ratings r
LEFT JOIN movies m
ON m."imdb_title_id" = r."imdb_title_id"
GROUP BY 1, 2, 3
ORDER BY 3 DESC
LIMIT 5;

+--------------------+--------+-------+
|original_title      |avg_vote|votes_1|
+--------------------+--------+-------+
|Fifty Shades of Grey|4.1     |68500  |
|The Promise         |6       |67368  |
|Reis                |1.4     |57667  |
|Twilight            |5.2     |56521  |
|Disaster Movie      |1.9     |52692  |
+--------------------+--------+-------+


/*
 Question 2
 Find the top 10 movies featuring Tom Hanks or Morgan Freeman as an actor (by avg_vote).
 Break ties with original_title in alphabetical order.
 Provide the columns name, characters, original_title, and avg_vote
 */

SELECT a."name",
       tm."characters",
       tm."original_title",
       tm."avg_vote"
FROM actors a
LEFT JOIN (
    SELECT *
    FROM title_principals t
        LEFT JOIN (
            SELECT *
            FROM movies m
            ) m
    ON t."imdb_title_id" = m."imdb_title_id") tm
ON a."imdb_name_id" = tm."imdb_name_id"
WHERE LOWER("name") LIKE '%morgan freeman%' OR
      LOWER("name") LIKE '%tom hanks%'
ORDER BY 4 DESC, 3
LIMIT 10;

+--------------+----------------------------+------------------------+--------+
|name          |characters                  |original_title          |avg_vote|
+--------------+----------------------------+------------------------+--------+
|Morgan Freeman|["Ellis Boyd 'Red' Redding"]|The Shawshank Redemption|9.3     |
|Tom Hanks     |["Forrest Gump"]            |Forrest Gump            |8.8     |
|Tom Hanks     |["Captain Miller"]          |Saving Private Ryan     |8.6     |
|Morgan Freeman|["Somerset"]                |Se7en                   |8.6     |
|Tom Hanks     |["Paul Edgecomb"]           |The Green Mile          |8.6     |
|Tom Hanks     |["Woody"]                   |Toy Story               |8.3     |
|Tom Hanks     |["Woody"]                   |Toy Story 3             |8.3     |
|Morgan Freeman|["Ned Logan"]               |Unforgiven              |8.2     |
|Tom Hanks     |["Carl Hanratty"]           |Catch Me If You Can     |8.1     |
|Morgan Freeman|["Eddie Scrap-Iron Dupris"] |Million Dollar Baby     |8.1     |
+--------------+----------------------------+------------------------+--------+

/*
 Question 3
 Find the actors that have played James Bond more than once
 List the start and end years of their James Bond tenure (year of first movie, year of last movie)
 Provide the number of James Bond movies each actor acted in, as well as the average avg_rating of their Bond movies.
 Sort the output by the number of Bond movies (most to least), followed by the avg_rating (highest to lowest)

 Note: If you would like to see the movie titles, you can use ARRAY_AGG to compile the movie titles into an array.  But
 don't include this in the output.

 */

SELECT jb.name,
       MIN(jb.year) AS start_year,
       MAX(jb.year) AS end_year,
       COUNT(jb.original_title) AS num_movies,
       ROUND(AVG(jb.avg_vote),1) AS avg_rating
FROM (
    SELECT
       name,
       year,
       original_title,
       avg_vote
    FROM title_principals t
        INNER JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
        INNER JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
        INNER JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    WHERE LOWER(t."characters") LIKE '%james bond%') jb
GROUP BY 1
ORDER BY 4 DESC, 5 DESC
LIMIT 5;


+--------------+----------+--------+----------+----------+
|name          |start_year|end_year|num_movies|avg_rating|
+--------------+----------+--------+----------+----------+
|Sean Connery  |1962      |1983    |7         |7         |
|Roger Moore   |1973      |1985    |7         |6.7       |
|Daniel Craig  |2006      |2015    |4         |7.3       |
|Pierce Brosnan|1995      |2002    |4         |6.6       |
|Timothy Dalton|1987      |1989    |2         |6.7       |
+--------------+----------+--------+----------+----------+



/*
Questions 4, 5, and 6 will be similarly structured.
You can largely use the same query, but make small adjustments to answer each question.

Question 4
Find the top 5 movies rated higher by the Female 18-30 age group as compared to the Male 18-30 age group.
Use the females_18age_avg_vote and males_18age_avg_vote fields.
Only consider movies that have at least 10,000 votes from each of those demographic categories.
Show the original_title, females_18age_avg_vote, males_18age_avg_vote, and the delta between the two, aliased f_m_difference.
Sort by the difference (highest to lowest), then by original_title (alphabetically)
*/

SELECT original_title,
       females_18age_avg_vote,
       males_18age_avg_vote,
       (females_18age_avg_vote - males_18age_avg_vote) AS f_m_difference
FROM (
    SELECT
        *
    FROM title_principals t
        INNER JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
        INNER JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
        INNER JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    ) all_imdb
WHERE females_18age_votes > 10000 AND
      males_18age_votes > 10000
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 5;


+-----------------------------------------+----------------------+--------------------+--------------+
|original_title                           |females_18age_avg_vote|males_18age_avg_vote|f_m_difference|
+-----------------------------------------+----------------------+--------------------+--------------+
|Fifty Shades Darker                      |5.4                   |4.1                 |1.3           |
|The Twilight Saga: Breaking Dawn - Part 1|5.7                   |4.4                 |1.3           |
|The Twilight Saga: Breaking Dawn - Part 2|6.2                   |5                   |1.2           |
|Anastasia                                |8                     |6.9                 |1.1           |
|Fifty Shades of Grey                     |4.8                   |3.7                 |1.1           |
+-----------------------------------------+----------------------+--------------------+--------------+


/*
Question 5
Find the top 5 movies rated higher by the Male 18-30 age group as compared to the Female 18-30 age group.
Use the females_18age_avg_vote and males_18age_avg_vote fields.
Only consider movies that have at least 10,000 votes from each of those demographic categories.
Show the original_title, females_18age_avg_vote, males_18age_avg_vote, and the delta between the two, aliased m_f_difference.
Sort by the difference (highest to lowest), then by original_title (alphabetically)
*/

SELECT original_title,
       males_18age_avg_vote,
       females_18age_avg_vote,
       (males_18age_avg_vote - females_18age_avg_vote) AS m_f_difference
FROM (
    SELECT
        *
    FROM title_principals t
        INNER JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
        INNER JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
        INNER JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    ) all_imdb
WHERE females_18age_votes > 10000 AND
      males_18age_votes > 10000
GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 5;

+----------------------+--------------------+----------------------+--------------+
|original_title        |males_18age_avg_vote|females_18age_avg_vote|m_f_difference|
+----------------------+--------------------+----------------------+--------------+
|Spring Breakers       |5.5                 |4.8                   |0.7           |
|Dumb and Dumber       |7.3                 |6.7                   |0.6           |
|Superbad              |7.7                 |7.1                   |0.6           |
|Ted                   |7.1                 |6.5                   |0.6           |
|The 40 Year Old Virgin|7.1                 |6.5                   |0.6           |
+----------------------+--------------------+----------------------+--------------+



/*
Question 6
Find the top 5 movies rated higher by the 45+ age group (both M/F) as compared to the 18-30 age group (both M/F).
Use females_18age_avg_vote, males_18age_avg_vote, females_45age_avg_vote, males_45age_avg_vote fields.
To create an average for an age group, just sum the M and the F avg_vote and divide by 2.

Only consider movies that have at least 10,000 votes from each of the 4 demographic categories.
Show the original_title, avg_vote_18_30, avg_vote_45plus, and the delta between the two.
Sort by the delta (highest to lowest), then by original_title (alphabetically)
*/

SELECT original_title,
       ((males_18age_avg_vote + females_18age_avg_vote) / 2) AS avg_vote_18_30,
       ((males_45age_avg_vote + females_45age_avg_vote) / 2) AS avg_vote_45plus,
       (((males_45age_avg_vote + females_45age_avg_vote) / 2) - ((males_18age_avg_vote + females_18age_avg_vote) / 2)) AS delta
FROM (
    SELECT
        *
    FROM title_principals t
        INNER JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
        INNER JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
        INNER JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    ) all_imdb
WHERE females_18age_votes > 10000 AND
      males_18age_votes > 10000 AND
      females_45age_votes > 10000 AND
      males_45age_votes > 10000

GROUP BY 1, 2, 3
ORDER BY 4 DESC, 1
LIMIT 5;

+-----------------------+--------------+---------------+-----+
|original_title         |avg_vote_18_30|avg_vote_45plus|delta|
+-----------------------+--------------+---------------+-----+
|Jaws                   |7.65          |8.25           |0.6  |
|The Wizard of Oz       |7.85          |8.45           |0.6  |
|Blade Runner           |7.85          |8.4            |0.55 |
|Raiders of the Lost Ark|8.15          |8.65           |0.5  |
|Alien                  |8.15          |8.6            |0.45 |
+-----------------------+--------------+---------------+-----+

/*
Question 7
Compare the heights of actors/actresses in basketball movies to non-basketball movies
A "basketball movie" is a movie with the word "basketball" in the description.
Only consider movies with at least 10,000 votes and people in the "actor" or "actress" categories.
Also filter to only actors/actresses that have a height listed.

In your results, return the following:
movie_type  (either "Basketball Movie" or "Non-Basketball Movie")
num_movies  (count of movies)
num_actors  (count of actors/actresses)
avg_height  (average height rounded to one decimal place)
*/

SELECT
       CASE WHEN LOWER(description) LIKE '%basketball%' THEN 'Basketball Movie'
           ELSE 'Non-Basketball Movie'
       END AS movie_type,
       COUNT(DISTINCT original_title) AS num_movies,
       SUM(CASE WHEN category IS NOT NULL THEN 1 ELSE 0 END) AS num_actors,
       ROUND(AVG(height), 1) AS avg_height
FROM (
    SELECT
           original_title,
           height,
           category,
           description,
           votes
    FROM title_principals t
        JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
        JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
        JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    WHERE height IS NOT NULL AND
          votes >= 10000 AND
          (LOWER(category) LIKE 'actor' OR
          LOWER(category) LIKE 'actress')
          ) all_data
GROUP BY 1
;


+--------------------+----------+----------+----------+
|movie_type          |num_movies|num_actors|avg_height|
+--------------------+----------+----------+----------+
|Basketball Movie    |20        |69        |176.6     |
|Non-Basketball Movie|8326      |8645      |175.3     |
+--------------------+----------+----------+----------+


/*
Question 8
Find the top 5 actresses in Drama movies as ranked by the average rating (rounded to 2 decimals) by the top 1000 reviewers
Provide the name, total_votes (by the top1000 voters), and avg_rating (by the top1000 voters)
Only consider the actresses with at least 10,000 total top 1000 votes (across all their movies)
Sort the output by the avg_rating (highest to lowest)
*/

SELECT
       name,
       total_votes,
       avg_rating
FROM (
    SELECT
           name,
           SUM(top1000_voters_votes) AS total_votes,
           ROUND(AVG(top1000_voters_rating), 2) AS avg_rating
    FROM title_principals t
        JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
        JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
        JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    WHERE LOWER(category) LIKE 'actress' AND
          LOWER(genre) LIKE '%drama%'
    GROUP BY 1
          ) top1000_v
WHERE total_votes >= 10000
GROUP BY 1, 2, 3
ORDER BY 3 DESC
LIMIT 5;

+------------------+-----------+----------+
|name              |total_votes|avg_rating|
+------------------+-----------+----------+
|Scarlett Johansson|10765      |6.47      |
|Bette Davis       |11997      |6.44      |
|Cate Blanchett    |12709      |6.3       |
|Jodie Foster      |10935      |6.27      |
|Kate Winslet      |11236      |6.24      |
+------------------+-----------+----------+


/*
 Question 9
 List the top 5 actors and actresses that have acted in the most 8+ movies as a % of their total 10,000+ vote movies
 (i.e. actors/actresses with the highest 8+ avg_vote rate)
 Only consider movies with at least 10,000 votes
 Only consider actors/actresses who have acted in at least 10 movies (with at 10K votes)

 Provide the following:
 name
 num_8plus_movies (count of movies with a >= 8 avg_vote and at least 10,000 votes)
 num_total_movies (count of movies with at least 10,000 votes)
 pct_8plus_movies (num_8plus_movies/num_total_movies rounded to 1 decimal place)
 */

SELECT name,
       COUNT(num_8plus_movies) AS num_8plus_movies,
       COUNT(num_total_movies) AS num_total_movies,
       ROUND(COUNT(num_8plus_movies) * 100.0 / (COUNT(num_total_movies)), 1) AS pct_8plus_movies
FROM
(
    SELECT name,
           original_title,
           avg_vote,
           SUM(CASE WHEN avg_vote >= 8 THEN 1 END) AS num_8plus_movies,
           COUNT(original_title) AS num_total_movies
    FROM title_principals t
             JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
             JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
             JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    WHERE (LOWER(category) LIKE 'actress' OR
           LOWER(category) LIKE 'actor') AND
          votes >= 10000
    GROUP BY 1, 2, 3
    ) all_data
GROUP BY 1
HAVING COUNT(original_title) >= 10
ORDER BY 4 DESC
LIMIT 5;



+--------------+----------------+----------------+----------------+
|name          |num_8plus_movies|num_total_movies|pct_8plus_movies|
+--------------+----------------+----------------+----------------+
|Toshirô Mifune|10              |12              |83.3            |
|Aamir Khan    |10              |19              |52.6            |
|Anthony Quinn |5               |11              |45.5            |
|James Stewart |8               |18              |44.4            |
|Tabu          |4               |10              |40              |
+--------------+----------------+----------------+----------------+



/*
 Question 10
 List the top 10 movies by number of child actors in them.  Child actors are defined as actors/actresses with an age
 less than 18 on the date the movie was published (date_published).
 Sort the output by the num_child_actors (highest to lowest) and then by original_title (alphabetically)

 Only consider actors/actresses with a properly formatted date_of_birth (xxxx-xx-xx)
 Only consider movies with a properly formatted date_published (xxxx-xx-xx)
 Only consider movies with at least 10,000 votes

 Hint: Use the AGE function to find the difference between two timestamps.
 https://www.postgresql.org/docs/14/functions-datetime.html

 */

SELECT
       all_data.original_title,
       SUM(CASE
         WHEN  EXTRACT(year from all_data.years_old) < 18 THEN 1 ELSE 0 END) AS num_child_actors
FROM
(
    SELECT name,
           original_title,
           DATE(date_of_birth) as date_of_birth,
           DATE(date_published) as date_published,
           AGE(DATE(date_published), DATE(date_of_birth)) AS years_old,
           votes
    FROM title_principals t
             JOIN movies m ON m."imdb_title_id" = t."imdb_title_id"
             JOIN actors a ON a."imdb_name_id" = t."imdb_name_id"
             JOIN ratings r ON r."imdb_title_id" = t."imdb_title_id"
    WHERE LENGTH(date_of_birth) = 10 AND
          LENGTH(date_published) = 10 AND
          date_of_birth LIKE '%%%%-%%-%%' AND
          date_published LIKE '%%%%-%%-%%' AND
          votes >= 10000
    ) all_data
GROUP BY 1
ORDER BY 2 DESC, 1
LIMIT 10;

+-------------------------+----------------+
|original_title           |num_child_actors|
+-------------------------+----------------+
|Dare mo shiranai         |4               |
|Elephant                 |4               |
|Monster House            |4               |
|Stand by Me              |4               |
|The Goonies              |4               |
|Unaccompanied Minors     |4               |
|3 Ninjas                 |3               |
|Critters 3               |3               |
|Die unendliche Geschichte|3               |
|Earth to Echo            |3               |
+-------------------------+----------------+
