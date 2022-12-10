/*
Question 1
List the name and height of the actresses who have been married to Tom Cruise
Order by name alphabetically
*/

SELECT
       name,
       height
FROM
     imdb.actors
WHERE
      spouses_string LIKE '%Tom Cruise%'
LIMIT 3;

/*
Question 2
List the name, # of spouses, and # of divorces of the top 5 actors by number of divorces.  
If two actors have the same number of divorces, break ties by ordering by name alphabetically
 */

SELECT
       name,
       spouses,
       divorces
FROM
     imdb.actors
ORDER BY
         divorces DESC
LIMIT 5;

/*
Question 3
The original title, year, genre, country, average rating, and number of votes of
the top 5 (by avg_rating) Horror movies made in the USA with at least 10,000 votes.
Break ties in avg_rating with the original_title (alphabetically).
 */

SELECT
       original_title,
       year,
       genre,
       country,
       avg_vote,
       votes
FROM
     imdb.movies
WHERE
      genre LIKE '%Horror%' AND
      country LIKE '%USA%' AND
      votes >= 10000
ORDER BY
         avg_vote DESC,
         original_title ASC
LIMIT 5;

/*
Question 4
Name, date of birth, and place of birth of the
top 10 youngest living actors who were born on Feb 29 in the USA.
Order by youngest to oldest, then by name alphabetically.
*/

SELECT
       name,
       date_of_birth,
       place_of_birth
FROM
     imdb.actors
WHERE
      date_of_birth LIKE '%-02-29' AND
      place_of_birth LIKE '%USA%'
ORDER BY
         date_of_birth DESC
LIMIT 10;

/*
Question 5
What is the original title and duration of the longest movie made by the production company 'Marvel Studios'?
Rename the column 'original_title' to 'movie_title' and 'duration' to 'length_in_minutes'
 */

SELECT
       original_title AS movie_title,
       duration AS length_in_minutes
FROM
     imdb.movies
WHERE
      production_company LIKE '%Marvel Studios%'
ORDER BY
         length_in_minutes DESC
LIMIT 1;

/*
Question 6
Which production companies have made movies with at least an avg_vote of 8.8 over at least 100,000 votes?
Return the list in alphabetical order.
*/

SELECT DISTINCT
                production_company
FROM
     imdb.movies
WHERE
      avg_vote >= 8.8 AND
      votes >= 100000
ORDER BY
         production_company ASC;

/*
Question 7
List the movies published between Christmas 2017 (2017-12-25) and New Years 2018 (2018-01-01)
Only include movies with at least 10,000 votes.
Order them by avg_vote, highest to lowest.
*/

SELECT
       original_title,
       date_published,
       avg_vote
FROM
     imdb.movies
WHERE
      votes >= 10000 AND
      date_published >= '2017-12-25' AND
      date_published <= '2018-01-01'
ORDER BY
         avg_vote DESC;

/*
Question 8
Find the original_title, year, budget, and world-wide gross income of the
top 5 highest world-wide grossing zombie movies
Hint: You may need to use LTRIM to trim the '$ ' from worldwide_gross_income
*/

SELECT
       original_title,
       year,
       budget,
       worlwide_gross_income
FROM
     movies
WHERE
      LOWER(description) LIKE '%zombie%' AND
      budget LIKE '%$%' AND
      worlwide_gross_income LIKE '%$%'
ORDER BY
    CAST(
        (TRIM('$ ' FROM worlwide_gross_income))
        AS NUMERIC
        ) DESC
LIMIT 5;

/*
Question 9
Find the top 10 actors by height (order by name, alphabetically, to break ties in height)
List the name, height (renamed to height_cm), and height_ft, which is height in feet/inches (e.g. 6 feet 5 inches),
rounded to the nearest inch.
There are 2.54 cm in 1 inch.  There are 12 inches in one foot.
Exclude any actors with a height >= 300 (as I believe there are some data errors)

Hint: To convert from one data type to another, use CAST(x AS <desired data type>)
You can use VARCHAR (for strings), INT (for integers), NUMERIC or DECIMAL (for floats)
*/

SELECT
       name,
       height AS height_cm,
       concat(floor(height / (2.54 * 12)), ' feet ',
              round(height / 2.54) % 12, ' inches') AS height_ft
FROM
     actors
WHERE
      height <= 300
ORDER BY
         height_cm DESC,
         name
LIMIT 10;

/*
Question 10
List the original_title, usa_gross_income, worlwide_gross_income, and pct_gross_income_usa,
defined as the percentage of USA gross income out of total income,
for Tom Hanks movies.  Return the lowest 10 movies only by pct_gross_income_usa (i.e. the 10 movies that
had the lowest pct_gross_income_usa).
Round pct_gross_income_usa to one decimal place.
*/

SELECT
       original_title,
       usa_gross_income,
       worlwide_gross_income,
       ROUND(
           (ROUND(
               CAST(
                   (TRIM('$ ' FROM usa_gross_income))
                   AS NUMERIC), 1) /
            ROUND(
                CAST(
                    (TRIM('$ ' FROM worlwide_gross_income))
                    AS NUMERIC), 1) * 100
               ), 1)
           AS pct_gross_income_usa
FROM
     imdb.movies
WHERE
      LOWER(director) LIKE '%tom hanks%' OR
      LOWER(actors) LIKE '%tom hanks%'
ORDER BY
         pct_gross_income_usa ASC
LIMIT 10;





